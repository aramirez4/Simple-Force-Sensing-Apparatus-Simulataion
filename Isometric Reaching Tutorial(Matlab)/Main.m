pause(3)
%% Parameters of Experiment
global samplingperiod startpos forcefield target numMov endTime
 % Ask User how many targets to reach toward and number of movements
prompt = {'Enter number of targets','Enter number of Baseline movements:','Enter number of Experimental movements:','Enter number of Post movements:'};
dlgtitle = 'Input';
dims = [1 50];
definput = {'4','50','100','50'};            %Default input values 
answer = inputdlg(prompt,dlgtitle,dims,definput);

% Stores responses as a double
numTrgts=str2double(answer{1,1});        
numBase=str2double(answer{2,1});            
numExp=str2double(answer{3,1});              
numPost=str2double(answer{4,1});           
numMov=numBase+numExp+numPost;               

%Function that generates the target to reach toward at each movement number
%and whether it has force fields on 
[trgts,r]=GenerateTarget(numTrgts,numBase,numExp,numPost); 


samplingperiod=.05; % Seconds                          
endTime=9999;                                 %Time to complete experiment


startpos=[.15 .35];                          %Initial end-effector pos[x,y]
target=readmatrix('Targets.xlsx');        %Reads the target list generated
%% Initialize set variables:
global lastTime t tStart P mp0 screen DATA State count


P.L=[0.3; 0.3];                                 % link lengths
P.M=[1.93; 1.52];                               % link masses
P.I=[0.0141; 0.0188];                           % link inertias
P.R=P.L/2;                                      % distance to CM 
P.z1=P.M(2)*P.L(1)*P.R(2);                      % precalc for use later 
P.z2=P.I(2)+P.M(2)*P.R(2)^2;                    % precalc for use later 
P.z3=P.I(1)+P.I(2)+(P.M(1)*P.L(1)^2 ...         % precalc for use later 
         +P.M(2)*P.L(2)^2)/4+P.M(2)*P.L(1)^2;   % ...
P.z4 = P.M(2)*P.L(1)*P.L(2);                    % precalc for use later 

[P.td,P.xd]=minjerkpath(.15,.35,.14,.45,2);     %Gets the ideal trajectory


  
P.qd=inverseKinematics(P.xd, P.L);              %Gets desired joint angles

P.s0=[P.qd(1,1),P.qd(1,2),0,0]';                %initial state of the model
                                                %[Joint1 Angle,Joint2 angle
                                                %Joint1 Veloc,Joint2 Veloc]


State=1;                                        % initial state(1= waiting
                                                %to reach starting period) 

mp0=get(0,'pointerlocation');                   %gets location of the mouse
                                                %to be used as psuedo force

screen=get(0,'screensize');                     %Gets the display info(res)

 %% prepare graphics

f=figure(1); clf;axis equal; hold on;                 % figure window setup
f.WindowState='Maximized';

angle=(0:pi/100:pi/2)';                            

 % plot Avatar reach limit
plot((P.L(1)+P.L(2))*cos(angle),(P.L(1)+P.L(2))*sin(angle))


%Plot workspace(box) (25 x 25 cm )
x1=.025;
x2=.275;
y1=.225;
y2=.475;

x = [x1, x2, x2, x1, x1];
y = [y1, y1, y2, y2, y1];
plot(x, y, 'b-');

%Arm Avatar plotting
[tip,elbow]=forwardKinematics(P.qd(1,:),P.L)       % initial positions
P.plotHandle=plot([0 elbow(1) tip(1)], ...          % plot initial; the 
                  [0 elbow(2) tip(2)], ...          % ..handle is a poitner 
                  'g', 'linewidth',5);              % ..to the plot.
drawnow                                             % plot up to date
set(gcf, 'Pointer', 'custom', 'PointerShapeCData', NaN(16,16))% hides cursor on figure
P.tip=tip;
%% Preallocate variables
P.counter=1; 
 t=0;
