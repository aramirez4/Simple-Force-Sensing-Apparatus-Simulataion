function [J]=Jacob(s)
global P 

%Jacobian
% x= P.L(1)cos(s1) +P.L(2)*cos(s1+s2)
% y= P.L(1)sin(s1) + P.L(2)*sin(s1+s2)

J=[-P.L(1)*sin(s(1))-P.L(2)*sin(s(1)+s(2)), -P.L(2)*sin(s(1)+s(2));...
    P.L(1)*cos(s(1))+P.L(2)*cos(s(1)+s(2)), P.L(2)*cos(s(1)+s(2))];
end
