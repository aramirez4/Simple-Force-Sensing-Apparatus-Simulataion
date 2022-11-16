%% will want to get the perpendicular distance in a plot, last 4 baseline,
% all of training and then first 4 of post
Allmovement=[BaseMov.Allmovement, TrainingMov.Allmovement, PostMov.Allmovement];
rr=[r(1:49) r(51:149),r(151:199)]; %% Will need to be changed depending on 
%nummber of movements in baseline, experimental, and post training
for i=1:length(rr)
    if rr(i) ==1
        PerpDistTotalExp(i)=max(PerpDist(-up.coeffs(1),1,-up.coeffs(2),Allmovement{1,i}(:,1),Allmovement{1,i}(:,2)));
    elseif rr(i)==2
         PerpDistTotalExp(i)=max(PerpDist(-left.coeffs(1),1,-left.coeffs(2),Allmovement{1,i}(:,1),Allmovement{1,i}(:,2)));
    elseif rr(i)==3
         PerpDistTotalExp(i)=max(PerpDist(-down.coeffs(1),1,-down.coeffs(2),Allmovement{1,i}(:,1),Allmovement{1,i}(:,2)));
    elseif rr(i)==4
         PerpDistTotalExp(i)=max(PerpDist(-right.coeffs(1),1,-right.coeffs(2),Allmovement{1,i}(:,1),Allmovement{1,i}(:,2)));
    end
    
    dist_from_start = cumsum( [0, sqrt((Allmovement{1,i}(2:end,1)'-Allmovement{1,i}(1:end-1,1)').^2 + (Allmovement{1,i}(2:end,2)'-Allmovement{1,i}(1:end-1,2)').^2)] );
       MovementDistance(i)=dist_from_start(end);
end

%% Late Training for use with DATAset 6-22
for i=length(fields(TrainingMov.Direction1))-5:length(fields(TrainingMov.Direction1))-2
    fname1=['Mff',num2str(i)];
    if isempty(find(strcmp(fieldnames(TrainingMov.Direction1),(fname1))==1))==1
    else
    LateUp(i)=max(PerpDist(-up.coeffs(1),1,-up.coeffs(2),TrainingMov.Direction1.(fname1)(:,1),TrainingMov.Direction1.(fname1)(:,2)));
    dist_from_start = cumsum( [0, sqrt((TrainingMov.Direction1.(fname1)(2:end,1)'-TrainingMov.Direction1.(fname1)(1:end-1,1)').^2 + (TrainingMov.Direction1.(fname1)(2:end,2)'-TrainingMov.Direction1.(fname1)(1:end-1,2)').^2)] );
    MovementDistanceUp(i)=dist_from_start(end);
    end
end

for i=length(fields(TrainingMov.Direction2))-5:length(fields(TrainingMov.Direction2))-2
    fname1=['Mff',num2str(i)];
    if isempty(find(strcmp(fieldnames(TrainingMov.Direction2),(fname1))==1))==1
    else
    LateLt(i)=max(PerpDist(-left.coeffs(1),1,-left.coeffs(2),TrainingMov.Direction2.(fname1)(:,1),TrainingMov.Direction2.(fname1)(:,2)));
    dist_from_start = cumsum( [0, sqrt((TrainingMov.Direction2.(fname1)(2:end,1)'-TrainingMov.Direction2.(fname1)(1:end-1,1)').^2 + (TrainingMov.Direction2.(fname1)(2:end,2)'-TrainingMov.Direction2.(fname1)(1:end-1,2)').^2)] );
    MovementDistanceLt(i)=dist_from_start(end);
    end
end

for i=length(fields(TrainingMov.Direction3))-5:length(fields(TrainingMov.Direction3))-2
    fname1=['Mff',num2str(i)];
    if isempty(find(strcmp(fieldnames(TrainingMov.Direction3),(fname1))==1))==1
    else
    LateDn(i)=max(PerpDist(-down.coeffs(1),1,-down.coeffs(2),TrainingMov.Direction3.(fname1)(:,1),TrainingMov.Direction3.(fname1)(:,2)));
    dist_from_start = cumsum( [0, sqrt((TrainingMov.Direction3.(fname1)(2:end,1)'-TrainingMov.Direction3.(fname1)(1:end-1,1)').^2 + (TrainingMov.Direction3.(fname1)(2:end,2)'-TrainingMov.Direction3.(fname1)(1:end-1,2)').^2)] );
    MovementDistanceDn(i)=dist_from_start(end);
    end
