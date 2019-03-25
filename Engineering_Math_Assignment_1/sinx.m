% Script Name : sinx(.m)
    % author :
    % Han Seokhee(2013130874)
    % Chung Hyelee(2017130776)
    % Hwang Jongho(2018320177)
% < Explantion for the script >
    % 1). Plot abs(sin(x)/x) 
    % 2). Compute limit values of the function at various points

% Basic settings
% Clear workspace, output window and close all the figures.
clear all; close all; clc; 

% Create a numbered figure and set the position property
fig = figure(1);
fig.Position = [ 0 0 600 400 ];     % [left bottom width height]

% Make an array x with points 
% and produce f which is an array of results of the given function
x = -100:.05:100;
f = abs(sin(x)./x);     % element-wise operation

% Map the x, f(x) and display the graph in the figure window
plot(x, f)

% Save the plot as sinc.png
saveas(gcf, 'sinc.png')


% Answers to the questions
% 1a) The value of f(0) does not actually exist,
%     but it seems to be 1.
% 1b) f(0) cannot have a real number as a value since f(0) has 0 
%     as a numerator. The abcense of the value at x=0 illustrates
%     that MATLAB does not draw undefinable values when plotting.
% 2) The value seems to be 0.


% Define above function one more time with a symbolic variable t
syms t;
f = abs(sin(t)/t);

% Calculate limit values as t approaches 0, +infinity, -infinity
a = limit(f, 0);
b = limit(f, inf);
c = limit(f, -inf);

% Print out results and explanation.
fprintf('The limit value of the function is %d as t approaches 0.\n', a);
fprintf('The limit value of the function is %d as t approaches positive infinity.\n', b);
fprintf('The limit value of the function is %d as t approaches negative infinity.\n', c);