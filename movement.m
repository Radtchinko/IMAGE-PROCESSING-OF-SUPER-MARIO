function [PathWithActions,score,Attacklist,ListMarioPx,ListMarioPy] = movement(ImageSize,Mario,Castle_lst,Coin_lst,Enemy_lst,Wall_lst)
  
  PathWithActions = []; Attacklist = []; ListMarioPx = []; ListMarioPy = [];
  iFrame = 1;
  
  mObj = imread('Mario.png');
  Image = imread('testcase3.png');
  fixedImage = imread('testcase3.png');
  Orig = imread('OriginalTestcase3.png');
  sky = Image(1:size(mObj,1),1:size(mObj,2),:);
  
  mkdir Actionframes;
  imwrite(Image,['Actionframes/frame',num2str(iFrame),'.png']);
  iFrame+=1;
  %figure('Position',[500, -50, 900, 700]);
  %imshow(Image);
  %pause(0.8);
  Attack = 0; ActionDecoded = "nope";
  %figure;
  %imshow(Image);
  Actiontaken = 0;
  visted = ones(length(Coin_lst),1);
  ground = 1; air = 0; wall = 0; MarioP = [Mario(1).BoundingBox(1),Mario(1).BoundingBox(2)];
  LastAction = 0; score = 0; prevAscent = 1; groundOrWall = 0;
  stCastle = 0; vMarioP = 0;
  
  for i=1:length(Wall_lst)
    if ((MarioP(1)>=Wall_lst(i).BoundingBox(1)) && (MarioP(1)<=(Wall_lst(i).BoundingBox(1)+Wall_lst(i).BoundingBox(3)))) || ((Wall_lst(i).BoundingBox(1)>=MarioP(1)) && (Wall_lst(i).BoundingBox(1)<=(MarioP(1)+15)))
      if ((MarioP(2)+80)>=Wall_lst(i).BoundingBox(2))
        ground = 0;
        wall = 1;
        groundOrWall = 1;
        break;
      endif
    endif
  endfor
  
  
  EnemyKilled = zeros(length(Enemy_lst),1);
  oldMarioP = MarioP;
  vprevAscent = prevAscent;
  while true
    dist = [];
    for i=1:length(Coin_lst)
      diffx = (MarioP(1)-Coin_lst(i).BoundingBox(1)).^2;
      diffy = (MarioP(2)-Coin_lst(i).BoundingBox(2)).^2;
      total_dist = sqrt(diffx+diffy);
      dist = [dist total_dist];
    endfor
    
    [mindists indxs] = min(dist.*visted);
    if ~length(Coin_lst)
      break;
    endif
    indx = sort(indxs)(1);
    mindist = mindists(indx);
    if mindist==inf
      break
    endif
    
    if Coin_lst(indx).BoundingBox(1)>MarioP(1)
      prevAscent = 1;
    elseif Coin_lst(indx).BoundingBox(1)<MarioP(1)
      prevAscent = 2;
    endif
    
    if (MarioP(1)+80>=Coin_lst(indx).BoundingBox(1)) && (MarioP(1)+80<=(Coin_lst(indx).BoundingBox(1)+Coin_lst(indx).BoundingBox(3))) && (((Coin_lst(indx).BoundingBox(2)>=MarioP(2)) && (Coin_lst(indx).BoundingBox(2)<=(MarioP(2)+70))) || ((MarioP(2)>=Coin_lst(indx).BoundingBox(2)) && (MarioP(2)<=(Coin_lst(indx).BoundingBox(2)+Coin_lst(indx).BoundingBox(4)))))
      MarioP(1)+=70;
      PathWithActions = [PathWithActions 0]; %Right
      visted(indx) = inf;
      score+=10;
      LastAction = 0;
      Actiontaken = 1;
    
    
    elseif (MarioP(1)-50>=Coin_lst(indx).BoundingBox(1)) && (MarioP(1)-50<=(Coin_lst(indx).BoundingBox(1)+Coin_lst(indx).BoundingBox(3))) && (((Coin_lst(indx).BoundingBox(2)>=MarioP(2)) && (Coin_lst(indx).BoundingBox(2)<=(MarioP(2)+70))) || ((MarioP(2)>=Coin_lst(indx).BoundingBox(2)) && (MarioP(2)<=(Coin_lst(indx).BoundingBox(2)+Coin_lst(indx).BoundingBox(4)))))
      MarioP(1)-=70;
      PathWithActions = [PathWithActions 1]; %Left
      visted(indx) = inf;
      score+=10;
      LastAction = 0;
      Actiontaken = 1;
    
    
    elseif (MarioP(2)-50>=Coin_lst(indx).BoundingBox(2)) && (MarioP(2)-50<=(Coin_lst(indx).BoundingBox(2)+Coin_lst(indx).BoundingBox(4))) && (((Coin_lst(indx).BoundingBox(1)>=MarioP(1)) && (Coin_lst(indx).BoundingBox(1)<=(MarioP(1)+70))) || ((MarioP(1)>=Coin_lst(indx).BoundingBox(1)) && (MarioP(1)<=(Coin_lst(indx).BoundingBox(1)+Coin_lst(indx).BoundingBox(3)))))
      MarioP(2)-=70;
      ground = 0;
      air = 1;
      wall = 0;
      LastAction = 1;
      PathWithActions = [PathWithActions 2]; %Up
      visted(indx) = inf;
      score+=10;
      Actiontaken = 1;
    
    
    elseif LastAction==1
      MarioP(2)+=70;
      PathWithActions = [PathWithActions 3]; %Down
      air = 0;
      LastAction = 0;
      if (groundOrWall==0)
        ground = 1;
        wall = 0;
      elseif (groundOrWall==1)
        ground = 0;
        wall = 1;
      endif
    
    
    elseif LastAction==2
        ground = 0;
        air = 0;
        wall = 1;
        groundOrWall = 1;
      if prevAscent==1
        MarioP(1)+=70;
        PathWithActions = [PathWithActions 0]; %Right
      else
        MarioP(1)-=70;
        PathWithActions = [PathWithActions 1]; %Left
      endif
      LastAction = 0;
    
    elseif Coin_lst(indx).BoundingBox(1)>MarioP(1) && (ground || wall)
      [Action,MarioP,ground,air,wall,acenc,incaseAction,EnemyKilled] = RightUpAction(MarioP,Enemy_lst,Wall_lst,ground,air,wall,EnemyKilled);
      if acenc~=3
        groundOrWall = acenc;
      endif
      PathWithActions = [PathWithActions Action];
      LastAction = 0;
      if Action==-1
        Actiontaken = -1;
        Attack = incaseAction;
        Attacklist = [Attacklist Attack];
      elseif Action==2
        LastAction = 2;
      else
        prevAscent = 1;
      endif
      
    
    elseif Coin_lst(indx).BoundingBox(1)<MarioP(1) && (ground || wall)
      [Action,MarioP,ground,air,wall,acenc,incaseAction,EnemyKilled] = LeftUpAction(MarioP,Enemy_lst,Wall_lst,ground,air,wall,EnemyKilled);
      if acenc~=3
        groundOrWall = acenc;
      endif
      PathWithActions = [PathWithActions Action];
      LastAction = 0;
      if Action==-1
        Actiontaken = -1;
        Attack = incaseAction;
        Attacklist = [Attacklist Attack];
      elseif Action==2
        LastAction = 2;
      else
        prevAscent = 2;
      endif
    endif
    
    
    if prevAscent~=vprevAscent
      mObj = flipdim(mObj,2);
    endif
    vprevAscent = prevAscent;
    
    
    if Actiontaken==-1
      Image(Attack.BoundingBox(2)-5:Attack.BoundingBox(2)+Attack.BoundingBox(4),Attack.BoundingBox(1)-5:Attack.BoundingBox(1)+Attack.BoundingBox(3)+5,:) = Orig(Attack.BoundingBox(2)-5:Attack.BoundingBox(2)+Attack.BoundingBox(4),Attack.BoundingBox(1)-5:Attack.BoundingBox(1)+Attack.BoundingBox(3)+5,:);
      Actiontaken = 0;
    elseif Actiontaken==1
      Image(MarioP(2)-3:MarioP(2)+size(mObj,1),MarioP(1)-5:MarioP(1)+size(mObj,2)+5,:) = Orig(MarioP(2)-3:MarioP(2)+size(mObj,1),MarioP(1)-5:MarioP(1)+size(mObj,2)+5,:);
      Image(MarioP(2):MarioP(2)+size(mObj,1)-1,MarioP(1):MarioP(1)+size(mObj,2)-1,:) = mObj;
      Image(oldMarioP(2):oldMarioP(2)+size(mObj,1)-1,oldMarioP(1):oldMarioP(1)+size(mObj,2)-1,:) = sky;
      oldMarioP = MarioP;
      Actiontaken = 0;
    else
      if ((((MarioP(1)+25)>=Castle_lst(1).BoundingBox(1)) && ((MarioP(1)+25)<=(Castle_lst(1).BoundingBox(1)+Castle_lst(1).BoundingBox(3))) && (MarioP(2)>=Castle_lst(1).BoundingBox(2)) && (MarioP(2)<=(Castle_lst(1).BoundingBox(2)+Castle_lst(1).BoundingBox(4)))) && prevAscent==1) || ((((MarioP(1)+20)>=Castle_lst(1).BoundingBox(1)) && ((MarioP(1)+20)<=(Castle_lst(1).BoundingBox(1)+Castle_lst(1).BoundingBox(3))) && (MarioP(2)>=Castle_lst(1).BoundingBox(2)) && (MarioP(2)<=(Castle_lst(1).BoundingBox(2)+Castle_lst(1).BoundingBox(4)))) && prevAscent==2)
        if ~stCastle
          Image(MarioP(2):MarioP(2)+size(mObj,1)-1,MarioP(1):MarioP(1)+size(mObj,2)-1,:) = mObj;
          Image(oldMarioP(2):oldMarioP(2)+size(mObj,1)-1,oldMarioP(1):oldMarioP(1)+size(mObj,2)-1,:) = sky;
          stCastle = 1;
          vMarioP = MarioP;
        else
          Image(MarioP(2):MarioP(2)+size(mObj,1)-1,MarioP(1):MarioP(1)+size(mObj,2)-1,:) = mObj;
          Image(vMarioP(2):vMarioP(2)+size(mObj,1)-1,vMarioP(1):vMarioP(1)+size(mObj,2)-1,:) = fixedImage(vMarioP(2):vMarioP(2)+size(mObj,1)-1,vMarioP(1):vMarioP(1)+size(mObj,2)-1,:);
          vMarioP = MarioP;
        endif
        Image = fillBlue(Image,fixedImage,mObj,MarioP);
      else
        if stCastle
          Image(MarioP(2):MarioP(2)+size(mObj,1)-1,MarioP(1):MarioP(1)+size(mObj,2)-1,:) = mObj;
          Image(vMarioP(2):vMarioP(2)+size(mObj,1)-1,vMarioP(1):vMarioP(1)+size(mObj,2)-1,:) = fixedImage(vMarioP(2):vMarioP(2)+size(mObj,1)-1,vMarioP(1):vMarioP(1)+size(mObj,2)-1,:);
          stCastle = 0;
          oldMarioP = MarioP;
        else
          Image(MarioP(2):MarioP(2)+size(mObj,1)-1,MarioP(1):MarioP(1)+size(mObj,2)-1,:) = mObj;
          Image(oldMarioP(2):oldMarioP(2)+size(mObj,1)-1,oldMarioP(1):oldMarioP(1)+size(mObj,2)-1,:) = sky;
          oldMarioP = MarioP;
        endif
      endif
    endif
    %%if (oldMarioP(1)<=Castle_lst(1).BoundingBox(1)) || (oldMarioP(1)>=(Castle_lst(1).BoundingBox(1)+Castle_lst(1).BoundingBox(3)))
    %%  Image(oldMarioP(2):oldMarioP(2)+size(mObj,1)-1,oldMarioP(1):oldMarioP(1)+size(mObj,2)-1,:) = sky;
    %%else
    %%  Image(oldMarioP(2):oldMarioP(2)+size(mObj,1)-1,oldMarioP(1):oldMarioP(1)+size(mObj,2)-1,:) = mObj;
    %%endif
    if ~PathWithActions(end)
      ActionDecoded = "Right";
    elseif PathWithActions(end)==1
      ActionDecoded = "Left";
    elseif PathWithActions(end)==2
      ActionDecoded = "UP";
    else
      ActionDecoded = "Down";
    endif
    
    %imwrite(Image,['Actionframes/frame',num2str(iFrame),'.png']);
    %iFrame+=1;
    figure('Position',[500, -50, 900, 700]);
    title(ActionDecoded);
    imshow(Image);
    %pause(0.6);
    ListMarioPx = [ListMarioPx MarioP(1)];
    ListMarioPy = [ListMarioPy MarioP(2)];
  endwhile
  
  goal = (length(Coin_lst)*10);
  CastleGate = [Castle_lst(1).BoundingBox(1)+145 Castle_lst(1).BoundingBox(2)+180];
  [PathWithActions Attacklist ListMarioPx ListMarioPy] = ReachCastle(ListMarioPx,ListMarioPy,Attacklist,iFrame,Castle_lst,Image,PathWithActions,LastAction,Actiontaken,prevAscent,groundOrWall,ground,air,wall,MarioP,CastleGate,Enemy_lst,Wall_lst,score,goal);
endfunction