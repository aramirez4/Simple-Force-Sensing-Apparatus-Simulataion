function [dist]=PerpDist(a,b,c,X,Y)
% Where a,b,c are the coeffecients of the line
% ax +by + c = 0
% X and Y are the coordinates of the point to compare dist to line.

dist=abs(a*X+b*Y+c)/sqrt((a^2 +b^2));
%plot(TrainingMov.Direction1.Mff17(:,1),TrainingMov.Direction1.Mff17(:,2))

  % 152.5744*x  -22.5362=y
  