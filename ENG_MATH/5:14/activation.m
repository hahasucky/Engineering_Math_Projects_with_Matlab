
function out = activation(x,type)
    if nargin==1
        type='tanh';
    end
    
    switch type
        case 'tanh'
            out = tanh(x);
        case 'logistic'
            out = 1./(1+exp(-x));
        case 'relu'
            out = max(zeros(size(x)),x);
        case 'perceptron'
            out = double(x>=0); % 0, 1 output.
        case 'linear'
            out = x;
        otherwise
            error(['do not know type ' type])
    end
    

% 너의 선택이야.
% Rectified Linear Unit.