end

for i=length(fields(TrainingMov.Direction4))-5:length(fields(TrainingMov.Direction4))-2
    fname1=['Mff',num2str(i)];
    if isempty(find(strcmp(fieldnames(TrainingMov.Direction4),(fname1))==1))==1
    else
    LateRt(i)=max(PerpDist(-right.coeffs(1),1,-right.coeffs(2),TrainingMov.Direction4.(fname1)(:,1),TrainingMov.Direction4.(fname1)(:,2)));
    dist_from_start = cumsum( [0, sqrt((TrainingMov.Direction4.(fname1)(2:end,1)'-TrainingMov.Direction4.(fname1)(1:end-1,1)').^2 + (TrainingMov.Direction4.(fname1)(2:end,2)'-TrainingMov.Direction4.(fname1)(1:end-1,2)').^2)] );
    MovementDistanceRt(i)=dist_from_start(end);
    end
end
LateTrainingPerp=nonzeros([LateUp,LateLt,LateDn,LateRt])
LateTrainingTotDist=nonzeros([MovementDistanceUp,MovementDistanceLt,MovementDistanceDn,MovementDistanceRt]);
%% Early training for use with data set 6-22
for i=1:4
    fname1=['Mff',num2str(i)];
    if isempty(find(strcmp(fieldnames(TrainingMov.Direction1),(fname1))==1))==1
    else
    EarlyUp(i)=max(PerpDist(-up.coeffs(1),1,-up.coeffs(2),TrainingMov.Direction1.(fname1)(:,1),TrainingMov.Direction1.(fname1)(:,2)));
    dist_from_start = cumsum( [0, sqrt((TrainingMov.Direction1.(fname1)(2:end,1)'-TrainingMov.Direction1.(fname1)(1:end-1,1)').^2 + (TrainingMov.Direction1.(fname1)(2:end,2)'-TrainingMov.Direction1.(fname1)(1:end-1,2)').^2)] );
    DistanceUp(i)=dist_from_start(end);
    end
end

for i=1:4
    fname1=['Mff',num2str(i)];
    if isempty(find(strcmp(fieldnames(TrainingMov.Direction2),(fname1))==1))==1
    else
    EarlyLt(i)=max(PerpDist(-left.coeffs(1),1,-left.coeffs(2),TrainingMov.Direction2.(fname1)(:,1),TrainingMov.Direction2.(fname1)(:,2)));
    dist_from_start = cumsum( [0, sqrt((TrainingMov.Direction2.(fname1)(2:end,1)'-TrainingMov.Direction2.(fname1)(1:end-1,1)').^2 + (TrainingMov.Direction2.(fname1)(2:end,2)'-TrainingMov.Direction2.(fname1)(1:end-1,2)').^2)] );
    DistanceLt(i)=dist_from_start(end);
    end
end

for i=1:4
    fname1=['Mff',num2str(i)];
    if isempty(find(strcmp(fieldnames(TrainingMov.Direction3),(fname1))==1))==1
    else
    EarlyDn(i)=max(PerpDist(-down.coeffs(1),1,-down.coeffs(2),TrainingMov.Direction3.(fname1)(:,1),TrainingMov.Direction3.(fname1)(:,2)));
    dist_from_start = cumsum( [0, sqrt((TrainingMov.Direction3.(fname1)(2:end,1)'-TrainingMov.Direction3.(fname1)(1:end-1,1)').^2 + (TrainingMov.Direction3.(fname1)(2:end,2)'-TrainingMov.Direction3.(fname1)(1:end-1,2)').^2)] );
    DistanceDn(i)=dist_from_start(end);
    end
end

