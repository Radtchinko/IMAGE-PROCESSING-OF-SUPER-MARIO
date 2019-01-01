function [new_image] =remove_background(orgimag,testimag)
orgimag=resize(orgimag,size(testimag));
Image = imabsdiff(orgimag,testimag);
SE1 = strel('square', 19);
EI = imerode(Image, SE1);
DI = imdilate(EI, SE1);
gray_image = rgb2gray(DI);
new_image = im2bw(gray_image,0);
end

%test1 && test3
%SE = strel('square', 19);
%EI = imerode(Image, SE);
%DI = imdilate(EI, SE);
%test2
%SE = strel('square', 12);
%EI = imerode(Image, SE);
