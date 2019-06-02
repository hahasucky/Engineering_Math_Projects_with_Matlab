% Function Name : SI(.m)
    % author :
    % Han Seokhee(2013130874)
    % Chung Hyelee(2017130776)
    % Hwang Jongho(2018320177)
% < Explantion for the function >
    % 1). Approximate sin(x)/x function with Taylor series
    % 2). Integrate the series term by term
    
function [sum] = SI(x,n)
%SI implements integration using Taylor series.
%   The second input argument is the degree of Taylor series
%   and is optional.

% set the value of n if it is not supplied
if nargin == 1
    n = 10;
end

% integrate the Taylor series of sin(x)/x term by term
syms a;
sum = 0;
for p = 0:n/2
    term = (-1)^p/factorial(2*p+1)*a^(2*p+1)/a;
    sum = sum + int(term, x);    % term by term integration
end

% return the result of integration
integral = sum;

end