for i=1:4
    fname1=['Mff',num2str(i)];
    if isempty(find(strcmp(fieldnames(TrainingMov.Direction4),(fname1))==1))==1
    else
    EarlyRt(i)=max(PerpDist(-right.coeffs(1),1,-right.coeffs(2),TrainingMov.Direction4.(fname1)(:,1),TrainingMov.Direction4.(fname1)(:,2)));
    dist_from_start = cumsum( [0, sqrt((TrainingMov.Direction4.(fname1)(2:end,1)'-TrainingMov.Direction4.(fname1)(1:end-1,1)').^2 + (TrainingMov.Direction4.(fname1)(2:end,2)'-TrainingMov.Direction4.(fname1)(1:end-1,2)').^2)] );
    DistanceRt(i)=dist_from_start(end);
    end
end
EarlyTrainingPerp=nonzeros([EarlyUp,EarlyLt,EarlyDn,EarlyRt]);
EarlyTrainingTotDist=nonzeros([DistanceUp,DistanceLt,DistanceDn,DistanceRt]);
%% Last 4 movements of Baseline
for i=length(fields(BaseMov.Direction1))-5:length(fields(BaseMov.Direction1))-2
    
    fname1=['M',num2str(i)];
   
    baseUp(i)=max(PerpDist(-up.coeffs(1),1,-up.coeffs(2),BaseMov.Direction1.(fname1)(:,1),BaseMov.Direction1.(fname1)(:,2)));
    dist_from_start = cumsum( [0, sqrt((BaseMov.Direction1.(fname1)(2:end,1)'-BaseMov.Direction1.(fname1)(1:end-1,1)').^2 + (BaseMov.Direction1.(fname1)(2:end,2)'-BaseMov.Direction1.(fname1)(1:end-1,2)').^2)] );
    baseDistanceUp(i)=dist_from_start(end);
end

for i=length(fields(BaseMov.Direction2))-5:length(fields(BaseMov.Direction2))-2
    
    fname1=['M',num2str(i)];
   
    baseLT(i)=max(PerpDist(-left.coeffs(1),1,-left.coeffs(2),BaseMov.Direction2.(fname1)(:,1),BaseMov.Direction2.(fname1)(:,2)));
    dist_from_start = cumsum( [0, sqrt((BaseMov.Direction2.(fname1)(2:end,1)'-BaseMov.Direction2.(fname1)(1:end-1,1)').^2 + (BaseMov.Direction2.(fname1)(2:end,2)'-BaseMov.Direction2.(fname1)(1:end-1,2)').^2)] );
    baseDistanceLt(i)=dist_from_start(end);
end

for i=length(fields(BaseMov.Direction3))-5:length(fields(BaseMov.Direction3))-2
    
    fname1=['M',num2str(i)];
   
    baseDn(i)=max(PerpDist(-down.coeffs(1),1,-down.coeffs(2),BaseMov.Direction3.(fname1)(:,1),BaseMov.Direction3.(fname1)(:,2)));
    dist_from_start = cumsum( [0, sqrt((BaseMov.Direction3.(fname1)(2:end,1)'-BaseMov.Direction3.(fname1)(1:end-1,1)').^2 + (BaseMov.Direction3.(fname1)(2:end,2)'-BaseMov.Direction3.(fname1)(1:end-1,2)').^2)] );
    baseDistanceDn(i)=dist_from_start(end);
end

for i=length(fields(BaseMov.Direction4))-5:length(fields(BaseMov.Direction4))-2
    
    fname1=['M',num2str(i)];
   
    baseRT(i)=max(PerpDist(-right.coeffs(1),1,-right.coeffs(2),BaseMov.Direction4.(fname1)(:,1),BaseMov.Direction4.(fname1)(:,2)));
    dist_from_start = cumsum( [0, sqrt((BaseMov.Direction4.(fname1)(2:end,1)'-BaseMov.Direction4.(fname1)(1:end-1,1)').^2 + (BaseMov.Direction4.(fname1)(2:end,2)'-BaseMov.Direction4.(fname1)(1:end-1,2)').^2)] );
    baseDistanceRt(i)=dist_from_start(end);
