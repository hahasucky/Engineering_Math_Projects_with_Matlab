% Function_Name : feed_forward_faulty.m
% author :
    % Han Seokhee(2013130874)
    % Chung Hyelee(2017130776)
    % Hwang Jongho(2018320177)
% < Explantion for the function >
    % feed_forward function for a standard one-hidden-layer net
    % This function adds the bias term internally to the last element.

function O = feed_forward_faulty(X,W,type)

if nargin == 2
    
    % Hidden layer function
    tmp = [X ones(size(X,1),1)]*W{1}';
    O{1} = activation(tmp);

    % Output layer function
    tmp = [O{1} ones(size(O{1},1),1)]*W{2}';
    O{2} = activation(tmp);
    
else % in case there is a specified type of activation
     % Hidden layer function
    tmp = [X ones(size(X,1),1)]*W{1}';
    O{1} = activation(tmp, type);

    % Output layer function
    tmp = [O{1} ones(size(O{1},1),1)]*W{2}';
    O{2} = activation(tmp, type);
    
end

end