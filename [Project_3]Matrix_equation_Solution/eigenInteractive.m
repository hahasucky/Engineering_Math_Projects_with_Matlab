% Function Name : eigenInteractive(.m)
    % author :
    % Han Seokhee(2013130874)
    % Chung Hyelee(2017130776)
    % Hwang Jongho(2018320177)
% < Explantion for the function >
    % 1). Create three draggable points in an interactive plot
    %     (a vector v and two column vectors of a 2-by-2 matrix A)
    % 2). Show the corresponding eigenvectors and eigenvalues
    %     if they are real
    % inspired by
    % https://stackoverflow.com/questions/9646146/how-to-make-a-matlab-plot-interactive/9650495
    
function eigenInteractive(Pos)

% call the function WITHOUT any input argument
% to setup the figure and the environment

if nargin == 0
    
    % clean up
    close all;
    clear all;
    clc;

    % create a figure
    figure(1);
    axis([-10 10 -10 10]);
    hold on;

    % global variables that hold the three impoint handles
    global a1 a2 v
    
    % create first points
    a1 = impoint(gca,1,2);   % first column vector of A
    setString(a1,'a_1');
    a2 = impoint(gca,2,.5);  % second column vector of A
    setString(a2,'a_2');
    v = impoint(gca,2,3);
    setString(v, 'v');
    
    % Call subfunction
    drawInfo(a1,a2,v)

    % Add callback to each point
    addNewPositionCallback(a1,@eigenInteractive);
    addNewPositionCallback(a2,@eigenInteractive);
    addNewPositionCallback(v,@eigenInteractive);
    
    disp('setup done')
else

    % If we get an input argument, its the position
    % from the callback, so we know that the user
    % dragged a point.
    
    % access the plot and impoint handles
    global H1 H2 H3 H4 H5 H6 H7 H8 H9 H10 H11 H12 H13 H14 H15 a1 a2 v

    
    % remove old arrows
    delete(H1)
    delete(H2)
    delete(H3)
    delete(H4)
    delete(H5)
    delete(H6)
    delete(H7)
    delete(H8)
    delete(H9)
    delete(H10)
    delete(H11)
    delete(H12)
    delete(H13)
    delete(H14)
    delete(H15)
    % draw new arrows
    drawInfo(a1,a2,v)
    
end
end

function drawInfo(a1,a2,v)

P = zeros(2,2);     % P is the matrix A

% get X and Y coordinates for the draggable points.
P(:,1) = getPosition(a1);
P(:,2) = getPosition(a2);
V = getPosition(v);

Av = P*V';

% find eigenvectors and eigenvalues of the matrix A
[vec, val] = eig(P);
e1 = vec(:, 1);     % first eigenvector
e2 = vec(:, 2);     % second eigenvector

% plot arrows and text
global H1 H2 H3 H4 H5 H6 H7 H8 H9 H10 H11 H12 H13 H14 H15
H1 = plot([0 P(1,1)], [0 P(2,1)], 'b');
H2 = plot([0 P(1,2)], [0 P(2,2)], 'g');
H3 = text(3,7,sprintf('A = $\\left [\\begin{array}{cc} a_1 & a_2\\end{array}\\right ]$ = $\\left [\\begin{array}{cc} %.02f & %.02f\\\\%.02f & %.02f\\end{array}\\right ]$',P(1,1),P(1,2),P(2,1),P(2,2)),'Interpreter','Latex'); 
H4 = text(5,5,sprintf('v = $\\left [\\begin{array}{cc} %.02f \\\\%.02f \\end{array}\\right ]$',V(1),V(2)),'Interpreter','Latex'); 
H5 = plot([V(1) Av(1)], [V(2) Av(2)], 'k');
H6 = plot(Av(1), Av(2), 'ro');
H7 = text(5,3,sprintf('Av = $\\left [\\begin{array}{cc} %.02f \\\\%.02f \\end{array}\\right ]$',Av(1),Av(2)),'Interpreter','Latex'); 
H8 = text(Av(1), Av(2), 'Av');
if isreal(vec) && isreal(val)
    H9 = plot([0 e1(1)], [0 e1(2)], 'k');
    H10 = plot([0 e2(1)], [0 e2(2)], 'k'); 
    H11 = text(e1(1), e1(2), 'e1');
    H12 = text(e2(1), e2(2), 'e2');
    H13 = text(5,1,sprintf('e1 = $\\left [\\begin{array}{cc} %.02f \\\\%.02f \\end{array}\\right ]$',e1(1),e1(2)),'Interpreter','Latex'); 
    H14 = text(5,-1,sprintf('e2 = $\\left [\\begin{array}{cc} %.02f \\\\%.02f \\end{array}\\right ]$',e2(1),e2(2)),'Interpreter','Latex'); 
    H15 = text(-7,7,sprintf('Eigenvalues are %.02f and %.02f ',val(1,1),val(2,2)),'Interpreter','Latex'); 
    
    % reverse the order of the elements to keep
    % the impoints on top
    t=get(gca,'Children');
    set(gca,'Children',[t(18) t(17) t(16) t(15) t(14) t(13) t(12) t(11) t(10) t(9) t(8) t(7) t(6) t(5) t(4) t(3) t(2) t(1)]);
    
else
    H15 = text(-7,7,'Eigenvalues or eigenvectors are not real'); 
    
    % reverse the order of the elements to keep
    % the impoints on top
    t=get(gca,'Children');
    set(gca,'Children',[t(12) t(11) t(10) t(9) t(8) t(7) t(6) t(5) t(4) t(3) t(2) t(1)]);
end
end
