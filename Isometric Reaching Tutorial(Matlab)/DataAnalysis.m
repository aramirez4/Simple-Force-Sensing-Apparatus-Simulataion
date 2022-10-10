%% Analyze data

% Remove the movements back to the center
check=0;
count=1;
for i=1:length(BaseData)
 
    if BaseData(i,19)==2
        check=1;
    end
    if check ==1 && i<length(BaseData)
        if BaseData(i+1,19)>=BaseData(i,19)
        targetBase(i,1:7)=[BaseData(i,10:11) BaseData(i,14:18)];
        else 
            check =0;
            count=count+1;
        end
    else 
        targetBase(i,1:7)=[0 0 0 0 0 0 0];
    end
end
count=1;
check=0;
for i=1:length(ExpData)
 
    if ExpData(i,19)==2
        check=1;
    end
    if check ==1 && i<length(ExpData)
        if ExpData(i+1,19)>=ExpData(i,19)
        targetEx(i,1:7)=[ExpData(i,10:11) ExpData(i,14:18)];
        else 
            check =0;
            count=count+1;
        end
    else 
        targetEx(i,1:7)=[0 0 0 0 0 0 0];
    end
end
count=1;
check=0;
for i=1:length(PostData)
 
    if PostData(i,19)==2
        check=1;
    end
    if check ==1 && i<length(PostData)
        if PostData(i+1,19)>=PostData(i,19)
        targetPost(i,1:7)=[PostData(i,10:11) PostData(i,14:18)];
        else 
            check =0;
            count=count+1;
        end
    else 
        targetPost(i,1:7)=[0 0 0 0 0 0 0];
    end
end
%% Plot the Reaching Trajectories
 BaseMov=Plotmove(targetBase,r(1,1:50),target(1:50,:));
%% PlotBestLine(numTrgts,trgts)
 TrainingMov=Plotmove(targetEx,r(1,51:150),target(52:150,:));
%% PlotBestLine(numTrgts,trgts)
 PostMov=Plotmove(targetPost,r(1,151:200),target(151:200,:));



%% Calculate Perpendicular Distance
% Get equations for the ideal path in each direction using the minjerk path
% and a linear regression to calculate ideal data points at each time
% interval to compare.

[up.td,up.xd]=minjerkpath(startpos(1),startpos(2),trgts(1,1),trgts(1,2),2.3); %% direction 1
up.coeffs=polyfit(up.xd(:,1),up.xd(:,2),1);

[left.td,left.xd]=minjerkpath(startpos(1),startpos(2),trgts(2,1),trgts(2,2),2.3); %% direciton 2
left.coeffs=polyfit(left.xd(:,1),left.xd(:,2),1);

[down.td,down.xd]=minjerkpath(startpos(1),startpos(2),trgts(3,1),trgts(3,2),2.3); %% direction 3
down.coeffs=polyfit(down.xd(:,1),down.xd(:,2),1);

[right.td,right.xd]=minjerkpath(startpos(1),startpos(2),trgts(4,1),trgts(4,2),2.3); %% direction 4
right.coeffs=polyfit(right.xd(:,1),right.xd(:,2),1);

%% Sorting through each movement. Finding Perpendicular distance, distance
% of entire movement,

