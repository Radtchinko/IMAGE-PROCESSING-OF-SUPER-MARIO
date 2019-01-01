a = dir(['Videoframes' '/*.png']);
l = size(a,1);
aviObj = avifile("ActionsMovie.avi");
for k = 1 : l
  this_image = imread(['Videoframes/frame',num2str(k),'.png']);
  addframe(aviObj, this_image/255);
end
close(aviObj);