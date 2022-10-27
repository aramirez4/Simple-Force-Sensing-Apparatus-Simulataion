function [td,desire]=minjerkpath(xi,yi,xf,yf,d)
%Creates the minimal jerk path trajectory based on the initail x and y
%position, the expected time duration for the movement to be completed and 
%the desired x and y positions(xf,yf). Formulas used are based on the work 
%of Flash and Hogan(1985). For better a better understanding refer to
%http://courses.shadmehrlab.org/Shortcourse/minimumjerk.pdf


td=0:.01:d;

i=1;
xd=zeros(length(td'),1);
yd=zeros(length(td'),1);
for t=0:.01:d
 
xd(i)=xi +(xf-xi)*((10*(t/d)^3)-(15*(t/d)^4)+(6*(t/d)^5));
yd(i)=yi +(yf-yi)*((10*(t/d)^3)-(15*(t/d)^4)+(6*(t/d)^5));

i=i+1;
end
desire=[xd,yd];
td=td';
end