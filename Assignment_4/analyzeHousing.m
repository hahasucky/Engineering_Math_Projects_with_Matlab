% Basic clearing
% clear all; clear; clc;


% Load data
data = load('dataForTesting.mat') ;
data = data.data ;


% Data Cleaning

%   1). Convert data smaller than 0 or above 10^6 to NaN
data( (data < 0) | (data > 1000000) ) = NaN ;

%   2). Replace NaN values to the median(without nan) value 
% of the corresponding column
S = size(data) ;
col_length = S(2) ;
for i = [1:col_length]
    before_col = data(:,i) ;
    before_col(isnan(before_col)) = nanmedian(before_col) ;
    data(:,i) = before_col ;
end
%Data Cleaning done : 'data' <= cleaned data.


% Import category names & description into two seperate variable.
    % imported through 'Import Data Wizard'
    % 'category', 'description'
    
    
% Divide 'data' into 'pred' & 'price'.
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

%   use imagesc draw colormap.

x = [1 13];
y = [1 13];
imagesc(x,y,C)

% 2).   How many variables correlate well? 6 variables.
% col 3, 5, 7, 8, 9, 10  have larger than 0.7 correlationship in absolute value with other 3 ~ 5 columns.



% * b) * 

%   1). PCA for 'pred' 

w = 1./var(pred); % create a vector of weights 
[wcoeff,score,latent,~,explained] = pca(pred,'VariableWeights',w); % do weighted PCA
coefforth = inv(diag(std(pred)))*wcoeff; % get orthogonal eigenvectors

%   2). biplot pred data with first 3 principal components:

biplot(score(:,1:3)) % first 3 columns are each new coordinate for unit vector of PCAs. 

%   3). Can you identify “outliers” in this plot? Use the data cursor to write down a few indices of
% potential outliers and add them to the script as comments.
% In the perspective of each PC 1,2,3 the following indices of row seems to
% be outliers.
%   PC1 : 54th, 115th, 119th / PC2 : 65th, 115th / PC3 : 54th, 66th (th : ~th row pred element)



%   * c) *

%   How many components do you need to explain 70% of the variance? 3 PCs.
%   How many to explain 90%? 7 PCs.



% * d) *

%   1). PCA reduction to be such that 70% is explained.
% => We will use PC 1,2,3 for dimension reduction.

%   2). Linear Regression from 3 PCA for Price. ( used \ : back slash )

bias = ones(206,1); % bias vector to add for P
P = [ bias score(:,1:3) ]; % fitting matrix : P
a = P\price; % 4 dimension 'a' vector ( linear-regression-related solution )

%   3). the residual of price fitting with PCA - 3PC
Three_pca_residual = sum(P*a - price);
%   it calculates to be : -2.895461648222408e-13 
% It fits the the price 
% making error less than 10^-12 in average.


% * e) * 

%   1). All 13 dimension pred

P = [ bias pred(:,1:13) ];
a = P\price;
%        => the residual for the above
whole_pred_residual = sum(P*a - price);
%        it calculates tobe 5.119460411151522e-12

%   2). What is the fit-quality of this full model?? Better or worse – and why?
% fit quality is better for 3PCA model.

%   3). All 3 dimension combination of pred for linear regression

%       1. make all combination of 3 PCAs.

pc_comb = combnk(1:13,3);
[row col] = size(pc_comb);

%       2. make ones matrix to store combination < = > residual 

r2orig = ones(row, col+1);

%       3. iterate on all 3 combinations and calculated residual for each. 
%       And stored ( 3-column-combination residual ) into 'r2orig' for
%       each iteration

for i = [1:row]
    % pick one comb.
    test_pca_comb = pc_comb(i, :);
    P = [ bias pred(:,test_pca_comb) ];
    a = P\price;
    residual = sum(P*a - price);
    r2orig(i,1:end-1) = test_pca_comb;
    r2orig(i,end) = residual;
end

%   Sort all absolute residual 
format long
r2orig(:, 4) = abs(r2orig(:,4));
rank = sortrows(r2orig,4);
rank; % three cols combination mapped to fit quality sorted using fit quality in asc. order.

%       4. make final variable 'r2orig' leaving only fit-quality sorted in ascending order.
r2orig = rank(:,4)



%   4). Which dimensions consistently have the lowest residual?
% Considering Top 10 fit quality
% dimension 2, 7 ,13 make 4, 5, 4 appearances respectively.

% Can you interpret them using the names and descriptions in the file? 
% Insert all interpretations as comments into the script.
txt = sprintf('The following three elements \n%s(%s),\n%s(%s),\n%s(%s)\nexplains price relatively well.', category(2), description(2), category(7), description(7), category(13), description(13));
fprintf(txt)

