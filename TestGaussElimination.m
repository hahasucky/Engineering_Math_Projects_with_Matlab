    % author :
    % Han Seokhee(2013130874)
    % Chung Hyelee(2017130776)
    % Hwang Jongho(2018320177)
% < Explantion for the script >
    % Test GaussElimination function, 
    % By comparing the its tic-toc exec. time with matlab build-in '\' function.

% basic clearing
close all; clear all; clc

% Assign exec. times for each array.
T_gauss = [];
T_backslash = [];
k = [5,10,100,500];
m = 1;

for i = k
    A = rand(i);
    b = rand(i,1);
    % save gauss eli. time in t1
    tic;
    GaussElimination(A,b);
    t1 = toc;
    % save matlab backlash time in t2
    tic
    A\b;
    t2 = toc;
    % save t1, t2 in T_gauss, T_matlab
    T_gauss(m) = t1;
    T_backslash(m) = t2;
    % add one for iteration
    m = m+1;
end

    % plot T_gauss and T_backslash according to size array k
plot(k, T_gauss, 'b');
hold on
plot(k, T_backslash, 'r');
ylabel('execution time')
legend('GaussElim.','Backslash');



%c).How much faster is the built-in Matlab function than your function for each time step?
%Why do you think it is faster?

% The '\' is, 'in average' about 30~70 times faster, though there were
% fluctuation for each time we exectuted the script, in the range of n size given in our test.
% The gap in computation speed grow larger as the row size of A increases.
% This gap comes from versatility of '\' backslash command in Matlab.
% Matlab '\' has versatile flowchart in getting solution for Ax = b 
% It asks which type of Matrix it is ex) full matrix? sparse? Hermitian? Upper Hassenberg?
% And It offers many types of solvers such as QR solver, LDL solver, LU solvoer, Cholsky solvers etc for different
% types of matrices in getting solution. 
% These versatile framework of choosing supposedly(by matlab developers)-the-most-efficient
% solvers, usually taking good advatages of 'symmetry', shortens the computation time.
% On the other hand, our GaussElimination uses the same structure of solver no matter which it computes.
