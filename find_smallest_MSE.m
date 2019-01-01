function [num]=find_smallest_MSE(img,mario,wall,enemy)
  smallest_mse=100000000.0;
  num=0;
  err1 = immse(img,resize(mario,size(img)));
  err3 = immse(img,resize(wall,size(img)));
  err4 = immse(img,resize(enemy,size(img)));
  if err1<smallest_mse
    num=1;
    smallest_mse=err1;
   end
  if err3<smallest_mse
    smallest_mse=err3;
    num=3;
    end
  if err4<smallest_mse
    smallest_mse=err4;
    num=4;
    end
 end
  
  