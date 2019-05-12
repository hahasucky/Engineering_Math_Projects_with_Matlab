% Script_Name : analyzeHousing.m
% author :
    % Han Seokhee(2013130874)
    % Chung Hyelee(2017130776)
    % Hwang Jongho(2018320177)
% < Explantion for the script >
    % This Scripte uses dataset 'dataForTesting.mat' and ( PCA method + linear regression ) 
    % and ( linear regression ) method to make a model for housing price.
    
% Basic clearing
clear all; clear; clc;

% < Data Cleaning >

% 1). Load data
data = load('dataForTesting.mat') ;
data = data.data ;

% 2). Convert data smaller than 0 or above 10^6 to NaN
data( (data < 0) | (data > 1000000) ) = NaN ;

% 3). Replace NaN values to column's median.
S = size(data) ;
col_length = S(2) ;
for i = [1:col_length]
    before_col = data(:,i) ;
    before_col(isnan(before_col)) = nanmedian(before_col) ;
    data(:,i) = before_col ;
end
% <Data Cleaning> Done! : 'data' <= cleaned data.


% Import data from 'housingDescription.txt'
% store it into 'category' and 'description'

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
category = rawStringColumns(:, 1);
description = rawStringColumns(:, 2);
% Clear temporary variables
clearvars filename delimiter formatSpec fileID dataArray ans raw col numericData rawNumericColumns rawStringColumns;



% Divide 'data' into 'pred' and 'price'
% 1). 'pred'
pred = ones(206,13);
    for i = [1:13]
        col = data(:,i);
        pred(:,i) = col; 
    end
% 2). 'price'
price = data(:,14);



% * a) * 

% 1).   Using imagesc and corr, create a matrix of the inter-correlations of pred. 
C = zeros(13,13); % C is 'intercorrelation matrix ex) corr. of col1 -> col1,col2,col3, ... col13'
for i = [1:13]
    for k = [1:13]
        cor_value = corr(pred(:,i), pred(:,k));
        C(i,k) = cor_value;
    end
end

% 2).   Use imagesc draw colormap of correlation.
x = [1 13];
y = [1 13];
imagesc(x,y,C)

% [Question] How many variables correlate well? 
% There are 5 pairs of varibales.
% The pairs over 0.8 correlation.  (sum(sum(abs(C) > 0.8)) - 13)/2 from C



% * b) * 

%   1). PCA for 'pred' 
w = 1./var(pred); % create a vector of weights 
[wcoeff,score,latent,~,explained] = pca(pred,'VariableWeights',w); % do weighted PCA
coefforth = inv(diag(std(pred)))*wcoeff; % get orthogonal eigenvectors

%   2). biplot pred data with first 3 principal components:
biplot(coefforth(:,1:3),'Scores',score(:,1:3),'Varlabels',category(1:end-1)) % first 3 columns are each new coordinate for unit vector of PCAs. 

% [Question] Can you identify “outliers” in this plot? Use the data cursor to write down a few indices of
% potential outliers and add them to the script as comments.
%
% In the perspective of each PC 1,2,3 the following indices seems to
% be 'outliers'.
%
% (  pc1       pc2        pc3  )
% (0.36414, -0.30799, -0.077321)
% (0.072231, 0.62248, -0.17323 )
% (-0.70245,-0.062475,-0.26213 ) those three indices seems to be 'outliers'.



%   * c) *
% [Question]
%  How many components do you need to explain 70% of the variance? 
%  3 PCs.
%  How many to explain 90%? 
%  7 PCs.



%    * d) *

%   1). PCA reduction to be such that 70% is explained.
%    We will use PC 1,2,3 for dimension reduction.

%   2). Linear Regression from 3 PCA for Price. ( used \ : back slash )

bias = ones(206,1); % bias vector to add for P
P = [ bias score(:,1:3) ]; % fitting matrix : P
a = P\price; 

%   3). the residual of price fitting with PCA with 3PCs.

Three_pca_residual = norm(P*a - price);



% * e) * 

%   1). Fit Price with all 13 dimensions of pred
P = [ bias pred(:,1:13) ];
a = P\price;
%   => the residual for the above
whole_pred_residual = norm(P*a - price);

%   2). What is the fit-quality of this full model?? Better or worse – and why?
%   => The fit quality of the 'full model' is 63.3857
%   => This is better because it uses all dimension to address the price.
%   => On the other hand, PCA with 3PCs, only account for 70% of total
%   variation of data.


%   3). All three-dimension combination of pred for price linear regression
% 
%       1. make all combination of 3 columns.

three_col_combi = combnk(1:13,3);
[row col] = size(three_col_combi);

%       2. make matrix(of ones) to store the data <= 
%       column_combination mapped to fit-quality

r2orig = ones(row, col+1);

%       3. iterate on all 3 combinations and do the following:
%       *   Do linear regression for price
%       *   calculate residual for that combination of three
%       *   store ( three-columns residual ) into a row of 'r2orig' 

for i = [1:row]
    % pick one combination of 3
    test_col_comb = three_col_combi(i, :);
    P = [ bias pred(:,test_col_comb) ]; % we made 'bias' a few steps beforehand.
    a = P\price;
    residual = norm(P*a - price);
    r2orig(i,1:end-1) = test_col_comb;
    r2orig(i,end) = residual;
end


%       make copy of r2orig for furthur analysis ( e.g. ranking combinations by
%       residual value )

copy_r2_orig = r2orig; 

%   4). leave only the residual part at 'r2orig' 
r2orig = r2orig(:,4);

%   +) additional analysis for later commenting question
%   +) rank all 3 col combinations in the rank which are mapped at last column 
%   +) by the value of its residual
rank = sortrows(copy_r2_orig,4);


% [Questions] 
% 1. So is this fit-quality good? Can PCA help us to select good dimensions for fitting our linear model?

%   In the 'rank' table, Our PCA
% could rank 67 from 287, which is upper 23.34% 
% in comparison with other three dimensions' fit-quality.
% Though it's relatively high in the group,
% if we are to care about fit-quality,
% we might as well use other method of model fitting.


% 2. Which dimensions consistently have the lowest residual?

% If we view the variable 'rank', which ranks the
% combination of column in ascending order of residual,
% column 13 is included in every combination af far as rank 66
% column 4 also appears in every combination as far as rank 11

% 3. Can you interpret them using the names and descriptions in the file?

% (Insert all interpretations as comments into the script)
% The answer is given as output of 'txt' to use string values loaded from
% txt. file
txt = sprintf('The following two elements : \n%s(%s),\n%s(%s),\nhave the most influence in explaining the value of %s(%s).', category(4), description(4), category(13), description(13),category(14), description(14));
fprintf(txt)

