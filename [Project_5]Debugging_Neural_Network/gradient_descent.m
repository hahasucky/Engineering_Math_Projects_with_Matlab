% Function_Name : gradient_descent(.m)
% author :
    % Han Seokhee(2013130874)
    % Chung Hyelee(2017130776)
    % Hwang Jongho(2018320177)
% < Explantion for the script >
    % It applies gradients descents to compute its local minimum
    % with cumstom function, the partial derivatives of the function and learning rate.

function [xoptimal, foptimal, niterations, x, y, z] = gradient_descent(f, g1, g2, xstart, lambda, tolerance, maxiterations)
    % !!received additional argument x,y,z for convergence observation in surf plot.
    
    % set initial iteration number
    iter = 1;
    
    % observation-purpose arrays
    x = [];
    y = [];
    z = [];
    
    % set the starting point to xoptimal
    xoptimal = xstart; % x is a column vec.
    
    while iter <= maxiterations
        
        % 1). Calculate the gradient at current coordinate
        
        gradient = [g1(xoptimal(1),xoptimal(2)); g2(xoptimal(1),xoptimal(2))];
        
        
        % 2). Update xoptimal with gradient
        
        xoptimal = xoptimal - lambda.*gradient; 
        
        % <extra for the observation of converging trend>
        
        x(end+1) = xoptimal(1);
        y(end+1) = xoptimal(2);
        z(end+1) = f(xoptimal(1),xoptimal(2));
        
        % 3). check if gradient's L2 norm <= totlerance
        % +) if so, get out of while loop
        
        if norm(gradient,2) <= tolerance
            break
        end
        
        % 4). add iteration number for looping
        % +) if now iteration is already maxiter don't add.
        
        if iter == maxiterations
            break
        end
        
        iter = iter + 1 ;  
    end
    
    
    % calculate foptimal using xoptimal & save iter to niterations
    foptimal = f(xoptimal(1), xoptimal(2));
    niterations = iter;

end