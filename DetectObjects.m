function [ImageSize,Mario,Castle_lst,Coin_lst,Enemy_lst,Wall_lst] = DetectObjects()
  pkg load image;
  orgimag = imread('OriginalTestcase3.png');
  testimag = imread('testcase3.png');
  ImageSize = size(testimag);
  %figure;
  %imshow(testimag);
  b_value=check_coin(testimag);
  new_image=remove_background(orgimag,testimag);
  Mario=[];Wall_lst=[];Enemy_lst=[];Coin_lst=[];Castle_lst=[];
  % result info:1->mario, 2->coin ,3->wall, 4->enemy, 5->castle
  %figure;
  %imshow(new_image);
  [mario,coin,wall,enemy,castle] =read_object_images();
  % BoundingBox
  [l num] = bwlabel(new_image);
  obj_regionprops = regionprops(l,'BoundingBox','Area');
  % 1->mario 2->coin 3->wall 4->enemy 5->castle order in boundry box
  [minheight,minwidth,maxheight,maxwidth] =find_smallest_largest_boundry_box(obj_regionprops,num);
  lgnored_regions=[];
  lgnored_regions(10000)=0;
  nn=num;
  if(maxheight>310&&maxwidth>310)
    for i=1:nn
      x=obj_regionprops(i).BoundingBox(1);
      y=obj_regionprops(i).BoundingBox(2);
      w=obj_regionprops(i).BoundingBox(3);
      h=obj_regionprops(i).BoundingBox(4);
      obj=testimag((y:y+h),(x:x+w),:);
      if(maxheight==h && maxwidth==w)
        obj=testimag((y:y+h),(x:x+w),:);
        obj=rgb2gray(obj);
        len=size(obj);
        old=obj(1,1);
        value=1;
        for v2=2:len(2)
          if(obj(1,v2)!=old)
            value=v2;
            break;
          end
          old=obj(1,v2);
        end
        maxheight=300;maxwidth=300;
        lgnored_regions(i)=1;
        num+=1;
        x1=obj_regionprops(num).BoundingBox(1)=x+value-63;
        y1=obj_regionprops(num).BoundingBox(2)=y;
        w1=obj_regionprops(num).BoundingBox(3)=300;
        h1=obj_regionprops(num).BoundingBox(4)=300; 
        X=[num2str(num),' ',num2str(x1),' ',num2str(y1),' ',num2str(w1),' ',num2str(h1)];
        %disp(X);
        obj=testimag((y1:y1+h1),(x1:x1+w1),:);
        % figure;
        % imshow(obj);
        num+=1;
        x1=obj_regionprops(num).BoundingBox(1)=x;
        y1=obj_regionprops(num).BoundingBox(2)=y+300+1;
        w1=obj_regionprops(num).BoundingBox(3)=w;
        h1=obj_regionprops(num).BoundingBox(4)=h-301; 
        obj=testimag((y1:y1+h1),(x1:x1+w1),:);
        X=[num2str(num),' ',num2str(x1),' ',num2str(y1),' ',num2str(w1),' ',num2str(h1)];
        %disp(X);
        %figure;
        %imshow(obj);
      end
    end
  end
  nn=num;
  for i=1:nn
    if(lgnored_regions(i)==0)
      % figure;
      % imshow(testimag((y:y+h),(x,x+w),:);
      i;
      obj_regionprops(i);
      x=obj_regionprops(i).BoundingBox(1);
      y=obj_regionprops(i).BoundingBox(2);
      w=obj_regionprops(i).BoundingBox(3);
      h=obj_regionprops(i).BoundingBox(4); 
      if (w>80||h>80) && (w!=maxwidth &&h!=maxheight)
        %figure;
        % imshow(testimag((y:y+h),(x:x+w),:));
        lgnored_regions(i)=1;
        X=[num2str(w),' ',num2str(h)];
        %disp(X);
        %disp(num2str(i))
        [nh nw]=updates_size_divide_seventen(h,w);
        X=[num2str(nh),' ',num2str(nw)];
        %disp(X);
        w=nw; h=nh;  w/=72; h/=72 ;p1=1; p2=1; cnt=0;
        %disp(num2str(w*h));
        for r=1:h
          p1=1+cnt; cnt1=0;
          for c=1:w
            p2=1+cnt1;
            num+=1;
            obj_regionprops(num).BoundingBox(1)=x+p2;
            obj_regionprops(num).BoundingBox(2)=y+p1;
            obj_regionprops(num).BoundingBox(3)=72-1;
            obj_regionprops(num).BoundingBox(4)=72-1; 
            cnt1+=72;
          end
          cnt+=72;   
        end 
      end
    end
  end
  flag=0;
  for i=1:num
    x=obj_regionprops(i).BoundingBox(1);
    y=obj_regionprops(i).BoundingBox(2);
    w=obj_regionprops(i).BoundingBox(3);
    h=obj_regionprops(i).BoundingBox(4);
    if lgnored_regions(i)==1
      continue;
    end
    if h==minheight && w==minwidth && b_value==1
      X=['Boudry Box ',num2str(i),' is coin with x= ',num2str(x),' ,y= ',num2str(y),' ,width= ',num2str(w),' ,height= ',num2str(h)];
      Coin_lst=[Coin_lst,obj_regionprops(i)];
      obj=testimag((y:y+h),(x:x+w),:);
      %figure;
      %imshow(obj);
      %title('coin');
      %disp(X);
    elseif h==maxheight && w==maxwidth
      X=['Boudry Box ',num2str(i),' is castle with x= ',num2str(x),' ,y= ',num2str(y),' ,width= ',num2str(w),' ,height= ',num2str(h)];
      Castle_lst=[Castle_lst;obj_regionprops(i)];
      obj=testimag((y:y+h),(x:x+w),:);
      %figure;
      %imshow(obj);
      %title('castle');
      %disp(X);
    else
      sz=size(testimag);
      if(y+h >sz(1))
        h=sz(1)-y;
      end
      if(x+w >sz(2))
        w=sz(2)-x;
      end
      obj=testimag((y:y+h),(x:x+w),:);
      num_id=find_smallest_MSE(obj,mario,wall,enemy);
      if num_id==1  && flag==0
        flag=1;
        X=['Boudry Box ',num2str(i),' is mario with x= ',num2str(x),' ,y= ',num2str(y),' ,width= ',num2str(w),' ,height= ',num2str(h)];
        Mario=[Mario;obj_regionprops(i)];
        obj=testimag((y:y+h),(x:x+w),:);
        %figure;
        %imshow(obj);
        %title('mario');
        %disp(X);
      elseif num_id==3
        X=['Boudry Box ',num2str(i),' is wall with x= ',num2str(x),' ,y= ',num2str(y),' ,width= ',num2str(w),' ,height= ',num2str(h)];
        Wall_lst=[Wall_lst;obj_regionprops(i)];
        obj=testimag((y:y+h),(x:x+w),:);
        %figure;
        %imshow(obj);
        %title('wall');
        %disp(X);
      elseif num_id==4
        X=['Boudry Box ',num2str(i),' is enemy with x= ',num2str(x),' ,y= ',num2str(y),' ,width= ',num2str(w),' ,height= ',num2str(h)];
        Enemy_lst=[Enemy_lst;obj_regionprops(i)];
        obj=testimag((y:y+h),(x:x+w),:);
        %figure;
        %imshow(obj);
        %title('enemy');
        %disp(X);
      end
    end
  end
endfunction