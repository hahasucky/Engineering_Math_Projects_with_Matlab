% Script Name : integrateSinc(.m)
    % author :
    % Han Seokhee(2013130874)
    % Chung Hyelee(2017130776)
    % Hwang Jongho(2018320177)
% < Explantion for the script >
    % 1). Integrate sin(x)/x with trapezoidal method
    % 2). Integrate sin(x)/x with Taylor series

% Clear workspace, output window and close all the figures.
clc; clear all; close all;

h = 10.^[-2:-1:-7];
% x_values = [.5:1:15];
x = [0.5 15];
n = [10:2:20];

% given function
f = @(x) sin(x)./x;

% numerical integration of f with trapezoidal method
output1 = zeros(length(x)-1, length(h));
for i = 1:length(h)
    output1(:,i) = integrate(f, x, h(i), 'trapezoid');
end

% integration of f using Taylor series
output2 = [];
for k = n
    output2(1, end+1) = SI(x, k);
end

% visualize the result of each integration with scatter plots
subplot(2,1,1)
scatter(h, output1)
title('trapezoidal method')
subplot(2,1,2)
scatter(n, output2)
title('Taylor series')


% Question
% Which method would you choose and why?
%       I would choose trapezoidal method. As you can see from the scatter
%       plot, the result of integration using Taylor series varies a lot
%       depending on the value of n, especially when the size of n is
%       not big enough. On the other hand, integration by trapezoidal
%       method brings about rather consistent result compared to Taylor
%       series method.