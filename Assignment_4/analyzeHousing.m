% Basic clearing
clear all; clc;

% Load data
data = load('dataForTesting.mat')
data = data.data

% Data Cleaning
%   1). Convert minus or above mil. to NaN
data( (data < 0) | (data >= 1000000) ) = NaN

%   2). Replace or the NaN value to the median(without nan) value of the corresponding Col
S = size(data)
col_length = S(2)
for i = [1:col_length]
    before_col = data(:,i)
    before_col(isnan(before_col)) = nanmedian(before_col) 
    data(:,i) = before_col
end
%   3). data = is now cleaned data.

