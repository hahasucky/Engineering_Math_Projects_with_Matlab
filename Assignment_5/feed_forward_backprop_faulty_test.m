% Script_Name : feed_forward_backprop_faulty_test.m
% author :
    % Han Seokhee(2013130874)
    % Chung Hyelee(2017130776)
    % Hwang Jongho(2018320177)
% < Explantion for the script >
    % 1) Execute feed_forward_faulty.m
    % 2) Execute backprop_faulty.m

clear;

% sample data (2D)
data = [0.4 0.37];

% weights (input -> hidden)
W{1} = [[0.12, 0.34, 0.87];[0.29, -0.18, 0.55]; [-0.72, 0.19, 0.73]];

% weights (hidden -> output)
W{2} = [0.25, 0.49, 0.39, 0.44];

% Execute one feed forward pass
% size(O{1})==[1 3]
% size(O{2})==[1 1]
O = feed_forward_faulty(data,W);

% an expected label for our sample
expected = 0;

% Execute a backpropagation pass with the data, weights, expected
% label and a large learning rate
[weights,delta]=backprop_faulty(data,W,expected,.1,'logistic');
