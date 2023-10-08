function [B] = AddNoise(Btrue,noisetype,nl,varargin)
%%
% Addnoise : add noise to an image dependent on noise type and level
% Inputs
%
% Btrue : blurred true image.
% noisetype : type of noise 'gaussian', 'poisson' or 'salt & pepper'
% nl : index 1, 2 or 3 for noiselevel - select snr from [10 25 40]
% varargin{1} - showres 1 to look at image with noise
%
% Outputs
% B : the contaminated image
%
% Update October 8, 2023. 
% Copyright: Salina Bermudez and Rosemary Renaut
%
%%
if nl>4 
    disp('Noise level set to 3: an SNR of 40')
    nl=3;
end
if nargin<4
    showres=0;
else
    showres=varargin{1};
end
snrvec=[10 25 40]; % fixed SNR used in the paper
switch noisetype
    case 'gaussian'
        B = imnoise(Btrue, 'gaussian'); %B : Image with blur and noise
        E = B-Btrue; %e : measure of noise added
        eta = abs(10^-(snrvec(nl)/20))*norm(Btrue,'fro')/norm(E,'fro');
        E = eta*E; %E : noise level by SNR values
    case 'poisson'
        B = imnoise(Btrue, 'poisson');
        E = B-Btrue;
        eta = abs(10^-(snrvec(nl)/20))*norm(Btrue,'fro')/norm(E,'fro');
        E = eta*E;
    case 'salt & pepper'
        B=imnoise(Btrue,'salt & pepper');
        E=B-Btrue;
        eta = abs(10^-(snrvec(nl)/20))*norm(Btrue,'fro')/norm(E,'fro');
        E = eta*E;
        err=norm(E,'fro');
        if err==0
            display(['nl is too small for salt and pepper noise, and E is zero, increase nl from ',num2str(nl)])
        end
end
B =Btrue+ E;
 if showres
            snrval=20*log10(norm(Btrue(:))/norm(E(:)));
            figure, tiledlayout('flow'), 
            nexttile, imshow(Btrue, []),title('Btrue'),
            nexttile, imshow(B, []), title(['B noisy SNR ',num2str(snrval)])
            nexttile, imshow(E,[]),title(['Error'])
end
end
