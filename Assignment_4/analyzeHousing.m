% Basic clearing
clear all; clear; clc;

% Load data
data = load('dataForTesting.mat') ;
data = data.data ;

% Data Cleaning
%   1). Convert minus or above mil. to NaN
data( (data < 0) | (data >= 1000000) ) = NaN ;

%   2). Replace or the NaN value to the median(without nan) value of the corresponding Col
S = size(data) ;
col_length = S(2) ;
for i = [1:col_length]
    before_col = data(:,i) ;
    before_col(isnan(before_col)) = nanmedian(before_col) ;
    data(:,i) = before_col ;
end
%   Done). variable 'data' is now cleaned data.

% Import category names and description into two seperate variable.
    % imported through 'Import Data Wizard'
    % category, description variable.
    
% Divide Data into pred, price.

pred = ones(206,13);
    for i = [1:13]
        col = data(:,i);
        pred(:,i) = col; % pred is a cell : has 13 col array.
    end
    
price = data(:,14);

% a) 1). Using imagesc and corr, create a matrix of the inter-correlations of pred. 
%    2). How many variables correlate well?

% 1). Using imagesc and corr, create a matrix of the inter-correlations of pred. 
%   make a correlation matrix C
C = zeros(13,13);  % C is correlaton matrix
for i = [1:13]
    for k = [1:13]
        cor_value = corr(pred(:,i), pred(:,k));
        C(i,k) = cor_value;
    end
end

%   draw correlation color map
x = [1 13];
y = [1 13];
imagesc(x,y,C)

% 2). How many variables correlate well? 6 variables.
% col 3, 5, 7, 8, 9, 10  have larger than 0.7 (in abs. value )
% correlationship with other 3 ~ 5 columns.


% b) We want to now reduce the variables in 'pred' to the “core directions” of our data. 
% For this, we will do PCA. However, we have a problem – the data in pred is very differently scaled and PCA is sensitive to that.
% Therefore, we will weight each of the data dimensions using the inverse of their variance!
% You can do this in Matlab using the following commands:

w = 1./var(pred); % create a vector of weights 
[wcoeff,score,latent,~,explained] = pca(pred,'VariableWeights',w); % do weighted PCA
coefforth = inv(diag(std(pred)))*wcoeff; % get orthogonal eigenvectors

% Plot one with the first three principal components:
biplot(score(:,1:3))

% Can you identify “outliers” in this plot? Use the data cursor to write down a few indices of
% potential outliers and add them to the script as comments.
% From PC1 : 54th, 115th, 119th / PC2 : 65th, 115th / PC3 : 54th, 66th (th : ~th variable in the plot)

% c) Explained contains the explained variance of each of the principal components. Insert as comments into the script.
% How many components do you need to explain 70% of the variance? 3 PCs.
% How many to explain 90%? 7 PCs.

% d) Let’s choose the number of components for reduction to be such that 70% is explained.
% We will use PC 1,2,3 for dimension reduction.

bias = ones(206,1);
P = [ bias score(:,1:3) ];
a = P\price;

% the residual of price fitting with PCA - 3PC
three_pca_residual = sum(P*a - price);


% e) So is this fit-quality good? Can PCA help us to select “good” dimensions for fitting our linear model?

P = [ bias pred(:,1:13) ];
a = P\price;

% the residual of price fitting with whole 13 dim of pred
whole_pred_residual = sum(P*a - price);


% What is the fit-quality of this full model?? Better or worse – and why?
% fit quality is better for 3PCA model.

% Implement code that lists all possible sets of 3 from 13, does the linear regression,
% and saves the fit-quality in a vector r2orig.

% make all combination of 3 PCAs.
pc_comb = combnk(1:13,3);
[row col] = size(pc_comb);

% make ones matrix to store combination < = > residual 
r2orig = ones(row, col+1);

% iterate on comb, calculate residual, 
% and store ( combination residual ) into r2orig
for i = [1:row]
    % pick one comb.
    test_pca_comb = pc_comb(i, :);
    P = [ bias pred(:,test_pca_comb) ];
    a = P\price;
    residual = sum(P*a - price);
    r2orig(i,1:end-1) = test_pca_comb;
    r2orig(i,end) = residual;
end

format long

% Compare abs. residual to determine in which dimension it becomes minimum.
r2orig(:, 4) = abs(r2orig(:,4))
rank = sortrows(r2orig,4);
rank
% Which dimensions consistently have the lowest residual? 
% Can you interpret them using the names and descriptions in the file? 
% Insert all interpretations as comments into the script.


