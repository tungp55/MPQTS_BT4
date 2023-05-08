function [fHandler]=InitializeGraphics()

global EnvironmentWidth;

fHandler = figure;
fHandler.Color = 'white';
fHandler.MenuBar =  'none'
fHandler.ToolBar = 'none';
fHandler.Name = 'Bai tap 4: Giai cuu con tim ';
fHandler.NumberTitle = 'off';
% rectangle('position',[-EnvironmentWidth -EnvironmentWidth 2*EnvironmentWidth 2*EnvironmentWidth],'EdgeColor','b','LineWidth',1);
rectangle('position',[0 0 EnvironmentWidth EnvironmentWidth],'EdgeColor','b','LineWidth',1);

hold on
xlabel('X axis')
ylabel('Y axis')
axis manual;
%axis off;
%axis([-EnvironmentMargin EnvironmentWidth+EnvironmentMargin -EnvironmentMargin EnvironmentWidth+EnvironmentMargin]);
axis([0 EnvironmentWidth 0 EnvironmentWidth]);
