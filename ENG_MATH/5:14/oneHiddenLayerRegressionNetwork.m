
function oneHiddenLayerRegressionNetwork(hidden_layer_size,numEpochs,lr)
input_layer_size = 2;
output_layer_size = 1;

% init weights
Wh = randn(input_layer_size, hidden_layer_size) * sqrt(2.0/input_layer_size);
Wo = randn(hidden_layer_size, output_layer_size) * sqrt(2.0/hidden_layer_size);

% init biases
Bh = ones(1, hidden_layer_size)*0.1;
Bo = ones(1, output_layer_size)*0.1;

% create data for regression
xs=linspace(-2,2,20);
ys=linspace(-2,2,20);
counter=1;
data=[];
labels=[];
for r=1:length(xs)
    for c=1:length(ys)
        data(counter,:)=[xs(r) ys(c)];
        labels(counter,1)=xs(r)^2+ys(c)^2+1;
        counter=counter+1;
    end
end

% normalize data
data(:,1)=data(:,1)/norm(data(:,1));
data(:,2)=data(:,2)/norm(data(:,2));

numData = size(data,1);

% learning rate
lr = .001;


%% main loop
for iter=1:numEpochs
    % this is stochastic gradient descent
    for j = 1:numData
        % select a random data point
        selectedInd = 1+floor(rand*numData);
        % set the current data
        selectedData = data(selectedInd,:);
        selectedLabel = labels(selectedInd);
        % do one step of backpropagation on that data
        [Wh,Wo]=backprop(selectedData, selectedLabel, Wh, Bh, Wo, Bo, lr);
    end
    % write out result (one hundred epochs !!)
    if mod(iter,100)==0
        [yHat,Zo,Zh,H] = feed_forward(data, Wh, Bh, Wo, Bo);
        fprintf('iter %05d: %f\n',iter,loss(yHat,labels));
    end
end
%% check final result
[yHat,Zo,Zh,H] = feed_forward(data, Wh, Bh, Wo, Bo);
fprintf('iter %05d: %f\n',iter,loss(yHat,labels));
[xsm,ysm]=meshgrid(xs,ys);
figure(101);
subplot(1,2,1)
surf(xsm,ysm,xsm.^2+(ysm.^2)+1)
subplot(1,2,2)
surf(xsm,ysm,reshape(yHat,length(xs),length(xs)))
end

%% this is the relu activation function
function r = relu(Z)
    r = max(0, Z);
end

%% this is the feed_forward function
function [yHat,Zo,Zh,H] = feed_forward(X,Wh,Bh,Wo,Bo)
    %
    %X    - input matrix
    %Zh   - hidden layer weighted input
    %Zo   - output layer weighted input
    %H    - hidden layer activation
    %y    - output layer
    %yHat - output layer predictions
    %

    % Hidden layer function
    Zh = X*Wh + repmat(Bh,size(X,1),1); % adds the bias
    H = relu(Zh); % stick it into acti func.

    % Output layer function
    Zo = H*Wo + repmat(Bo,size(X,1),1); % Output weight
    yHat = relu(Zo); 
end

%% derivative of relu
function o = relu_der(z) 
    o = double(z > 0); % boolean problem 
end

%% calculate loss 
function l = loss(yHat, y)
    l= 0.5 * (yHat - y)'*(yHat-y);
end

%% derivative of loss 
function ld = loss_der(yHat, y)
    ld= yHat - y;
end

%% backpropagation step 
function [Wh,Wo]=backprop(data, labels, Wh, Bh, Wo, Bo, lr)
    % push the data through the network
    [yHat,Zo,Zh,H] = feed_forward(data, Wh, Bh, Wo, Bo);
    
    % layer errors for output layer
    Eo = (yHat - labels).* double(Zo>0);
    % layer error for input layer
    Eh = Eo .* double(Zh>0) ;

    % loss derivative for weight of output layer
    dWo = Eo*H;
    
    % loss derivative for weight of hidden layer
    dWh = Eh'* data;

    % update weights
    Wh = Wh-lr * dWh'; % learning rate
    Wo = Wo-lr * dWo';
end