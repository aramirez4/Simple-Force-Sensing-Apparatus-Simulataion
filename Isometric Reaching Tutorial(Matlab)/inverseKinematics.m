function q=inverseKinematics(x,L)

% q=inverseKinematics(x)
% INVERSE KINEMATICS.
% q:  relative joint angles;
%	x:  endpoint position vectors where col1 is x and col 2 is y;
% L:  length of segments

q=zeros(size(x));                                   % initialize

c2=(x(:,1).^2 + x(:,2).^2 - L(1)^2 - L(2)^2) / ...
  (2 * L(1)* L(2));
s2=sqrt(1-c2.^2);
q(:,2)=acos(c2);
q(:,1)=atan2(x(:,2),x(:,1)) - atan2(L(2)*s2, L(1) + L(2)*c2);

end
