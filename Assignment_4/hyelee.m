% CHUNG Hyelee 2017130776

clear all; close all; clc

% Load and clean the data
load('dataForTesting.mat')
data(data < 0 | data > 100000) = NaN;
med = median(data, 'omitnan');
for i = 1:size(data,2)
    temp = data(:,i);
    temp(isnan(temp)) = med(i);
    data(:, i) = temp;
end

% Import data
% Initialize variables.
filename = 'housingDescription.txt';
delimiter = {': '};
% Read columns of data as text:
formatSpec = '%s%s%[^\n\r]';
% Open the text file.
fileID = fopen(filename,'r');
% Read columns of data according to the format.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string',  'ReturnOnError', false);
% Close the text file.
fclose(fileID);
% Convert the contents of columns containing numeric text to numbers.
% Replace non-numeric text with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));
% Split data into numeric and string columns.
rawNumericColumns = {};
rawStringColumns = string(raw(:, [1,2]));
% Allocate imported array to column variable names
ctgr = rawStringColumns(:, 1);
dscr = rawStringColumns(:, 2);
% Clear temporary variables
clearvars filename delimiter formatSpec fileID dataArray ans raw col numericData rawNumericColumns rawStringColumns;

pred = data(:, 1:end-1);    % predictor variables
price = data(:, end);       % target variable

C = zeros(1, sum(1:12));
k = 1;
for i = 1:size(pred, 2)-1
    for j = i+1:size(pred, 2)
        C(k) = corr(pred(:, i), pred(:, j));
        k = k+1;
    end
end

imagesc(C)
colorbar

% Question
% a) How many variables correlate well?
%    Five pairs of variables correlate well.
%    그림 보니까 눈 아파서 그냥 find(abs(C) > 0.8)로 찾았음

% Principal Components Analysis (PCA)
w = 1./var(pred); % Create a vector of weights
[wcoeff,score,latent,~,explained] = pca(pred,'VariableWeights',w); % Do weighted PCA
coefforth = inv(diag(std(pred)))*wcoeff; % Get orthogonal eigenvectors
biplot(coefforth(:,1:3),'Scores',score(:,1:3),'Varlabels',ctgr(1:end-1))

% outliers
% 3차원으로 보니까 뭐가 outlier인지 눈으로 판별을 잘 못 하겠음ㅠㅠ 그냥 좀 눈에 띄는 점
% 세 개 골랐음
% (0.072231, 0.62258, -0.17323), (0.32908, -0.19356, -0.28444), 
% (0.096258, 0.49752, -0.028172)

%  We need 3 components to explain 70% of the variance and 7 components
%  to explain 90%

P = [ones(length(pred),1) pred*coefforth(:,1:3)];  % a fitting matrix ...맞나?
a = P\price;
residual = norm(P*a-price)

% full fit using all 13 dimensions of the original data pred
M = [ones(length(pred),1) pred];
a = M\price;
residual = norm(M*a-price)


list = combnk([1:13], 3);   % all possible sets of 3 from 13
r2orig = zeros(length(list), 1);
for i = 1:length(list)
    P = [ones(length(pred),1) pred(:,list(i,:))];
    a = P\price;
    r2orig(i) = norm(P*a-price);   % fit quality (residual)
end
list = [list r2orig]

% Which dimensions consistently have the lowest residual?
% 13, 4, 1
[ctgr(13), dscr(13)]
[ctgr(4), dscr(4)]
[ctgr(1), dscr(1)]
