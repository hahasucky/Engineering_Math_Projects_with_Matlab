% Script_Name : kickstarter.m
% author :
    % Han Seokhee(2013130874)
    % Chung Hyelee(2017130776)
    % Hwang Jongho(2018320177)
% < Explantion for the script >
    % This script fits kickstarter funded and non-funded data with 1~7
    % degrees of polynomial function to make a polynomial prediction model.

% Basic Clearing
close all; clear all; clc;

% save kickstarter data(09'-16')
funded = [373, 3772, 10746, 16903, 19271, 22233, 22036, 18823];
not_funded = [501, 4825, 12516, 22749, 24823, 44325, 54831, 39251];

% x axis data : year
x = [9,10,11,12,13,14,15,16];

% For ease, make above three array into column-array-concat matrix
y = [x' funded' not_funded'];

% Scatterplot the original data(funded, not funded)
scatter(y(:,1),y(:,2),'displayname','Funded Project'); grid on; xlim([8, 21]); ylim([200 68000]); hold on
scatter(y(:,1),y(:,3),'r','displayname','Not Funded Project');  grid on; xlim([8, 21]); ylim([200 68000]); hold on

xplot = [9:0.03:25];

% Fitting both funded & not_funded with 1-7 polynomial
for n = [2,4]
    
    % Create Vandermonde matrix
    A=y(:,1).^[0:n]; 
    
    % define y_i of Both Funded & not_funded data
    f_b = y(:,2);
    nf_b = y(:,3); 
    
    % solve coefficient using backslash : both coefficient for funded and not_funded
    coeff_funded = A\f_b;
    coeff_not_funded = A\nf_b;
    
    % y plot for error minimized polynomial approximation function.
    funded_y_plot = (xplot').^[0:n]*coeff_funded;
    not_funded_y_plot = (xplot').^[0:n]*coeff_not_funded;

    % error calculation
    %err_funded(n) = norm(A*coeff_funded - f_b);
    %err_not_funded(n) = norm(A*coeff_not_funded - nf_b);
   
    
    % Result plot
    
    if n == 4
    % yield estimate of funded at x = 20
    funded_pred = [1,20,20^2,20^3,20^4]*coeff_funded;
    % plot the model for funded / prediction at 20'
    plot(xplot, funded_y_plot,'b', 'linewidth',1, 'displayname', 'model:funded'); hold on; %sprintf('Degree %d: Error =%f', n, err_funded(n)) );
    scatter([20],funded_pred,'filled','k','displayname', 'funded at 20'); hold on;
    end
    
    if n == 2
    % yield estimate of not_funded at x = 20
    not_funded_pred = [1,20,20^2]*coeff_not_funded;
    
    % plot the model for not_funded / prediction at 20'
    plot(xplot, not_funded_y_plot,'r','linewidth',2, 'displayname', 'model:not funded'); %sprintf('Degree %d: Error =%f',n, err_not_funded(n)));
    scatter([20],not_funded_pred, 'k', 'displayname', 'not funded at 20'); hold on;
    hold on

    end
end

% set legend
legend('location', 'northwest')


% Which of the models do you think fits the data best for each of the two datasets 
% (remember the compromise between fit quality and generalizability!!!) 
% Do the degrees differ for the two datasets? Why would they? Why would they not?

%For 'funded', degree = 4 seems to be the most appropriate model.
% In assumption, 
% * I need to find the model with lower error for 'fit quality'
% * And at the same time, with balance, try to find the model with lower degree for
%'generalizability' as it is basically for prediction.
%   The fit quality  does not improve that rapidly after it has 
% sudden drop between degree=2 and degree=3, so the fit quality for degree=4 is relatively
% decent. 
% At the same time, 
% unlike degree 4,5,6 which have stronger wiggle and predicts near 0 or minus value 
% for 2020 or near future, 
% the degree=4 model not only has lower degree but also has even weaker wiggle
% in the interval of near future than degree 3 which predicts abnormally
% large number for near future.
%   For 'not funded', degree = 2 model seems to be the least worst option
% from those 7 polynomial degrees.
% The function with degrees higher than 2 displays unreasonable drop in the
% adjacent years ahead, such as degree = 3 model reaching value 0 near year 18'.
% In the process of balancing generalizability and fit quality,
% degree = 2 was chosen as it is relatively reasonable in explaining
% unfunded project numbers in general, has low degree and weak wiggle,
% and has lower error than degree = 1.


% Plot the measured data points, along with your best-fit model into the same plot. 
% Using your model as a predictor model, how many projects will be funded and non-funded in 2020? 
% Plot these points as well into the same plot.
% Make sure to insert all observations and interpretations as comments into your script!

% funded in 2020 :  1.6181e+04
% non-funded in 2020 : 5.9335e+04

% hint : "What would help the most in reality prediction."