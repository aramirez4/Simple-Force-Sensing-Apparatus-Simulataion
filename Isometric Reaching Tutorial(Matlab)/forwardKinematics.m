function [tip,elbow]=forwardKinematics(q,L)
% [tip,elbow]=forwardKinematics(q)
% FORWARD KINEMATICS. 
% q:      relative joint angles;
%	tip:    endpoint position vectors where col1 is x and col 2 is y; 
%	elbow:  elbow position vectors where col1 is x and col 2 is y; 


elbow=[L(1)*cos(q(:,1)), L(1)*sin(q(:,1))];
tip=[L(1)*cos(q(:,1))+L(2)*cos(q(:,1)+q(:,2)), ...
     L(1)*sin(q(:,1))+L(2)*sin(q(:,1)+q(:,2))];