for j = 1:str2double(answer{1,1})   
    
    direction=['Direction',num2str(j)];
    
    for i=1:length(fields(BaseMov.(direction)))
        
        fname1=['M',num2str(i)];
        if isempty(find(strcmp(fieldnames(BaseMov.(direction)),(fname1))==1))==1
        else
            

             if strcmp(direction,'Direction1')==1
       BaseMov.Direction1.PerpDist.(fname1)= PerpDist(-up.coeffs(1),1,-up.coeffs(2),BaseMov.(direction).(fname1)(:,1),BaseMov.(direction).(fname1)(:,2));
       BaseMov.Direction1.PerpDist.means.(fname1)= mean(PerpDist(-up.coeffs(1),1,-up.coeffs(2),BaseMov.(direction).(fname1)(:,1),BaseMov.(direction).(fname1)(:,2)));
       dist_from_start = cumsum( [0, sqrt((BaseMov.Direction1.(fname1)(2:end,1)'-BaseMov.Direction1.(fname1)(1:end-1,1)').^2 + (BaseMov.Direction1.(fname1)(2:end,2)'-BaseMov.Direction1.(fname1)(1:end-1,2)').^2)] );
       BaseMov.Direction1.TotalMovDistance.(fname1)=dist_from_start(end);
       clear dist_from_start
            elseif strcmp(direction,'Direction2')==1
       BaseMov.Direction2.PerpDist.(fname1)=PerpDist(-left.coeffs(1),1,-left.coeffs(2),BaseMov.(direction).(fname1)(:,1),BaseMov.(direction).(fname1)(:,2));
       BaseMov.Direction2.PerpDist.means.(fname1)=mean(PerpDist(-left.coeffs(1),1,-left.coeffs(2),BaseMov.(direction).(fname1)(:,1),BaseMov.(direction).(fname1)(:,2)));
       dist_from_start = cumsum( [0, sqrt((BaseMov.Direction2.(fname1)(2:end,1)'-BaseMov.Direction2.(fname1)(1:end-1,1)').^2 + (BaseMov.Direction2.(fname1)(2:end,2)'-BaseMov.Direction2.(fname1)(1:end-1,2)').^2)] );
       BaseMov.Direction2.TotalMovDistance.(fname1)=dist_from_start(end);
       clear dist_from_start
            elseif strcmp(direction,'Direction3')==1
       BaseMov.Direction3.PerpDist.(fname1)=PerpDist(-down.coeffs(1),1,-down.coeffs(2),BaseMov.(direction).(fname1)(:,1),BaseMov.(direction).(fname1)(:,2));
       BaseMov.Direction3.PerpDist.means.(fname1)=mean(PerpDist(-down.coeffs(1),1,-down.coeffs(2),BaseMov.(direction).(fname1)(:,1),BaseMov.(direction).(fname1)(:,2)));
       dist_from_start = cumsum( [0, sqrt((BaseMov.Direction3.(fname1)(2:end,1)'-BaseMov.Direction3.(fname1)(1:end-1,1)').^2 + (BaseMov.Direction3.(fname1)(2:end,2)'-BaseMov.Direction3.(fname1)(1:end-1,2)').^2)] );
       BaseMov.Direction3.TotalMovDistance.(fname1)=dist_from_start(end);
       clear dist_from_start
            elseif strcmp(direction,'Direction4')==1
       BaseMov.Direction4.PerpDist.(fname1)= PerpDist(-right.coeffs(1),1,-right.coeffs(2),BaseMov.(direction).(fname1)(:,1),BaseMov.(direction).(fname1)(:,2));
       BaseMov.Direction4.PerpDist.means.(fname1)= mean(PerpDist(-right.coeffs(1),1,-right.coeffs(2),BaseMov.(direction).(fname1)(:,1),BaseMov.(direction).(fname1)(:,2)));
       dist_from_start = cumsum( [0, sqrt((BaseMov.Direction4.(fname1)(2:end,1)'-BaseMov.Direction4.(fname1)(1:end-1,1)').^2 + (BaseMov.Direction4.(fname1)(2:end,2)'-BaseMov.Direction4.(fname1)(1:end-1,2)').^2)] );
       BaseMov.Direction4.TotalMovDistance.(fname1)=dist_from_start(end);
       clear dist_from_start
            end
        end
    end
end

