% Script_Name   : gradientTestFunction.m
% Assignment    : Assignment2, Part1
% Explanation   : Tests gradient_descent(.m) function with a real function and different learning rates.
% Author        : 2013130874 Han Seok Hee
%               : 2017130776 CHUNG Hyelee
%               : 2018320177 Hwang Jongho

% Basic Clearing
clc; clear all; close all;

% given function f and its parital derivative (g1, g2) with resect to x and y 
f = @(x1,x2) x1.^2 + x1.*cos(x1.*x2/3) + 3*x2.^2;
g1 = @(x1,x2) 2.*x1 + cos(x1.*x2./3) - (x1.*x2.*sin(x1.*x2./3))./3;
g2 = @(x1,x2) 6.*x2 - (x1.^2*sin(x1.*x2./3))./3;

% Draw a surf plot of original function
[X,Y] = meshgrid(-20:0.5:20,-20:0.5:20);
Z = f(X, Y);
figure(1)
surf(X, Y, Z, 'FaceAlpha', 0.7)
hold on; grid on
xlabel('x1'); ylabel('x2'); zlabel('f')
view(20,-85)
colorbar
hold on

% [ Origninal Result ] 
[xoptimal, foptimal, niterations, x, y, z] = gradient_descent(f, g1, g2, [10 10]', 0.03, 1e-7, 1000);
fprintf('[Original Result : lambda 0.03]\n')
xoptimal
foptimal
niterations
plot3(x,y,z,'yO','LineWidth',3);

hold on

% [ Questions ]
% 1).
% What is the value of lambda up to two digits that will result in non-convergence?
% Try this out yourself and insert value of lambda into the script.
% [Answer] : If it's up to 2 digits, from about < Lambda = 0.34>, It does not converge.

[xoptimal, foptimal, niterations, x, y, z] = gradient_descent(f, g1, g2, [10 10]', 0.34, 1e-7, 1000);
fprintf('\n[Unable to Converge since lambda 0.34]')
xoptimal
foptimal
niterations
plot3(x(1:7),y(1:7),z(1:7),'r*','LineWidth',3); % quick diversion : only plot til 7
hold on

% 2).
% What is the value of lambda that has the minimum number of steps in order to reach the minimum point?
% Try this out yourself and insert the value of lambda into the script.
% [Answer] At Lambda = 0.24
candidate_stepsize = [];
candidate_iteration = [];
for i = [0.18:0.01:0.33]
    [~, ~, niterations, ~, ~, ~] = gradient_descent(f, g1, g2, [10 10]', i, 1e-7, 1000);
    candidate_stepsize(end+1) = i;
    candidate_iteration(end+1) = niterations;
end
fprintf('\n[minimum iteration stepsize]')
the_lambda = candidate_stepsize(candidate_iteration == min(candidate_iteration)) % lambda = minimum-iter stepsize

%plot with the lambda
[xoptimal, foptimal, niterations, x, y, z] = gradient_descent(f, g1, g2, [10 10]', the_lambda, 1e-7, 1000);
plot3(x,y,z,'mO','LineWidth', 3);
