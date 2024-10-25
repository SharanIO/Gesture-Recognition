clc;
close all;
% syms x0 x2 y0 y2 

data = load("Area1.mat");

datatemp = data(1,1);
datatemp = datatemp.points;

x = datatemp(:,1);
y = datatemp(:,2);
time = datatemp(:,3);

x0 = x(1);
x2 = x(3);

y0 = y(1);
y2 = y(3);
t0 = time(1);

xmin = min(x);
ymin = min(y);

xmax = max(x);
ymax = max(y);

xp = x(end);
yp = y(end);
tp = time(end);

%feature1
f1 = (x2 - x0)/sqrt(((x2 - x0)^2)+((y2 - y0)^22));

%feature2
f2 = (y2 - y0)/sqrt(((x2 - x0)^2)+((y2 - y0)^22));

%feature3
f3 = sqrt(((xmax - xmin)^2)+((ymax - ymin)^2));

%feature4
f4 = atan((ymax - ymin)/(xmax - xmin));

%feature5
f5 = sqrt(((xp - x0)^2) + ((yp - y0)^2));

%feature6
f6 = (xp - x0)/f5;

%feature7
f7 = (yp - y0)/f5;

%feature8
cal8 = [];
for i = 1:length(x)-1
   temp = sqrt(((x(i+1) - x(i))^2) + ((y(i+1) - y(i))^2));
   cal8(end+1) = temp;
end
f8 = sum(cal8);

%feature9
caltemp = [];
cal9 = [];
for i = 1:length(x)-1 
    theta = atan2((y(i+1) - y(i)),(x(i+1) - x(i)));
    caltemp(end+1) = theta;
end
for d = 1:length(caltemp)-1
    cal9(end+1) = caltemp(d+1) - caltemp(d);
end
f9 = sum(cal9);

%feature10
f10 = sum(abs(cal9));

%feature11
cal11 = cal9 .^2;
f11 = sum(cal11);

%feature12
cal12 = [];
for i = 1:length(x)-1
    energy = ((((x(i+1) - x(i))^2) + ((y(i+1) - y(i))^2))/((time(i+1) - time(i))^2));
    cal12(end+1) = energy;
end
f12 = max(cal12);

%feature13
f13 = tp - t0;

