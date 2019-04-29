
function [fixed] = fixData(original)
% Function_name : fixData
% Author        : 2013130874 Han Seok Hee
%               : 2018320177 Hwang Jongho
%               : 2017130776 CHUNG Hyelee
% input  : Matrix with an element more or less than 0 ( size 206 by 14 )
% output : Matrix in which the row including false data is replaced to NaN
% What the function does : Presumed condition is that every element should be bigger or equal to 0.
%                    It cleans the data to fulfill the presumed condition. 
%                    Statistical range should be decided, outliers should be
%                    checked and deleted.
    

% copys data
fixed = original;

% sets upper boundaries for values that affect means
% (as in the data's negative value -1.0*e+09)
upperbound = 100000; % should be checked and modified in other datas

fixed(~isfinite(fixed)) = NaN;  % if not finite value, puts NaN instead
fixed(fixed < 0) = NaN;         % if not finite value, puts NaN instead
fixed(fixed > upperbound) = NaN;    % if outranged, puts NaN instead

% logical 206x14 matrix inlier
% finds if a single data is valid due to others. if yes: logical 1. no: 0
isinlier = ((abs(fixed-nanmean(fixed)) <= 2*nanstd(fixed)));

% outliers are replaced to NaN
fixed(isinlier == 0) = NaN;
% THIS LINE COULD BE DELETED IF WE CAN TRUST ALL VALUES IN DATA
% For example, if the data is counted or mathematically correct, we should
% put them in the plot, but in this case we do not know where the values
% come from so it could (and probably) have minor errors.

% [ Why did we fix it that way ] :
%  [replace erroneous element <less than zero> with NaN]
%   That particular (a,b)th element might have been measured wrong,
%   probably because of bad measurment tool being broken or a mistake of a staff, 
%   but still the other elements of that row at the other columns still can be valid. 
%  [replace erroneous element outranged, with NaN]
%   Also statistically outranged values are eliminated because they are
%   probably invalid datas, strange to others. And these could affect the
%   means calculating outliers.
%   * However, We strongly agree this is far-fetched for this problem set's
%   requirement. We devised it just for our future data programming
%   experience, in which extremely big values should be excluded in often
%   case.

%  [replace outliers with NaN *]
%   We replaced outliers with NaN under the presumption that this is higly likely to
%   be data from some scientific experiment. The experiment is highly erroneous and 
%   2 sigma will be able to exclude all those possible anomalies.
%   * However, We also firmly agree that these maybe the type of data that could be
%   relatively precisely measured like height, money etc.
%   In those case we agree that we won't let our datas go through this
%   outlier filering procedure as data could well represent the reality and any loss of
%   such datas could get us far from analyzing the correlation properly.


end

