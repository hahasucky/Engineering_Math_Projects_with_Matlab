% function_name : derive
% Assignment    : Assignment2, Part1
% Explanation   : finds derivative of a given function in given x values
% Author        : 2013130874 Han Seok Hee
%               : 2017130776 CHUNG Hyelee
%               : 2018320177 Hwang Jongho

function [derivative] = derive(function_handle, x_values, h)
%       DERIVATIVE implements numerical derivation on x values.
%       The third input argument is optional.

% set the default value of h if not supplied
if nargin == 2
    h = 1e-5;
end

% numerical approximation of derivation on x values
derivative = (function_handle(x_values+h)-function_handle(x_values))/h;

end

