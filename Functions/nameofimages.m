function [X,m,n] = nameofimages(m,n,T)
%%
% Produce a cell array with the  images
% Refer to the paper for websites with images that need to be obtained.
% Inputs : 
% m : desired size of the image in rows
% n: : desired size of the image in columns
% T : desired number of images (maximum is 40)
%
% Outputs: 
% X : cell array with the  images to be used for the paper
% m : actual size of the image in rows (wil be minimum over all images)
% n: : actual size of the image in columns  (wil be minimum over all images)
%
% Update October 8, 2023.
% Copyright: Salina Bermudez and Rosemary Renaut
%
%%
Y{1} = 'house.tiff';
Y{2} = '7.1.09.tiff';
Y{3} = '7.1.08.tiff';
Y{4} = '7.1.07.tiff';
Y{5} = '7.1.06.tiff';
Y{6} = '7.1.05.tiff';
Y{7} = '7.1.04.tiff';
Y{8} = '7.1.03.tiff';
Y{9} = 'mandi.tif';
Y{10}= '7.1.01.tiff';
Y{11}= '5.3.02.tiff';
Y{12}= '5.3.01.tiff';
Y{13}= '5.2.09.tiff';
Y{14}= '5.2.08.tiff';
Y{15}= '4.2.06.tiff';
Y{16}= '4.2.05.tiff';
Y{17}= '4.2.03.tiff';
Y{18}= '4.2.01.tiff';
Y{19}= 'boats512x512.tif';
Y{20}= 'bridge512x512.tif';
Y{21}= 'PIA19497.tif';
Y{22}= 'PIA18965.tif';
Y{23}= 'PIA18976.tif';
Y{24}= 'PIA18994.tif';
Y{25}= 'PIA18996.tif';
Y{26}= 'PIA19000.tif';
Y{27}= 'PIA19202.tif';
Y{28}= 'PIA19216.tif';
Y{29}= 'PIA19247.tif';
Y{30}= 'PIA19248.tif';
Y{31}= 'PIA19285.tif';
Y{32}= 'PIA19410.tif';
Y{33}= 'PIA19412.tif';
Y{34}= 'harbour512x512.tif';
Y{35}= 'PIA19420.tif';
Y{36}= 'PIA19422.tif';
Y{37}= 'peppers512x512.tif';
Y{38}= 'PIA19444.tif';
Y{39}= 'airfield512x512.tif';
Y{40}= '7.1.02.tiff';
if T>40
    disp('T too large only 40 images');
    return;
end
for j=1:T
    X{j}= double(im2gray(imread(Y{j}))); 
    [mX(j),nX(j)]=size(X{j});if mX(j)>nX(j), X{j}=transpose(X{j}); [mX(j),nX(j)]=size(X{j});end
end
% Smallest Image
m=min([mX,m]);n=min([nX,n]);
% Now put the images in the middle of the used image if possible
for j=1:T
    if mX(j)>m, dm(j)=floor((mX(j)-m)/2)+1;X{j}=X{j}(dm(j):dm(j)+m-1,:);end
    if nX(j)>n,   dn(j)=floor((nX(j)-n)/2)+1;  X{j}=X{j}(:, dn(j):dn(j)+n-1);   end
    [mX(j),nX(j)]=size(X{j});
end
m=min([mX,m]);n=min([nX,n]);
end