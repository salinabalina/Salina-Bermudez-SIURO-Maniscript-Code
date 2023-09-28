function [B] = AddNoise(Btrue,noisetype,nl,varargin)
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
        eta = abs(10^-(snrvec(nl)/20))*norm(Btrue,'fro')/norm(e,'fro');
        E = eta*e;
        if showres
            Eold = randn(size(Btrue))*nl;Bold=Eold+Btrue;
            figure, tiledlayout('flow'), nexttile, imshow(Btrue, []),title('Btrue'),
            nexttile, imshow(Bold, []), title(['B first from old gaussian',num2str(snr(Btrue, Bold))])
            nexttile, imshow(Btrue+E,[]),title(['B second Error scaled to given SNR',num2str(snr(Btrue, Btrue+E))])
        end
    case 'poisson'
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
    case 'salt & pepper'
        noiselevel=[2e-1,2e-2,5e-3];
        noiselevel=[2e-1,2e-1,2e-1];
        snrvec=[10 25 40];
        B=imnoise(Btrue,'salt & pepper');
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
