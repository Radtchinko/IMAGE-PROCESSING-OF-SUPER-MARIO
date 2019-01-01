function [minheight,minwidth,maxheight,maxwidth] =find_smallest_largest_boundry_box(obj_regionprops,num)
  minheight=1000;
  minwidth=1000;
  maxheight=0;
  maxwidth=0;
  for i=1:num
     w=obj_regionprops(i).BoundingBox(3);
     h=obj_regionprops(i).BoundingBox(4);
      if h>maxheight
        maxheight=h;
        maxwidth=w;
     elseif h==maxheight
         if w>maxwidth
            maxwidth=w;
         end
      end
     if h<minheight
        minheight=h;
        minwidth=w;
     elseif h==minheight
         if w<minwidth
            minwidth=w;
         end
      end
   end
 end
  