% Script_Name : analyzeHousing.m
% author :
    % Han Seokhee(2013130874)
    % Chung Hyelee(2017130776)
    % Hwang Jongho(2018320177)
% < Explantion for the script >
    % This Scripte uses PCA and linear regression
    % to make a model to fit price data from other 13 dimensions of other data.
    
% Basic clearing
%clear all; clear; clc;

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



% Import category names & description into two seperate variable.
% Imported using Import Data Wizard
% ': 'seperated columns are respectively stored at 'category' and
% 'description' variable.



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
C = zeros(13,13); % C is 'intercorrelation matrix ex) corr. of col1 -> 1,2,3, ... 13'
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

% 3).   How many variables correlate well? 6 variables.
% There are 5 pairs,
% that are having over 0.8 correlation.  (sum(sum(abs(C) > 0.8)) - 13)/2 



% * b) * 

%   1). PCA for 'pred' 
w = 1./var(pred); % create a vector of weights 
[wcoeff,score,latent,~,explained] = pca(pred,'VariableWeights',w); % do weighted PCA
coefforth = inv(diag(std(pred)))*wcoeff; % get orthogonal eigenvectors

%   2). biplot pred data with first 3 principal components:
biplot(coefforth(:,1:3),'Scores',score(:,1:3),'Varlabels',category(1:end-1)) % first 3 columns are each new coordinate for unit vector of PCAs. 

%   3). Can you identify “outliers” in this plot? Use the data cursor to write down a few indices of
% potential outliers and add them to the script as comments.
% In the perspective of each PC 1,2,3 the following indices of row seems to
% be outliers.
% (pc1, pc2, pc3)
% (0.36414, -0.30799, -0.077321)
% (0.36414, -0.30799, -0.077321)
% (0.32908, -0.19356, -0.28444) seems to be outsiders.



%   * c) *

%   How many components do you need to explain 70% of the variance? 3 PCs.
%   How many to explain 90%? 7 PCs.


%    * d) *

%   1). PCA reduction to be such that 70% is explained.
% => We will use PC 1,2,3 for dimension reduction.

%   2). Linear Regression from 3 PCA for Price. ( used \ : back slash )

bias = ones(206,1); % bias vector to add for P
P = [ bias score(:,1:3) ]; % fitting matrix : P
a = P\price; % 

%   3). the residual of price fitting with PCA - 3PC
Three_pca_residual = norm(P*a - price);
%   it calculates to be : -2.895461648222408e-13 
% It fits the the price 
% making error less than 10^-12 in average.


% * e) * 

%   1). Fit Price with all 13 dimensions of pred
P = [ bias pred(:,1:13) ];
a = P\price;
%    => the residual for the above
whole_pred_residual = norm(P*a - price);

%   2). What is the fit-quality of this full model?? Better or worse – and why?
%   => The fit quality is 5.119460411151522e-12,
%   => whereas the fit quality is -2.895461648222408e-13 for 3PC model.
%   => Why? (Not answered)

%   3). All three-dimension combination of pred 
%   for price linear regression
% 
%       1. make all combination of 3 columns.

three_col_combi = combnk(1:13,3);
[row col] = size(three_col_combi);

%       2. make ones matrix to store : column_combination mapped to residual 

r2orig = ones(row, col+1);

%       3. iterate on all 3 combinations
%       * Do linear regression for price.
%       * calculate residual for that combination.
%       * store [ three columns (mapped)residual ] into 'r2orig' for each
%       row

for i = [1:row]
    % pick one comb.
    test_col_comb = three_col_combi(i, :);
    P = [ bias pred(:,test_col_comb) ];
    a = P\price;
    residual = norm(P*a - price);
    r2orig(i,1:end-1) = test_col_comb;
    r2orig(i,end) = residual;
end

% make copy of r2orig for furthur analysis
copy_r2_orig = r2orig; 

%   4). Save above residuals at 'r2orig'
r2orig = r2orig(:,4);

%   +) additional analysis for later commenting question
copy_r2_orig(:, 4) = abs(copy_r2_orig(:,4));

% rank all 3 col combination in the rank mapped to absolute value of its residual
rank = sortrows(copy_r2_orig,4);

%    5). 
% 1. Which dimensions consistently have the lowest residual?
% If we view the variable 'rank', which ranks the
% combination of column in ascending order of residual,
% column 13 is included in every combination until rank 66
% column 4 also appears in every combination til rank 11

% 2. Can you interpret them using the names and descriptions in the file? 
% (Insert all interpretations as comments into the script)
txt = sprintf('The following two elements:\n%s(%s),\n%s(%s),\nhave relatively strong influence in explaining price.', category(4), description(4), category(13), description(13));
fprintf(txt)

