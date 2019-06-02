% testIntegrate.m
    % Author : 
    % Han Seokhee(2013130874)
    % Chung Hyelee(2017130776)
    % Hwang Jongho(2018320177)
    %
    % It is a Script for testing integrate.m ( range by range integral approximator) 
    % and comparing SSE for trapezoidal and midpoint
    % approximation.
    
    
% Clear commandline, working memory.
clc; clear all; close all;

% Given conditons in the problem.
h = 10.^[-2:-1:-7];
x_values = [.001:.1:2];

% Given function
f = @(x) x.^2;

% calculate precise value of the definite integral
g = @(x) 1/3*x^3;
jeokbun = zeros(1, length(x_values)-1);
for i = 1:length(x_values)-1
    jeokbun(i) = g(x_values(i+1)) - g(x_values(i)); 
end

% numerical integration of f with trapezoidal method
sse1 = zeros(1,length(h));
for i = 1:length(h)
    output1 = integrate(f, x_values, h(i), 'trapezoid');
    sse1(i) = sum((output1 - jeokbun).^2);
end
semilogy(sse1)   % plot sse1 with logarithmic scale
hold on

% numerical integration of f with midpoint method
sse2 = zeros(1,length(h));
for i = 1:length(h)
    output2 = integrate(f, x_values, h(i), 'midpoint');
    sse2(i) = sum((output2 - jeokbun).^2);
end
semilogy(sse2)   % plot sse2 with logarithmic scale
hold on
legend('trapezoid','midpoint')
ylabel('SSE (log scale)')

% Questions
% 1) What happens to the error curves as h becomes smaller and why?
%       
%       It gets smaller. It is because, having smaller h for approximation
%       of integral means dividing the "approximation blocks" into more and
%       smaller peaces of trapezoids or midpoint rectangles. By having more
%       of those, underapproximated or overapproximated areas decreases 
%       when it is a "curve" that we are dealing with (in this case : x.^2) .
%    
%       
% 2) Which integration method is better?
%
%       Midpoint method which is having lower SSE is better.
%       We think the dominance in approximation comes from its each "approximation blocks"
%       having less error for real area than trapezoidal approximation's
%       blocks as it could offset the over approximated part with the under approximated part.