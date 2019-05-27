
function [minimum,xes] = gradientDescent(x0,f,stepSize,maxIter)
% check input arguments
switch nargin
    case 2
        stepSize = 0.01;
        maxIter = 1000;
    case 3
        maxIter=1000;
    case 1
        error('call as gradientDescent(x0,g,stepSize,maxIter)')
end

% iteration number
iter = 1;

% init minimum candidate
minimum = x0;

% numeric delta size
delta = 0.00001;

% check whether we want to deliver history
if nargout==2
    xes = zeros(maxIter,1);
end

% as long as it's good
while iter<=maxIter
    % update history
    if nargout==2
        xes(iter)=minimum;
    end
    
    % do one update step of gradient descent
    minimum = minimum - (stepSize*((f(minimum+delta) - f(minimum))./delta));
    iter = iter + 1;
end