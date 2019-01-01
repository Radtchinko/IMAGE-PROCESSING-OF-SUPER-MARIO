function Image = fillBlue(Image,fixedImage,mObj,MarioP)
  MarioP = [ceil(MarioP(1)) ceil(MarioP(2))];
  for y=MarioP(2):MarioP(2)+size(mObj,1)-1
    for x=MarioP(1):MarioP(1)+size(mObj,2)-1
      if Image(y,x,1)==95 && Image(y,x,2)==151 && Image(y,x,3)==255
        Image(y,x,:) = fixedImage(y,x,:);
      endif
    endfor
  endfor
endfunction