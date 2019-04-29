function [integral] = integrate(function_handle, x_values, h, type)
    % Author : 
    % Han Seokhee(2013130874)
    % Chung Hyelee(2017130776)
    % Hwang Jongho(2018320177)
    % Input : function handle, x values array, h, type of appoximation 
    % Output : integral values in array for each interval of x valuse.
    % The third and the fourth input arguments are optional.

% set h and type if they are not supplied
if nargin == 2
    h = 1e-5;
    type = 'trapezoid';
end
if nargin == 3
    % In case, we missed h and put type input into 3rd argu. variable.
    % put it into 4th and set h as default.
    if ischar(h)
        type = h;
        h = 1e-5;
    else
        type = 'trapezoid';
    end
end

% guarantee that h is smaller than avg. difference of x_values array
if h >= mean(diff(x_values)) % mean of adjacent difference in x_values array
    error('You need a smaller h');
end

% trapezoidal method
if strcmp(type, 'trapezoid')
    area = zeros(1, length(x_values)-1);
    for k = 1:length(x_values)-1
        steps = x_values(k):h:x_values(k+1);
        for m = 1:length(steps)-1
            area(k) = area(k) + ...
                (function_handle(steps(m))+function_handle(steps(m+1)))*h/2;
        end
    end

% midpoint method
elseif strcmp(type, 'midpoint')
    area = zeros(1, length(x_values)-1);
    for k = 1:length(x_values)-1
        steps = x_values(k):h:x_values(k+1);
        for m = 1:length(steps)-1
            area(k) = area(k) + h*function_handle((steps(m+1)+steps(m))/2);
        end
    end
end

integral = area;

end



