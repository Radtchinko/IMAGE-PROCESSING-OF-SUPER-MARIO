function [Action,MarioP,ground,air,wall,acenc,incaseAction,EnemyKilled] = RightUpAction(MarioP,Enemy_lst,Wall_lst,ground,air,wall,EnemyKilled)
  Action = -2;
  act = 0; acenc = 3; incaseAction = 0;
  for i=1:length(Enemy_lst)
    if (MarioP(1)+80>=Enemy_lst(i).BoundingBox(1)) && ((MarioP(1)+80)<=(Enemy_lst(i).BoundingBox(1)+Enemy_lst(i).BoundingBox(3))) && ~EnemyKilled(i)
      if ((MarioP(2)+35)>=Enemy_lst(i).BoundingBox(2)) && ((MarioP(2)+35)<=Enemy_lst(i).BoundingBox(2)+Enemy_lst(i).BoundingBox(4))
        Action = -1;
        incaseAction = Enemy_lst(i);
        EnemyKilled(i) = 1;
        act = 1;
        break;
      endif
    endif
  endfor
  
  if ~act
    takeAction = 0;
    for i=1:length(Wall_lst)
      if (MarioP(1)+80)>=(Wall_lst(i).BoundingBox(1)) && ((MarioP(1)+80)<=(Wall_lst(i).BoundingBox(1)+Wall_lst(i).BoundingBox(3)))
        if ((MarioP(2)+35)>=Wall_lst(i).BoundingBox(2)) && ((MarioP(2)+35)<=Wall_lst(i).BoundingBox(2)+Wall_lst(i).BoundingBox(4))
          Action = 2;
          takeAction = 1;
          MarioP(2)-=70;
          ground = 0;
          air = 1;
          wall = 0;
          break;
        endif
      endif
    endfor
    
    if ~takeAction
      Action = 0;
      MarioP(1)+=70;
      acenc = 0;
      %if wall
      %  MarioP(2)+=70;
      %  acenc = 1;
      %endif
      
      %if wall
      %  MarioP(2)+=70;
      %endif
      
      if wall
        while true
          isitWall = 0;
          for i=1:length(Wall_lst)
            if ((MarioP(1)+ceil((MarioP(1)+80)/2)>=Wall_lst(i).BoundingBox(1)) && (MarioP(1)+ceil((MarioP(1)+80)/2)<=(Wall_lst(i).BoundingBox(1)+Wall_lst(i).BoundingBox(3)))) || ((Wall_lst(i).BoundingBox(1)>=MarioP(1)) && (Wall_lst(i).BoundingBox(1)<=(MarioP(1)+30)))
              if ((MarioP(2)+80)>=Wall_lst(i).BoundingBox(2))
                isitWall = 1;
                break;
              endif
            endif
          endfor
          
          
          if isitWall
            acenc = 1;
            wall = 1;
            ground = 0;
            air = 0;
            break;
          endif
          
          
          maxY = 0;
          for i=1:length(Wall_lst)
            if (Wall_lst(i).BoundingBox(2)+Wall_lst(i).BoundingBox(4))>=maxY
              maxY = (Wall_lst(i).BoundingBox(2)+Wall_lst(i).BoundingBox(4));
            endif
          endfor
          
          MarioP(2)+=70;
          
          if (MarioP(2)+100)>maxY
            wall = 0;
            ground = 1;
            air = 0;
            acenc = 0;
            break;
          endif
          
        endwhile
      endif
    endif
  endif
endfunction