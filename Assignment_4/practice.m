% Plot the given data in subplot1
subplot(1,2,1)
plot(years+2000, funded, 'O', 'linewidth', 2, 'displayname', 'funded')
hold on
plot(years+2000, nonfunded, 'O', 'linewidth', 2, 'displayname', 'non-funded')
set(gcf,'position',[10,100,1400,600])
xlabel('year')
ylabel('the number of projects')
xlim([2008 2021])
ylim([-1e+4 7e+4])
title('\fontsize{16}polynomials with degree 1 to 7')
grid on

% polynomial fitting
for i = 1:7
    
    A = years.^[0:i];       % a Vandermonde matrix

    % Find polynomial coefficients with backslash
    coeffF = A\funded;      % coefficients of funded
    coeffN = A\nonfunded;   % coefficients of non-funded
    
    % Plot the models in subplot1
    xplot = 8:0.05:21;
    yplotF = (xplot').^[0:i]*coeffF;    % models for funded
    plot(xplot+2000,yplotF,'displayname',sprintf('funded (degree %d)', i));  
    yplotN = (xplot').^[0:i]*coeffN;    % models for non-funded
    plot(xplot+2000,yplotN,'displayname',sprintf('non-funded (degree %d)', i)); 
    
end
legend('location','NorthWest')

%     For funded projects, degree 2 model seems to be the most appropriate.
% We need to find the model with lower error for fit quality and at the
% same time try to find the model with lower degree, for generalizability.
% Models with degree 3 and 5 abruptly fall before 2020, so they cannot
% estimate the number of projects. Also, models with degree 4,6,7 rise
% in the near future without any reason, so they are not likely to be good 
% predictor models too. The fit quality of degree 2 is high and the model
% works fine as a predictor model of 2020, so we chose degree 2 model as
% the best-fit model.

%     For non-funded projects, degree 2 model seems to be the best option
% from those 7 polynomial degrees. The functions with higher degrees
% display unreasonable drop in the adjacent years ahead, such as degree 3 
% model reaching value 0 near 2018. In the process of balancing 
% generalizability and fit quality, degree 2 was chosen. It is relatively
% reasonable in explaining unfunded project numbers in general, has low
% degree and weak wiggle, and has lower error than degree 1.

%      As explained, the degrees of the best-fit models for the two
% datasets are the same. This is because the trends of the two datasets are
% roughly similar. They rise and fall in similar times. Their only
% difference is that the plot of funded projects is smoother than the 
% non-funded.

% Plot the given data in subplot2
subplot(1,2,2)
plot(years+2000, funded, 'O', 'linewidth', 2, 'displayname', 'funded')
hold on
plot(years+2000, nonfunded, 'O', 'linewidth', 2, 'displayname', 'non-funded')
xlabel('year')
ylabel('the number of projects')
xlim([2008 2021])
ylim([-1e+4 7e+4])
grid on

% Plot best-fit models in subplot2
title('\fontsize{16}best-fit models')
A = years.^[0:2];       % a Vandermonde matrix
coeffF = A\funded;      % coefficients of funded
coeffN = A\nonfunded;   % coefficients of non-funded
xplot = 8:0.05:21;
yplotF = (xplot').^[0:2]*coeffF;    % model for funded
plot(xplot+2000,yplotF,'displayname','funded (degree 2)')
yplotN = (xplot').^[0:2]*coeffN;    % model for non-funded
plot(xplot+2000,yplotN,'displayname','non-funded (degree 2)') 

% Predict the number of projects in 2020
X = 20;
YF = X.^[0:2]*coeffF    % prediction of funded in 2020
YN = X.^[0:2]*coeffN    % prediction of non-funded in 2020
plot(X+2000, YF, 'o', 'displayname', 'prediction of funded')
plot(X+2000, YN, 'o', 'displayname', 'prediction of non-funded')
legend('location','NorthWest')
% There will be about 927 funded projects and 59335 non-funded projects
% in 2020.