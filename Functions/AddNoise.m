function [B] = AddNoise(Btrue,noisetype,nl,varargin)
% Addnoise: add noise to an image dependent on noise type and level
% Btrue - given image
% noisetype : type of noise
% nl : noiselevel
% showres 1 to look at the old and new versions of the noise
if nargin<4
    showres=0;
else
    showres=varargin{1};
end
switch noisetype
    case 'gaussian'
        snrvec=[10 25 40];
         B = imnoise(Btrue, 'gaussian');
        e = B-Btrue;
         %e = randn(size(Btrue)); % noise vector
        eta = abs(10^-(snrvec(nl)/20))*norm(Btrue,'fro')/norm(e,'fro');
        E = eta*e;
        if showres
            Eold = randn(size(Btrue))*nl;Bold=Eold+Btrue;
            figure, tiledlayout('flow'), nexttile, imshow(Btrue, []),title('Btrue'),
            nexttile, imshow(Bold, []), title(['B first from old gaussian',num2str(snr(Btrue, Bold))])
            nexttile, imshow(Btrue+E,[]),title(['B second Error scaled to given SNR',num2str(snr(Btrue, Btrue+E))])
        end
    case 'oldgaussian'
        E = randn(size(Btrue))*nl;
    case 'poisson'
        % means of pixel values scaled by 1e12 (would be 1e6 if single precision)
        snrvec=[10 25 40];
        B = imnoise(Btrue, 'poisson');
        e = B-Btrue;
        eta = abs(10^-(snrvec(nl)/20))*norm(Btrue,'fro')/norm(e,'fro');
        E = eta*e;
        if showres
            figure, tiledlayout('flow'), nexttile, imshow(Btrue, []),title('Btrue'),
            nexttile, imshow(B, []), title(['B first from imnoise',num2str(snr(Btrue, B))])
            nexttile, imshow(Btrue+E,[]),title(['B second Error scaled to given SNR',num2str(snr(Btrue, Btrue+E))])
        end
    case 'oldpoisson'
        % means of pixel values scaled by 1e12 (would be 1e6 if single precision)
        B = imnoise(Btrue, 'poisson');
        E = B-Btrue;
        E=nl*(E/max(E(:))); %scale the E to max 1
    case 'salt & pepper'
        %nl relates to a density, nl % of images are set to 1 - do not take
        %less than 1e-4
        noiselevel=[2e-1,2e-2,5e-3];
        noiselevel=[2e-1,2e-1,2e-1];
        snrvec=[10 25 40];
        B=imnoise(Btrue,'salt & pepper');%,noiselevel(nl));
        E=B-Btrue;
        eta = abs(10^-(snrvec(nl)/20))*norm(Btrue,'fro')/norm(E,'fro');
        E = eta*E;
        err=norm(E,'fro');
        if showres
            figure, tiledlayout('flow'), nexttile, imshow(Btrue, []),title('Btrue'),
            nexttile, imshow(B, []), title(['B first from imnoise',num2str(snr(Btrue, B))])
            nexttile, imshow(Btrue+E,[]),title(['B second Error scaled to given SNR',num2str(snr(Btrue, Btrue+E))])
        end
        if err==0
            display(['nl is too small, and E is zero, increase nl from ',num2str(nl)])
        end
end
B =Btrue+ E;
snrval=20*log10(norm(Btrue(:))/norm(E(:)));
end