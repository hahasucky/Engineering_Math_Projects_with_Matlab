% Script_Name : kickstarter.m
% author :
    % Han Seokhee(2013130874)

% Basic Clearing
clear all; close all; clc

% given Kickstarter data
years = [09:16]';   % x axis
funded = [373; 3772; 10746; 16903; 19271; 22233; 22036; 18823];
nonfunded = [501; 4825; 12516; 22749; 24823; 44325; 54831; 39251];

% plot fitting polynomial, and calculate norm error in each legend

% plot original data
plot(2000+years, funded, 'rO','linewidth', 1, 'displayname', 'funded' )
hold on
%plot(2000+years, nonfunded, 'O', 'linewidth', 4, 'displayname', 'non-funded' )
set(gcf,'position',[100,100,1000,600])
hold on
xlabel('year')
ylabel('the number of projects')
xlim([2008 2021])
ylim([-1e+4 7e+4])
title('\fontsize{12}polynomials with degree 1 to 7')
grid on

% make xplot for plotting
xplot = [8:0.05:22]'

% make plot for funded from degree 1 ~ 7 / with legend d = i , e = ? /
for i = [2:4]
    
    A = years.^[0:i] % A = vandermonde matrix
    
    b = funded
    c = nonfunded
   
    poly_coeff = A\b;
    poly_coeff_non = A\c;
    
    err_funded = norm(A*poly_coeff - b);
    err_notfunded = norm(A*poly_coeff_non - c);
    
    plot(xplot+2000, xplot.^[0:i]*poly_coeff, 'displayname', sprintf('funded,d=%d, e=%f', i, err_funded))
    hold on
    % year 2020 estimate
    est = 20.^[0:i]* poly_coeff
    plot(2020, est, 'kO', 'linewidth', 2, 'displayname', sprintf('funded est at 20 = %f', est))
    %plot(xplot+2000, xplot.^[0:i]*poly_coeff_non,'displayname', sprintf('nonfunded, d=%d, e=%f', i, err_notfunded))
    hold on

end
legend('location','NorthWest')




