% Function_Name : activation_der.m
% author :
    % Han Seokhee(2013130874)
    % Chung Hyelee(2017130776)
    % Hwang Jongho(2018320177)
% < Explantion for the function >
    % This function is the derivative of the activation function.
    
function out = activation_der(x,type)

    if nargin == 1
        type='tanh';
    end
    
    switch type
        case 'tanh'
            out = 1 - (activation(x,'tanh')).^2;
        case 'logistic'
            out = x.*(1-x);
        case 'relu'
            out = double(x>0);
        case 'perceptron'
            out = 0;
        case 'linear'
            out = 1;
        otherwise
            error(['do not know type ' type])
    end