end
BasePerp=nonzeros([baseUp,baseLT,baseDn,baseRT]);
BaseTotDist=nonzeros([baseDistanceUp,baseDistanceLt,baseDistanceDn,baseDistanceRt]);
%% First 4 Post
for i=1:4
    
    fname1=['M',num2str(i)];
   
    postUp(i)=max(PerpDist(-up.coeffs(1),1,-up.coeffs(2),PostMov.Direction1.(fname1)(:,1),PostMov.Direction1.(fname1)(:,2)));
    dist_from_start = cumsum( [0, sqrt((PostMov.Direction1.(fname1)(2:end,1)'-PostMov.Direction1.(fname1)(1:end-1,1)').^2 + (PostMov.Direction1.(fname1)(2:end,2)'-PostMov.Direction1.(fname1)(1:end-1,2)').^2)] );
    postDistanceUp(i)=dist_from_start(end);
end

for i=1:4
    
    fname1=['M',num2str(i)];
   
    postLT(i)=max(PerpDist(-left.coeffs(1),1,-left.coeffs(2),PostMov.Direction2.(fname1)(:,1),PostMov.Direction2.(fname1)(:,2)));
    dist_from_start = cumsum( [0, sqrt((PostMov.Direction2.(fname1)(2:end,1)'-PostMov.Direction2.(fname1)(1:end-1,1)').^2 + (PostMov.Direction2.(fname1)(2:end,2)'-PostMov.Direction2.(fname1)(1:end-1,2)').^2)] );
    postDistanceLt(i)=dist_from_start(end);
end

for i=1:4
    
    fname1=['M',num2str(i)];
   
    postDn(i)=max(PerpDist(-down.coeffs(1),1,-down.coeffs(2),PostMov.Direction3.(fname1)(:,1),PostMov.Direction3.(fname1)(:,2)));
    dist_from_start = cumsum( [0, sqrt((PostMov.Direction3.(fname1)(2:end,1)'-PostMov.Direction3.(fname1)(1:end-1,1)').^2 + (PostMov.Direction3.(fname1)(2:end,2)'-PostMov.Direction3.(fname1)(1:end-1,2)').^2)] );
    postDistanceDn(i)=dist_from_start(end);
end

for i=1:4
    
    fname1=['M',num2str(i)];
   
    postRT(i)=max(PerpDist(-right.coeffs(1),1,-right.coeffs(2),PostMov.Direction4.(fname1)(:,1),PostMov.Direction4.(fname1)(:,2)));
    dist_from_start = cumsum( [0, sqrt((PostMov.Direction4.(fname1)(2:end,1)'-PostMov.Direction4.(fname1)(1:end-1,1)').^2 + (PostMov.Direction4.(fname1)(2:end,2)'-PostMov.Direction4.(fname1)(1:end-1,2)').^2)] );
    postDistanceRt(i)=dist_from_start(end);
end
postPerp=nonzeros([postUp,postLT,postDn,postRT]);
postTotDist=nonzeros([postDistanceUp,postDistanceLt,postDistanceDn,postDistanceRt]);
%%
p=polyfit([1:197],PerpDistTotalExp,5);

normDistance=MovementDistance/.1;

figure
hold on
plot(PerpDistTotalExp,"o")
%plot(polyval(p,[1:197]));
xline(49.5,"-b","Training")
xline(148.5,"-b","Post Training")
xlabel("Movement Number")
ylabel("Max Perpendicular Distance")

figure
title("Total Distance normalized to Straight line Distance")
hold on
plot(normDistance,"o")
xline(49.5,"-b","Training")
xline(148.5,"-b","Post Training")
xlabel("Movement Number")
ylabel("Normalized Distance")
%%
anova1([BasePerp,postPerp],["Late Baseline","Early Post Training"])
title("Perpendicular Distance")
%%
anova1([EarlyTrainingPerp,LateTrainingPerp],["Early Training","Late Training"])
title("Perpendicular Distance")

%% Total Movement distance

EndofBaseMoveSTD=std(MovementDistance(30:49));
MeanEndofBaseMove=mean(MovementDistance(34:49));

anova1([BaseTotDist,postTotDist],["Late Baseline","Early Post Training"])
title("Movement Distance")
anova1([EarlyTrainingTotDist,LateTrainingTotDist],["Early Training","Late Training"])
title("Movement Distance")
