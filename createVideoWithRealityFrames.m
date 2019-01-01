function Stat = createVideoWithRealityFrames(MarioP,Castle_lst,path,Attacklist,ListMarioPx,ListMarioPy)
  mkdir RealityFrames;
  iFrame = 1;
  Image = imread(['Actionframes/frame1.png']);
  %imwrite(Image,['RealityFrames/frame',num2str(iFrame),'.png']);
  fixedImage = imread('testcase3.png');
  Orig = imread('OriginalTestcase3.png');
  mObj = imread('Mario.png');
  sky = Image(1:size(mObj,1),1:size(mObj,2),:);
  congrats = imread('congrats.jpg');
  congrats = imresize(congrats,[size(Image,1) size(Image,2)]);
  
  vk = 1;
  oldMarioP = MarioP; vMarioP = 0; stCastle = 0; prevAscent = 1;
  vprevAscent = prevAscent;
  for i=1:length(path)
    switcherX = 0;
    NextMarioP = [ListMarioPx(i) ListMarioPy(i)];
    
    while (MarioP(1)~=NextMarioP(1)) || (MarioP(2)~=NextMarioP(2))
      switcherX = 1;
      imwrite(Image,['RealityFrames/frame',num2str(iFrame),'.png']);
      iFrame+=1;
      
      
      if MarioP(1)<NextMarioP(1)
        MarioP(1)+=5;
        prevAscent = 1;
      elseif MarioP(1)>NextMarioP(1)
        MarioP(1)-=5;
        prevAscent = 2;
      elseif MarioP(2)<NextMarioP(2)
        MarioP(2)+=5;
      elseif MarioP(2)>NextMarioP(2)
        MarioP(2)-=5;
      endif
      
      
      if prevAscent~=vprevAscent
        mObj = flipdim(mObj,2);
      endif
      vprevAscent = prevAscent;
      
      
      
      if ((((MarioP(1)+25)>=Castle_lst(1).BoundingBox(1)) && ((MarioP(1)+25)<=(Castle_lst(1).BoundingBox(1)+Castle_lst(1).BoundingBox(3))) && (MarioP(2)>=Castle_lst(1).BoundingBox(2)) && (MarioP(2)<=(Castle_lst(1).BoundingBox(2)+Castle_lst(1).BoundingBox(4)))) && prevAscent==1) || ((((MarioP(1)+20)>=Castle_lst(1).BoundingBox(1)) && ((MarioP(1)+20)<=(Castle_lst(1).BoundingBox(1)+Castle_lst(1).BoundingBox(3))) && (MarioP(2)>=Castle_lst(1).BoundingBox(2)) && (MarioP(2)<=(Castle_lst(1).BoundingBox(2)+Castle_lst(1).BoundingBox(4)))) && prevAscent==2)
        if ~stCastle
          Image(oldMarioP(2):oldMarioP(2)+size(mObj,1)-1,oldMarioP(1):oldMarioP(1)+size(mObj,2)-1,:) = sky;
          Image(MarioP(2):MarioP(2)+size(mObj,1)-1,MarioP(1):MarioP(1)+size(mObj,2)-1,:) = mObj;
          stCastle = 1;
          vMarioP = MarioP;
        else
          Image(vMarioP(2):vMarioP(2)+size(mObj,1)-1,vMarioP(1):vMarioP(1)+size(mObj,2)-1,:) = fixedImage(vMarioP(2):vMarioP(2)+size(mObj,1)-1,vMarioP(1):vMarioP(1)+size(mObj,2)-1,:);
          Image(MarioP(2):MarioP(2)+size(mObj,1)-1,MarioP(1):MarioP(1)+size(mObj,2)-1,:) = mObj;
          vMarioP = MarioP;
        endif
        Image = fillBlue(Image,fixedImage,mObj,MarioP);
      else
        if stCastle
          Image(vMarioP(2):vMarioP(2)+size(mObj,1)-1,vMarioP(1):vMarioP(1)+size(mObj,2)-1,:) = fixedImage(vMarioP(2):vMarioP(2)+size(mObj,1)-1,vMarioP(1):vMarioP(1)+size(mObj,2)-1,:);
          Image(MarioP(2):MarioP(2)+size(mObj,1)-1,MarioP(1):MarioP(1)+size(mObj,2)-1,:) = mObj;
          stCastle = 0;
          oldMarioP = MarioP;
        else
          Image(oldMarioP(2):oldMarioP(2)+size(mObj,1)-1,oldMarioP(1):oldMarioP(1)+size(mObj,2)-1,:) = sky;
          Image(MarioP(2):MarioP(2)+size(mObj,1)-1,MarioP(1):MarioP(1)+size(mObj,2)-1,:) = mObj;
          oldMarioP = MarioP;
        endif
      endif
    endwhile
    
    if ~switcherX
      Attack = Attacklist(vk);
      vk+=1;
      for k=1:14
        if (k==8)
          Image(Attack.BoundingBox(2)-5:Attack.BoundingBox(2)+Attack.BoundingBox(4),Attack.BoundingBox(1)-5:Attack.BoundingBox(1)+Attack.BoundingBox(3)+5,:) = Orig(Attack.BoundingBox(2)-5:Attack.BoundingBox(2)+Attack.BoundingBox(4),Attack.BoundingBox(1)-5:Attack.BoundingBox(1)+Attack.BoundingBox(3)+5,:);
        endif
        imwrite(Image,['RealityFrames/frame',num2str(iFrame),'.png']);
        iFrame+=1;
      endfor
    endif
  endfor
  
  
  imwrite(Image,['RealityFrames/frame',num2str(iFrame),'.png']);
  iFrame+=1;
  for i=1:10
    imwrite(congrats,['RealityFrames/frame',num2str(iFrame),'.png']);
    iFrame+=1;
  endfor
  
  a = dir(['RealityFrames' '/*.png']);
  l = size(a,1);
  aviObj = avifile("MarioMovie.avi");
  for k = 1 : l
    this_image = imread(['RealityFrames/frame',num2str(k),'.png']);
    addframe(aviObj, this_image/255);
  endfor
  close(aviObj);
  stat = "Done";
  rmdir "Actionframes";
  rmdir "RealityFrames";
endfunction