% Script Name : processData(.m)
    % author :
    % Han Seokhee(2013130874)
    % Chung Hyelee(2017130776)
    % Hwang Jongho(2018320177)
% < Explantion for the script >
    % Load data, fix them and show valid information into plots


clear all;       % clears the workspace
close all;       % closes figures
clc;             % clears the command window

% Load data from dataForTesting.mat and store it
load('dataForTesting.mat');

% Problem detecting and fixing 'data' and puts in 'fdata'
fdata = fixData(data);

% Figure for exploratory scatter plot
figure(3);
set(3, 'position', [50 0 1000 1000]);



for i = 1:13 % Column 1~13
   
    % logical Matrix that shows valid data to show in plot
    % if 'i'th or 14th value is NotANum, validData's element = logical 0
    % else logical 1
    validData = ~(isnan(fdata(:,i))+isnan(fdata(:,14)));
   
      
    % sets three colors red, else default
    if (i== 6 || i==8 || i==13)
        color = 'r';
    else
        color = 'd';
    end
   
    % plots 3x5 scatters of fdata's valid pairs
    subplot(3, 5, i);
  
    scatter(fdata(validData,i), fdata(validData,14), color);
    
    % [ Why did we choose these 3 numbers ] :
    % First of all, 13th column shows the clearest negative correlation to 14th column,
    % showing decent inclination. Also, the data points are most densely
    % and consistently formed around the trend line(if we draw one). That's why
    % We chose this candidate column despite its relatively small value
    % inclination. The Points far from line barely exists. Therefore we propose that
    % 13th column data is the most explanatory power determining 14th
    % column, as we think this could be the most 'responsible' one.
    %
    % Secondly, We concluded that the 8th column has the second most explanatory power.
    % It has positive correlation with 14th column. 
    % Though there are many points that are scattered far away from the 
    % trend line, the line has relatively higher slope than other columns
    % do. Also, data points in the left-hand part of the graph are quite
    % dense.
    %
    % Lastly, the 6th column datas shows relatively consistent positive correlation with
    % 14th elements and has similar variance or density around a trendline
    % to that of 1st column's correlation with 14th elemnet. However, it has
    % higher value of inclination though it is lower than 8th, which means the value of 14th element is more
    % strongly influenced by change in 6th column value than 1st column
    % value. 
    
end


