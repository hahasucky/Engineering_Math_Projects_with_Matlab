
function w = myPerceptron(x,y,maxIter,doShuffle,doPlot)

% init weights
w = zeros(size(x,2),1);

% check outputs
outputs = y.*(x*w)<=0; % find all the point for which the mentioned det below zero : mis classi data ; exist 1

iter=1;

% plot data and initial guess
xs=[min(x(:,2)):max(x(:,2))];
if (doPlot)
    indPos = y==1;
    indNeg = y==-1;
    scatter(x(indPos,2),x(indPos,3),'gx');
    hold on; scatter(x(indNeg,2),x(indNeg,3),'ro');
    % you should think where this comes from!
    ys=(-w(2)*xs-w(1))./w(3); % i get 3 weights =>  for the bias w1x1 + w2x2 + w0 => parameter tuning. / vandermonde also requires bias
    plot(xs,ys,'b-')
    xlim([xs(1) xs(end)]);
    ylim([min(x(:,3)) max(x(:,3))]);
    title(sprintf('%d: %d wrong\n',iter,length(find(outputs))))
    grid on;
    
end

% as long as there any misclassified points
% and we are within iteration limits, do:
while(any(outputs) & iter<=maxIter)
    % get all misclassified points
    ind = find(outputs);
    if (doPlot)
        ys=(-w(2)*xs-w(1))./w(3);
        plot(xs,ys,'b-')
        xlim([xs(1) xs(end)]);
        ylim([min(x(:,3)) max(x(:,3))]);
        title(sprintf('%d: %d wrong\n',iter,length(find(outputs))))
        waitforbuttonpress(); % user does the next updatae
    end
    % shuffle indices of points if desired
    if (doShuffle)
        ind = ind(randperm(length(ind)));
    end
    % update the weight with one misclassified point
    w = w + y(ind(1))*x(ind(1),:)';
    iter=iter+1;
    % and determine the new classification output
    outputs = y.*(x*w)<=0;
end

% plot the final solution
if (doPlot)
    ys=(-w(2)*xs-w(1))./w(3);
    plot(xs,ys,'r-')
    title(sprintf('%d: %d wrong\n',iter,length(find(outputs))));
    xlim([xs(1) xs(end)]);
    ylim([min(x(:,3)) max(x(:,3))]);
end