for j = 1:str2double(answer{1,1})   
    
    direction=['Direction',num2str(j)];
    
    for i=1:length(fields(TrainingMov.(direction)))
        
        fname1=['Mff',num2str(i)];
        if isempty(find(strcmp(fieldnames(TrainingMov.(direction)),(fname1))==1))==1
        else
            

              if strcmp(direction,'Direction1')==1
       TrainingMov.Direction1.PerpDist.(fname1)= PerpDist(-up.coeffs(1),1,-up.coeffs(2),TrainingMov.(direction).(fname1)(:,1),TrainingMov.(direction).(fname1)(:,2));
       TrainingMov.Direction1.PerpDist.means.(fname1)= mean(PerpDist(-up.coeffs(1),1,-up.coeffs(2),TrainingMov.(direction).(fname1)(:,1),TrainingMov.(direction).(fname1)(:,2)));
       dist_from_start = cumsum( [0, sqrt((TrainingMov.Direction1.(fname1)(2:end,1)'-TrainingMov.Direction1.(fname1)(1:end-1,1)').^2 + (TrainingMov.Direction1.(fname1)(2:end,2)'-TrainingMov.Direction1.(fname1)(1:end-1,2)').^2)] );
       TrainingMov.Direction1.TotalMovDistance.(fname1)=dist_from_start(end);
       clear dist_from_start
            elseif strcmp(direction,'Direction2')==1
       TrainingMov.Direction2.PerpDist.(fname1)=PerpDist(-left.coeffs(1),1,-left.coeffs(2),TrainingMov.(direction).(fname1)(:,1),TrainingMov.(direction).(fname1)(:,2));
       TrainingMov.Direction2.PerpDist.means.(fname1)=mean(PerpDist(-left.coeffs(1),1,-left.coeffs(2),TrainingMov.(direction).(fname1)(:,1),TrainingMov.(direction).(fname1)(:,2)));
       dist_from_start = cumsum( [0, sqrt((TrainingMov.Direction2.(fname1)(2:end,1)'-TrainingMov.Direction2.(fname1)(1:end-1,1)').^2 + (TrainingMov.Direction2.(fname1)(2:end,2)'-TrainingMov.Direction2.(fname1)(1:end-1,2)').^2)] );
       TrainingMov.Direction2.TotalMovDistance.(fname1)=dist_from_start(end);
       clear dist_from_start
            elseif strcmp(direction,'Direction3')==1
       TrainingMov.Direction3.PerpDist.(fname1)=PerpDist(-down.coeffs(1),1,-down.coeffs(2),TrainingMov.(direction).(fname1)(:,1),TrainingMov.(direction).(fname1)(:,2));
       TrainingMov.Direction3.PerpDist.means.(fname1)=mean(PerpDist(-down.coeffs(1),1,-down.coeffs(2),TrainingMov.(direction).(fname1)(:,1),TrainingMov.(direction).(fname1)(:,2)));
       dist_from_start = cumsum( [0, sqrt((TrainingMov.Direction3.(fname1)(2:end,1)'-TrainingMov.Direction3.(fname1)(1:end-1,1)').^2 + (TrainingMov.Direction3.(fname1)(2:end,2)'-TrainingMov.Direction3.(fname1)(1:end-1,2)').^2)] );
       TrainingMov.Direction3.TotalMovDistance.(fname1)=dist_from_start(end);
       clear dist_from_start
            elseif strcmp(direction,'Direction4')==1
       TrainingMov.Direction4.PerpDist.(fname1)= PerpDist(-right.coeffs(1),1,-right.coeffs(2),TrainingMov.(direction).(fname1)(:,1),TrainingMov.(direction).(fname1)(:,2));
       TrainingMov.Direction4.PerpDist.means.(fname1)= mean(PerpDist(-right.coeffs(1),1,-right.coeffs(2),TrainingMov.(direction).(fname1)(:,1),TrainingMov.(direction).(fname1)(:,2)));
       dist_from_start = cumsum( [0, sqrt((TrainingMov.Direction4.(fname1)(2:end,1)'-TrainingMov.Direction4.(fname1)(1:end-1,1)').^2 + (TrainingMov.Direction4.(fname1)(2:end,2)'-TrainingMov.Direction4.(fname1)(1:end-1,2)').^2)] );
       TrainingMov.Direction4.TotalMovDistance.(fname1)=dist_from_start(end);
       clear dist_from_start
            end
        end
    end
end

