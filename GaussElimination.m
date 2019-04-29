
function [x] = GaussElimination (A,b)
% author : 
    % Han Seokhee(2013130874)
    % Chung Hyelee(2017130776)
    % Hwang Jongho(2018320177)
% input : 
    % Square Matrix A, b(the same row size with A)
% Output : 
    % Solution x in 'A*x = b'


% 1. < Primary Error Handling >
% Square? , Input dim. = Ouput dim.
    [m,n] = size(A);
    [s,~] = size(b);
    if m ~= n
        error('put square matrix for A variable.');
    elseif m ~= s
        error('the row size of A and b should match.');
    end

% 2. < FORWARD ELIMINATION >
% 1). partial pivot(with 2nd_error_handling)
% 2). Eliminate forward.

    % Make the Augmented Matrix, call it 'AG_M'
    AG_M = [A,b];
    % Row By Row Iteration
    for i=[1:m-1] % m is the row size of the input matrix A        
        
    % 1).PARTIAL PIVOTING (include Err. Handling)
            % <1>. find maximum pivot's row
                %#1 pivot advocate
        pivot_advocate_array = AG_M(i:m, i);
                %Error Handling : all zero for leading coefficient**
        if sum(abs(pivot_advocate_array))==0
            error('error occured : There is no non-zero leading coefficient at %s th column', num2str(i));
        end
                %#2 Take absolute for pivot advocate
        pivot_advocate_array = abs(pivot_advocate_array);
                %#3 get the index of the max abs pivot value excluding (i-1)rows
        [~,index_of_max] = max(pivot_advocate_array);
                %#4 Assign the index_of_max + i + (-1) to the pivot
        index_of_max_pivot_row = index_of_max+i-1;
            % <2>. switch the now i-th row with the index_of_max_pivot_row    
        % iff, the row of max pivot isn't i th 
        if index_of_max_pivot_row ~= i
        % switch row i and the max row
            AG_M([i index_of_max_pivot_row],:)=AG_M([index_of_max_pivot_row i],:);
        end
        % Now, AG_M went through Partial Pivoting %


    % 2) Make Upper Triangle
            %#1) Pick up leading coefficient.
        standard_row = AG_M(i, :);
        leading_head = standard_row(i);
        
            %#2).do elimination
        for k = [i+1:m]
            target_row = AG_M(k, :);
            target_head = target_row(i);
            AG_M(k,:) = AG_M(k,:) - ((target_head/leading_head)*standard_row);
        end
    % Row By Row ended
    end
    % Upper Triangle is formed and is saved at variable 'AG_M'
    
% 3. < BACKWARD SUBSTITUTION >
% Divide AG_M => A,b
b = AG_M(:,m+1);
A = AG_M(:,1:m);

% Backward Sub.
% * make solution array x
x=zeros(1,m);
x(1,m)=b(m)/A(m,m);
for e=m-1:-1:1
        x_m =(b(e)-sum(A(e,e+1:end).*x(e+1:end))).*1/A(e,e);
        x(e)=x_m;
end
x=x';
%END. < Function_GaussElimination ended >
end


%b). Which part of the code (forward elimination or backward substitution) takes longest to run? 
%answer : Forward elimination
% tic toc showed that foward elimination takes significantly longer time than Backward substitution.
% 
% In the light of structural difference, foward elimination requires for-loop for each row executing :
% 1). partial pivoting
% 2). forward elimination(as the nested for_loop for the above for-loop)
%
% If we call the number of rows of A to be 'n', 
% it takes exec. time that is in proportion to (O(n^2)),
% Whereas the < Backward Substitution > only involves row by row substitution computing from backward,
% taking execution time in proportion to (O(n)).
