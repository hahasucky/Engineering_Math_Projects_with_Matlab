% Script_Name : testOneLayer.m
% author :
    % Han Seokhee(2013130874)
    % Chung Hyelee(2017130776)
    % Hwang Jongho(2018320177)
% < Explantion for the script >
    % 1) Loads the data
    % 2) Learns two classes of the data with a one-hidden-layer neural network
    % 3) Plot the data
    
clear;

load('wave.mat')
wave(:,3) = wave(:,3) - 1;

% Assign random values as initial weights
weights{1} = randn(10, 3);
weights{2} = randn(1, 11);

% stochastic gradient descent
for epochs = 1:10000
    
    for j = 1:200
        
        % Select a random data point
        ind = 1+floor(rand*200);

        % Set the current data
        data = wave(ind,[1,2]);
        labels = wave(ind, 3);

        % Do one step of backpropagation on that data
        [weights,~]=backprop_faulty(data,weights,labels,.01,'logistic');
        
    end
    
end


% original data
% Classify the original data 
class1 = [];
for i = find(wave(:,3)>0.5)
    class1 = [class1; wave(i, :)];
end
class0 = [];
for i = find(wave(:,3)<0.5)
    class0 = [class0; wave(i, :)];
end

% Plot the original data
subplot(1, 2, 1)
plot(class1(:,1), class1(:,2), 'rx'); hold on; grid on
plot(class0(:,1), class0(:,2), 'go')
title('original data')
xlim([-1 1])
ylim([-1.5 1.5])

% predicted data
% Predict the class with weights computed by backpropagation
prediction = feed_forward_faulty(wave(:,[1 2]),weights,'logistic');
pred1 = [];
for i = find(prediction{2}>0.5)
    pred1 = [pred1; wave(i, :)];
end
pred0 = [];
for i = find(prediction{2}<0.5)
    pred0 = [pred0; wave(i, :)];
end

% Plot the predicted data
subplot(1, 2, 2)
plot(pred1(:,1), pred1(:,2), 'rx'); hold on; grid on
plot(pred0(:,1), pred0(:,2), 'go')
title('predicted data')
xlim([-1 1])
ylim([-1.5 1.5])