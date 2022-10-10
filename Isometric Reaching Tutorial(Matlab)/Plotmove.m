function[Mov]=plotmove(A,trgts,target)
non = find(A(:,1)~=0)';                             % Nonzero Elements (transposed)
ini = unique([non(1) non(diff([0 non])>1)]);        % Segment Start Indices
fin = non([find(diff(non)>1) length(non)]);   % Segment End Indices
for k1 = 1:length(ini)
    movement{k1} = A(ini(k1):fin(k1),:);             % (Included the column)
end
figure
%% Divides into movements directions
 check=[1 1 1 1 1];

for i=1:length(movement)
    if trgts(i)==1;
        if target(i,3)==0;
        fname1=['M',num2str(check(1))];
        movDir1.(fname1)=movement{1,i};
        check(1)=check(1)+1;

        else
        fname1=['Mff',num2str(check(1))];
        movDir1.(fname1)=movement{1,i};
        check(1)=check(1)+1;
        end
    elseif trgts(i) ==2
        if target(i,3)==0;
        fname1=['M',num2str(check(2))];
        movDir2.(fname1)=movement{1,i};
        check(2)=check(2)+1;

        else
        fname1=['Mff',num2str(check(2))];
        movDir2.(fname1)=movement{1,i};
        check(2)=check(2)+1;
        end
    elseif trgts(i)==3
        if target(i,3)==0;
        fname1=['M',num2str(check(3))];
        movDir3.(fname1)=movement{1,i};
        check(3)=check(3)+1;

        else
        fname1=['Mff',num2str(check(3))];
        movDir3.(fname1)=movement{1,i};
        check(3)=check(3)+1;
        end
    elseif trgts(i) ==4
        if target(i,3)==0;
        fname1=['M',num2str(check(4))];
        movDir4.(fname1)=movement{1,i};
        check(4)=check(4)+1;
        else
        fname1=['Mff',num2str(check(4))];
        movDir4.(fname1)=movement{1,i};
        check(4)=check(4)+1;
        end
    elseif trgts(i)==5
        if target(i,3)==0
        fname1=['M',num2str(check(5))];
        movDir5.(fname1)=movement{1,i};
        check(5)=check(5)+1;

        elseif target(i,3)==1
        fname1=['Mff',num2str(check(5))];
        movDir5.(fname1)=movement{1,i};
        check(5)=check(5)+1;
        end
    end

if exist("movDir1")
Mov.Direction1=movDir1;
end
if exist("movDir2")
Mov.Direction2=movDir2;
end
if exist("movDir3")
Mov.Direction3=movDir3;
end
if exist("movDir4")
Mov.Direction4=movDir4;
end
if exist("movDir5")
Mov.Direction5=movDir5;
end
Mov.Allmovement=movement;


for i=1:length(movement)          % Plot last 20 movements
    hold on
    plot(movement{1,i}(:,1)-.15,movement{1,i}(:,2)-.35)
end


set(gca,'XTickLabel','','YTickLabel','','ZTickLabel','');


end