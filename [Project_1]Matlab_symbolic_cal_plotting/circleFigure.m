% Script_name : circleFigure(.m)
    % author : 
    % Han Seokhee(2013130874)
    % Chung Hyelee(2017130776)
    % Hwang Jongho(2018320177)
    
% < Explantion for the script >
    % Part 1). Plot radius-10 circle and 50-degree right-angle triangle.
    % Part 2). Annotate the angle with greek letter theta, sin theta, cos theta.
    % Part 3). Save the completed figure in jpeg.


% Basic settings
% Clear workspace, output window and close all the figures.
clear all; close all; clc; 
% Make a figure and set the figure palette size. 
fig = figure(2);
fig.Position = [470, 200, 500, 500];



% Part 1)
% Plot a circle shape  (using 2 functions(x(t), y(t) / center at (0,0)).
syms t x y ;
x = 10 * cos(t); 
y = 10 * sin(t);
fplot(x,y,[0 2*pi]) 



% p.s) Widen figure palette for later annotations
axis([-15 15 -15 15]);


% (a) Draw a 50 degree diagonal line 
% ( chosen fplot only for this to relative weak color intensity to higlight following 2 annotations )
hold on
syms z w;
w = tand(50) * z;
fplot(w, [0, 10*cosd(50)], 'k');

% (b) Draw a vertical line
hold on
b = 0 :0.01:10*sind(50);
a = (10*cosd(50)) * ones(size(b));
plot(a, b, 'k');

% (c). Draw a horizental line (triangle complete)
hold on
c = 0 :0.01:10*cosd(50);
d = zeros(size(c));
plot(c, d, 'k');



% Part 2)

% (a). annotate the angle
text(1.0, 0.65, '\theta','FontSize',16);

% (b). annotate sin and cos theta with annotation-textarrow.
% * normallized ranged input is required for annotation_textarrow
% (*the input value was produced by opensource function 'y_to_norm_v2.m' written by girish ratanpal )

% annotate cos theta with text arrow
axis_x = [0.6398, 0.6072]; % normallized x range for cos theta textarrow line input
axis_y = [0.4333, 0.5100]; % normallized y range for cos theta textarrow line input
a = annotation('textarrow',axis_x,axis_y,'String', 'cos \theta','FontSize', 16); 

% annotate sin theta with text arrow
axis_x_2 = [0.7892, 0.6900]; % normallized x range for sin arrow line [1->2]
axis_y_2 = [0.6669, 0.6099]; % normallized y range for sin arrow line [1->2]
b = annotation('textarrow',axis_x_2 , axis_y_2, 'String', 'sin \theta','FontSize', 16);



% Part 3)
% make axis invisible / save the fully-annotated figure as jpg file.
set(gca, 'visible', 'off');
saveas(fig,'circle.jpg');