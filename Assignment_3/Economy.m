    % author :
    % Han Seokhee(2013130874)
    % Chung Hyelee(2017130776)
    % Hwang Jongho(2018320177)
% < Explantion for the script >
    % Calculates X(total_value) using fomula X = MX + b
% b <- final demand, MX <- internal(intermediate) demand.

% Basic clearing
close all; clear all; clc

b = [10; 15; 20];     % a final demand of steel, energy, cars
M = [.1 .65 .05; .04 .2 .1; .6 .2 .05];     % internal demands
A = (eye(size(M,1)) - M);     % b = A*X
X = GaussElimination(A, b);     % total output
X   %or disp(X)

% 1) Why do the numbers in M not add up to US $1?
% Here it is given that, for a production of one dollor of Steel,
% as intermediate goods,
% 0.1 dollor-worth of steel, 0.65 dollor-worth of energy, and 0.05 dollor-worth of car
% are required to produce it.
% Inputs of other sectors as internal goods for a production of a dollor of a sector
% don't necessarily add up to one, and practically the add-value of
% production costs for a production of one unit of sector is ,rather, smaller the better.



% 2) Does the solution X add up to the sum of the final demand? If not, why not?
% No. 
% X does not add up to sum of final demand
% because as we can see in the given fomula for X = MX + b ( b : final
% demand ) Total Output(or Total production) is composed of 
% 1).internal demand, which means how much S,E,C is
% needed in the process of production of the final demand(b)
% 2). And the final demand.
% Thus, total_output(X) which is = intermediate(internal)_demand(MX) + final_demand(b)
% cannot add up to b.



