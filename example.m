%---------------------------------------------
clc;
close all;

t = [0:0.001:6];
x = cos(2*pi*t);
y = cos(2*pi*t + 2*pi/3);
z = cos(2*pi*t - 2*pi/3);

%---------------------------------------------
% Charts
%---------------------------------------------

pens = {{t;x;'$x$'},...
        {t;y;'$y$'},...
        {t;z;'$z$'}};
formatedPlot(pens,'type','article','name','example','folder','./',...
    'format','png','xLabel','Time (s)','yLabel','Voltage (V)',...
    'legPos','east');

%---------------------------------------------