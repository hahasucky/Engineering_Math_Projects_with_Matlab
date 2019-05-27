% Function_Name : backprop_faulty.m
% author :
    % Han Seokhee(2013130874)
    % Chung Hyelee(2017130776)
    % Hwang Jongho(2018320177)
% < Explantion for the function >
    % This function implements one backpropagation step
    % INPUTS:
    %           data:   array of data
    %           labels: matching labels
    %           W:      weight matrices as cell array
    %           lr:     learning rate
    %           type:   activation type
    % OUTPUT:
    %           weights:updated weight matrices as cell array
    %           delta:  update amounts for each weight matrix as cell array
    %
    
function [weights,delta] = backprop_faulty(data,W,labels,lr,type)

    if length(labels) ~= size(data,1)
        error('labels must have the same size with the data')
    end
    
    % Do a feed_forward pass to get all outputs
    O = feed_forward_faulty(data,W,'logistic');
    
    % Now get the output errors for the last layer (derivative of loss
    % function)
    errors{2} = labels - O{2};
    
    % Weight them with the derivative of the activation function of the
    % output
    delta{2} = errors{2}.*activation_der(O{2},type);
    
    % initial errors and deltas for the hidden layer
    err=zeros(size(W{1},1),1);
    del=zeros(size(W{1},1),1);
    
    % Get the hidden errors
    for j=1:size(W{1},1)
        
        % Get all connected downstream neurons and update
        for n=1:size(W{2},1)
            err(j) = err(j) + W{2}(n,j)*delta{2}(n);
        end
        
        % Again, weight the error by the derivative of the current output
        % in the activation function
        del(j)=err(j)*activation_der(O{1}(j),type);
        
    end
    
    % Assign errors and deltas to cell array for weight update step
    errors{1}=err;
    delta{1}=del;
    
    % weight update with inputs and errors - this now works from the front
    
    % Initialize input for the first layer as data
    inputs = data;
    
    % loop through layers
    for i=1:2
        
        % If we are not in the first layer, change input to output from
        % previous layer.
		if i~=1
            inputs = O{i-1};
        end
        
        % Now get all connected neurons
		for n=1:size(O{i},2)
            
            % For all inputs we have, change the weights according to
            % the learning rate
			for j=1:size(inputs, 2)
				W{i}(n,j) = W{i}(n,j) + lr*delta{i}(n)*inputs(j);
            end
            
            % the update rule for the BIAS (in the LAST element of our
            % matrix)
            W{i}(n,end) = W{i}(n,end) + lr*delta{i}(n);
            
        end
        
    end
    
    % Save the weights in different variable and return
     weights=W;
end
