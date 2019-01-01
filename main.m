clear all;
clc;
pkg load image;
warning('off','all');
pkg load video;
[ImageSize,Mario,Castle_lst,Coin_lst,Enemy_lst,Wall_lst] = DetectObjects();
[path score Attacklist ListMarioPx ListMarioPy] = movement(ImageSize,Mario,Castle_lst,Coin_lst,Enemy_lst,Wall_lst);
MarioP = [Mario(1).BoundingBox(1),Mario(1).BoundingBox(2)];
Stat = createVideoWithRealityFrames(MarioP,Castle_lst,path,Attacklist,ListMarioPx,ListMarioPy);
%decodedPath = [];
%for i=1:length(path)
%  if ~path(i)
%    decodedPath = [decodedPath;"Right"];
%  elseif path(i)==1
%    decodedPath = [decodedPath;"Left"];
%  elseif path(i)==2
%    decodedPath = [decodedPath;"Up"];
%  else
%    decodedPath = [decodedPath;"Down"];
%  endif
%endfor