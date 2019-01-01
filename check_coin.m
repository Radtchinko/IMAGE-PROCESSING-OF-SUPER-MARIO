function [check]=check_coin(img)
  %250, 151, 26
  %warning('off','all');
  sz=size(img);
  check=0;
  for i=1:sz(1)
    if check==1
       break;
      end
     for j=1:sz(2)
          if img(i,j,1)==250&&img(i,j,2)==151&&img(i,j,3)==26
             check=1;
             break;
           end
     end
   end
 end