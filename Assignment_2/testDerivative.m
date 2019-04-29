% Script_Name   : testDerivative.m
% Assignment    : Assignment2, Part1
% Explanation   : Tests instances of function derivatives
% Author        : 2013130874 Han Seok Hee
%               : 2017130776 CHUNG Hyelee
%               : 2018320177 Hwang Jongho

% Clear workspace, output window and close all the figures.
clc; clear all; close all;

% given values
h = 10.^[-1:-1:-14];
x_values = [.001:.01:2];

% three given functions to derivate
f1 = @(x) x.^2;
f2 = @(x) cos(x);
f3 = @(x) sin(x)./x;

% hand-derived derivatives of the given functions
g1 = @(x) 2*x;
g2 = @(x) -sin(x);
g3 = @(x) (x.*cos(x) - sin(x))./(x.^2);

% calculating SSEs for numerical derivation of f1
sse1 = zeros(1,length(h));
for i = 1:length(h)
    output1 = derive(f1, x_values, h(i));
    sse1(i) = sum((output1 - g1(x_values)).^2);
end
semilogy(sse1)   % plot sse1 with logarithmic scale
hold on

% calculating SSEs for numerical derivation of f2
sse2 = zeros(1,length(h));
for i = 1:length(h)
    output2 = derive(f2, x_values, h(i));
    sse2(i) = sum((output2 - g2(x_values)).^2);
end
semilogy(sse2)   % plot sse2 with logarithmic scale
hold on

% calculating SSEs for numerical derivation of f3
sse3 = zeros(1,length(h));
for i = 1:length(h)
    output3 = derive(f3, x_values, h(i));
    sse3(i) = sum((output3 - g3(x_values)).^2);
end
semilogy(sse3)   % plot sse3 with logarithmic scale
hold on
ylabel('SSE (log scale)')
legend('x.^2 SSE','cos(x) SSE', 'sin(x)./x SSE')

% Questions
% 1. Why do the errors first go down and go up again ?
% In the given functions cos(x), sin(x)./x, 
% for which computer uses taylor series of high degree polynomial to calculate the function value 
% and x^.2 function,
% the numeric derivative calculation using (f(x+h) - f(x)) / h, starts to make error 
% in calculating numeric derivative compared to real derivative 
% since the h is 10^-10, 
% because the calculation begin to involve the values that are so small 
% that are out of the limit of the precision of 'matlab double' in the derivative calculation steps.


% 2. Why do you think error curves for the three functions are different ?
%
% It is x.^2 > cos(x) > sin(x)./x to list the given functions in descending order of
% SSE. A gap between the real derivative value and numeric derivative
% is basically due to the fact that 
% the <real derivative> is the slope of tangent at a point, 
% whereas the <numeric derivative> is rather the slope between 
% the point and the point that is smallh away from that point. 
% And If the absolute value of curvature of a given function is higher, 
% the gap between tangent slope and the slope between smallh-distanced 
% points will be bigger. We thought this is why the above SSE value order
% come out as above.