%% loop to get live data
tStart=clock; % in 6 element time format 
lastTime=0;

count=[0 1 0]; %% counter to be used in state machine 
% First column counter is to determine time at target
% Second column counter determines target
% Third column counter flags that youve been at state 5
P.error=[0 0 0 0];
tic  

while etime(clock,tStart)<endTime
    click_type=get(figure(1),'SelectionType');
    if strcmp(click_type,'normal') %right click
        mp0=get(0,'Pointerlocation');
        %Need to Double click on start to make work
    end
    isoMove
end

toc 


%% store data

header={'Time','Relative Mouse Position(x)','Relative Mouse Position(y)','Shoulder Joint Angle(rad)','Elbow Joint Angle(rad)','Shoulder Joint Angle Velocity(rad/s)','Elbow Joint Angle Velocity(rad/s)','Force x','Force y','End Effector xPosition','End Effector yPosition','Elbow xPosition','Elbow yPosition','Movement number','Shoulder joint error(rad)','Elbow joint error(rad)','Shoulder joint velocity error(rad/s)','Elbow joint velocity error(rad/s)','State'}
DataLabeled=[header;num2cell(DATA)];

% Segments the Data into phases (Baseline, Experimental, Post)
for i=1:length(DATA)
  
    if DATA(i,14)>(numBase) && DATA(i,14)<=(numExp+numBase);
        ExpData(i,:)=DATA(i,:);
    end
    
    if DATA(i,14)<= numBase ;
         BaseData(i,:)=DATA(i,:);
    end
    
    if DATA(i,14)>(numBase+numExp) && DATA(i,14)<=(numExp+numBase+numPost);
         PostData(i,:)=DATA(i,:);
    end
    
end

% Removes zero values created from above loop
BaseData=BaseData(any(BaseData,2),:);
ExpData=ExpData(any(ExpData,2),:);
PostData=PostData(any(PostData,2),:);


%% Run


function isoMove()  
global t lastTime DATA P screen mp0 samplingperiod tStart tMove State startpos count target targetpos vis forcefield;
global torque numMov endTime
 %% Time in seconds


P.time(P.counter)=datetime('now','Format','yyyy-MM-dd HH:mm:ss:SSS'); % Time Stamp for the sample

%% Force belief

dMP=get(0,'Pointerlocation')-mp0; % collects mouse location relative to 
                         %initial mouse position(Change in mouse position)
t=etime(clock,tStart);   %Calculates time from start time and comp clock

force=(dMP ./[screen(3), screen(4)])'*10; %Screen is the resolution of the
                                  % display to normalize the mouse location 

% if norm(force)<=.05 && norm(dMP)<=20 % If statement to set force to zero near origin to account for mouse in real world moving to different place
%     force=[0,0]';
% end



%% Force Field
vtip=Jacob(P.s0(1:2))*P.s0(3:4); %% End effector velocity from jacobian and angular velocity to get end effector velocity
forcefield=target(count(2),3);
if forcefield==1  % Checks to see if forcefield is turned on
if .025 < P.tip(1) && P.tip(1) < .275 && P.tip(2)<.50 && P.tip(2)>.25 % checks to see if the end effector tip is within the workspace
    
% Curl field matrix
b=[0 10;...
    -10 0];  % N sec/m