for j = 1:str2double(answer{1,1})   
    
    direction=['Direction',num2str(j)];
    
    for i=1:length(fields(PostMov.(direction)))
        
        fname1=['M',num2str(i)];
        if isempty(find(strcmp(fieldnames(PostMov.(direction)),(fname1))==1))==1
        else
            

            if strcmp(direction,'Direction1')==1
       PostMov.Direction1.PerpDist.(fname1)= PerpDist(-up.coeffs(1),1,-up.coeffs(2),PostMov.(direction).(fname1)(:,1),PostMov.(direction).(fname1)(:,2));
       PostMov.Direction1.PerpDist.means.(fname1)= mean(PerpDist(-up.coeffs(1),1,-up.coeffs(2),PostMov.(direction).(fname1)(:,1),PostMov.(direction).(fname1)(:,2)));
       dist_from_start = cumsum( [0, sqrt((PostMov.Direction1.(fname1)(2:end,1)'-PostMov.Direction1.(fname1)(1:end-1,1)').^2 + (PostMov.Direction1.(fname1)(2:end,2)'-PostMov.Direction1.(fname1)(1:end-1,2)').^2)] );
       PostMov.Direction1.TotalMovDistance.(fname1)=dist_from_start(end);
       clear dist_from_start
            elseif strcmp(direction,'Direction2')==1
       PostMov.Direction2.PerpDist.(fname1)=PerpDist(-left.coeffs(1),1,-left.coeffs(2),PostMov.(direction).(fname1)(:,1),PostMov.(direction).(fname1)(:,2));
       PostMov.Direction2.PerpDist.means.(fname1)=mean(PerpDist(-left.coeffs(1),1,-left.coeffs(2),PostMov.(direction).(fname1)(:,1),PostMov.(direction).(fname1)(:,2)));
       dist_from_start = cumsum( [0, sqrt((PostMov.Direction2.(fname1)(2:end,1)'-PostMov.Direction2.(fname1)(1:end-1,1)').^2 + (PostMov.Direction2.(fname1)(2:end,2)'-PostMov.Direction2.(fname1)(1:end-1,2)').^2)] );
       PostMov.Direction2.TotalMovDistance.(fname1)=dist_from_start(end);
       clear dist_from_start
            elseif strcmp(direction,'Direction3')==1
       PostMov.Direction3.PerpDist.(fname1)=PerpDist(-down.coeffs(1),1,-down.coeffs(2),PostMov.(direction).(fname1)(:,1),PostMov.(direction).(fname1)(:,2));
       PostMov.Direction3.PerpDist.means.(fname1)=mean(PerpDist(-down.coeffs(1),1,-down.coeffs(2),PostMov.(direction).(fname1)(:,1),PostMov.(direction).(fname1)(:,2)));
       dist_from_start = cumsum( [0, sqrt((PostMov.Direction3.(fname1)(2:end,1)'-PostMov.Direction3.(fname1)(1:end-1,1)').^2 + (PostMov.Direction3.(fname1)(2:end,2)'-PostMov.Direction3.(fname1)(1:end-1,2)').^2)] );
       PostMov.Direction3.TotalMovDistance.(fname1)=dist_from_start(end);
       clear dist_from_start
            elseif strcmp(direction,'Direction4')==1
       PostMov.Direction4.PerpDist.(fname1)= PerpDist(-right.coeffs(1),1,-right.coeffs(2),PostMov.(direction).(fname1)(:,1),PostMov.(direction).(fname1)(:,2));
       PostMov.Direction4.PerpDist.means.(fname1)= mean(PerpDist(-right.coeffs(1),1,-right.coeffs(2),PostMov.(direction).(fname1)(:,1),PostMov.(direction).(fname1)(:,2)));
       dist_from_start = cumsum( [0, sqrt((PostMov.Direction4.(fname1)(2:end,1)'-PostMov.Direction4.(fname1)(1:end-1,1)').^2 + (PostMov.Direction4.(fname1)(2:end,2)'-PostMov.Direction4.(fname1)(1:end-1,2)').^2)] );
       PostMov.Direction4.TotalMovDistance.(fname1)=dist_from_start(end);
       clear dist_from_start
            end
        end
    end
end
