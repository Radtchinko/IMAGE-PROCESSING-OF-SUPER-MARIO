function [nh,nw]=updates_size_divide_seventen(h,w) 
   m1=mod(h,72);
   m2=mod(w,72);
   nw=w;
   nh=h;
  if(m1!=0)
   nh=floor(h/72)+1;
   nh*=72;
   c1=h-72*floor(h/72);
   if(c1<nh-h)
      nh=72*floor(h/72);
   end
 end
  if(m2!=0)
   nw=floor(w/72)+1;
   nw*=72;
   c2=w-72*floor(w/72);
   if(c2<nw-w)
       nw=72*floor(w/72);
   end
 end

  
end