field=b*vtip;                    %% Force = b*Velocity where b is the dampening matrix
force=force+field;
end
end
%% Solve:get s from sdot using euler
s=P.s0 +samplingperiod*dyn(t,P.s0,force');


[tip,elbow]=forwardKinematics(s',P.L);        % angles to end position 


%% Stores Data
%Store the Data into a matrix of 19 columns. The first column is the time
%of the associated with the data point in seconds. The second and third
%column are the relative mouse position in terms of the screen. The fourth
%column is the Shoulder Joint angle(rad), the fifth is the Elbow Joint
%angle(rad). The sixth and seventh are the joint velocities (Rad/s) for the
%Shoulder and Elbow respectively. The eighth and ninth columns are the
%force on the end effector x component and y component. The 10th and 11th
%columns are for the x and y position of the end effector. The 12th and
%13th column are the x and y position of the elbow joint. The 14th column
%is the counter that is used t odetermine movement numner. The 15th and
%16th columns are the errors in the shoulder joint and elbow joint angles.
%17th and 18th are the errors in the joint velocities for shoulder and
%elbow joint. The 19th column is the current state of the system .


DATA(P.counter,:)=[t dMP s' force' tip elbow count(2) P.error State];


P.s0=s;
P.counter=P.counter+1;


%% update animation based on current position:

set(P.plotHandle,'xdata',[0 elbow(1) tip(1)], ...
                 'ydata',[0 elbow(2) tip(2)]) % 
drawnow                                       % refresh figure

%% State controller
if State ==1 %% State 1 is if the user is at starting point
 
    if (startpos(1))*.9 < tip(1) && tip(1)<(1.1)*(startpos(1))
        if (startpos(2))*.9 < tip(2) && tip(2)<(1.1)*(startpos(2))
            count(1)=count(1)+1;
            if count(1)>40
              
                State=2;
                count(1)=0;
                
                  if exist('vis','var') % deletes the target to starting point
                     if isa(vis,'double')
                  %targ as an empty global will exist as a double but is 
                  %not an actual target depicted on the screen: do nothing
                     else
                        
                        vis.delete
                        % Target being displayed should be deleted
                     end
                  end
            end
        end
        
    end
    
elseif State == 2   % State 2 is determining targets and presenting them
    
  %% Display target
  mp0=get(0,'Pointerlocation');
  
  targetpos=target(count(2),1:2);
   vis=viscircles([targetpos],.004);
   if count(2)>numMov
       endTime=t;
   end
  count(2)=count(2) +1;
  
  State=3;

       
       %% Start of movement
elseif State ==3  %State 3 is currently moving 
    %Records the time when movement starts
if norm(s(3:4)')>0.025 && norm(vtip)>0.025 %% checking the angular velocities and displacement from the start

    tMove=t;
    State=4;
    count(3);
    % Could get launch angle at this point

end
 %% EQ point controller toward target
elseif State == 4  % wait for user to get to target and add equilibrium
                   % point controller
if count(3)==0
    [P.td,P.xd]=minjerkpath(startpos(1),startpos(2),targetpos(1),targetpos(2),2.3);
    P.qd=inverseKinematics(P.xd, P.L);         % inverse kinematics
elseif count(3)==1
    
    [P.td,P.xd]=minjerkpath(P.trgt(1),P.trgt(2),startpos(1),startpos(2),2.3);
    P.qd=inverseKinematics(P.xd, P.L);         % inverse kinematics
end
    
    if (targetpos(1))*.9 < tip(1) && tip(1)<(1.1)*(targetpos(1))
        if (targetpos(2))*.9 < tip(2) && tip(2)<(1.1)*(targetpos(2))
            count(1)=count(1)+1;
            if count(1)>40 
               if count(3)==0
                State=5;
                count(1)=0;
               else 
                   State=1;
                   count(1)=0;
                   count(3)=0; % resets flag for state 5
               end
                %Could tell time feedback here
            end
        end
    end
    if t-tMove > 5.5 % give the user 5 seconds most to get to the Target
        if count(3)==0
            State=5;
        else
            State=1;
            count(3)=0;
        end
        % Could Tell User to be quicker
    end
    %% Return to Start
elseif State==5 % State 5-Arrived at target,returning to start point
    P.trgt=targetpos;
    vis.delete
   

    vis=viscircles([startpos],.004);
   mp0=get(0,'Pointerlocation');
    State=3;

    count(3)=1; % flag to say you've been to state 5

end

while t<lastTime+samplingperiod

  t=etime(clock,tStart);
end % END while

lastTime=t;

end