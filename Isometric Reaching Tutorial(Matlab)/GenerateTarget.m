function [trgts,r]= GenerateTarget(numtargets,base,exp,post)
numMvmnts=base+exp+post;       %Number of total movements based on given

% Define a circle
angles = linspace(0, 2*pi, 720); %makes a vector from 0 to 2Pi with 720 pts
radius = .1;                     % Radius of circle for reaching targets
                                 % .1 chosen to have 10cm movements
xCenter = .15;                   % Origin of circle, chosen to be (.15,.35)
yCenter = .35;                   % To be close to real world arm position

x = radius * cos(angles) + xCenter;  % X and Y value pairs for given angle
y = radius * sin(angles) + yCenter;

% Define Targets based on circle
for k=1:numtargets; 
    cut=720/numtargets;  % Divides the circle into sections evenly spaced
    xtarg(k)=x(cut*k);   % Find the x position at the evenly spaced index
    ytarg(k)=y(cut*k);   % Find the x position at the evenly spaced index
end
trgts=[xtarg' ytarg'];   % stores the x and y values in a single matrix
row=[1:numtargets];
rng(6108); % Sets the seed so the targets are psuedo random


for i=1:numMvmnts
    r(i)=mod(ceil(10*rand),numtargets)+1;%Creates randomly generated order 
                                         %of Targets
                                         
    if i>1
        %ensures one target isnt presened two times in a row
        if r(i-1)== r(i)
        non=row(row~=r(i));   %Removes repeated value from possible targets
        r(i)=non(randperm(length(non),1)); % Gets new target
        M(i,:)=trgts(r(i),:);
        else
            M(i,:)=trgts(r(i),:);
        end
    else    
    M(i,:)=trgts(r(i),:);
    end
    
% Determine the experimental condition for each reach
    if i<= base || i>(exp+base)
        force(i)=0;       %Sets the force field 'off' for baseline and post
    elseif base<i<=(exp+base)
        force(i)=1;        %Sets the force field 'on' for training
        catchodds=rand;    %random number used to create catch trials
        if catchodds<(1/5) %1/5 probability of movement being a catch trial
            if force(i-1)==1
                force(i)=0; %Sets force 'off'
            else
                force(i)=1; % Keeps force 'on'
            end
        end
  
    end
end
exp=[M,force'];

%Writes the target list and experimental condition to excel
xlswrite('Targets.xlsx',exp) 


% could fix the seed number sothe "random" is repeatable aka rng(#) and use
% same (#)

end