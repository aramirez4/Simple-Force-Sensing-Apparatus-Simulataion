function sDot=dyn(t,s,force) 
%  sdot = dyn(t,s) 
%  state equations for the RK simulator. Calculates for current time t.
%        NOTE THAT t SHOULD BE A scalar (NOT AN ARRAY)
%   state  s = [q1, q2, q1dot, q2dot]' 
%%
global P torque tMove State
kd=-.75;k=20;

% torque=(Kp*e)+(Kd*s(3:4))+FFtorque;          % PD plus FF control

[J]=Jacob(s(1:2)); % Gets the jacobian from current joint angles
% Dampening matrix
D=[kd/3 0;...
    0 kd/3];


%% Torque controller
 torque=J'*force';
if State==4 
    tref=t-tMove;
    xd=interp1(P.td,P.xd,tref);
  
    for i=2:length(P.qd)    
            dt(i,1:2)=(P.qd(i,:)-P.qd(i-1,:))/.01;  % .01 is the time difference in P.td)
    end
    
    if tref<2.3
       
        qd=inverseKinematics(xd,P.L);  %% desired joint angles based on the Minimum Jerk trajectory
        qdot=interp1(P.td,dt,tref);
    else % did not make it to target in time
        qd=inverseKinematics(P.xd(length(P.xd),:),P.L);
        qdot=0; % should not be moving anymore so velocity zero
    end

       
        
    e=s(1:2)-qd';
    edot=s(3:4)-qdot';
    P.error=[e',edot'];
    torque=(-(k/45)*e)+edot*(kd)+torque+ D*s(3:4);  % The term added to the torque is to simulate a damper with coefficient kd
    
else

    torque=torque+ D*s(3:4);  % The term added to the torque is to simulate a damper with coefficient kd
end
%% Angle limits(Spring element)
if s(1) <=-.5  % Shoulder
    t1=-k*(s(1)-.1);
    if s(3)>0 && s(1)<=-.5
        d1=2*kd*s(3);
    else
        d1=0;
    end
    torque(1)=torque(1)+ t1+d1; 
end

if s(1) > (150*pi)/180 
    t1=-k*(s(1)-(150*pi/180));
    if s(3)<0 && s(1)>(130*pi)/180 
        d1=2*kd*s(3);
    else
        d1=0;
    end
    
    torque(1)=torque(1)+ t1+d1; 
end


if s(2) <=.3 % elbow
    t2=-k/4*(s(2)-.3) ;
  if s(4)>0 && s(2)<=.3
    d2=kd*s(4);
  else
      d2=0;
  end
    
    torque(2)=torque(2)+ t2+d2;

end

if s(2) > (150*pi)/180
    t2=-k*(s(2)-(150*pi/180));
    
    if s(4)<0 && s(2)>(120*pi)/180 
        d4=kd*s(4);
    else
        d4=0;
    end
    
  
    torque(2)=torque(2)+t2 +d4 ;
end

%% Forward dynamics (Equations of motion):
c2 = cos(s(2));                               % calc for Below
I =[P.z3+P.z4*c2    P.z2+P.z1*c2              % mass/inertia matrix I
    P.z2+P.z1*c2    P.z2           ];         % .. 
inter= P.z1 * sin(s(2));                      % intermediate calc for Below
g = [ -inter * (s(4)^2 + 2 * s(3)*s(4));      % Coriolis + Centripetal
       inter * (s(3)^2)];                     % Coriolis + Centripetal
sDot= [ s(3:4); I\(torque-g)];           % this is the important eqn

title(['t=' num2str(t)]); drawnow



end

