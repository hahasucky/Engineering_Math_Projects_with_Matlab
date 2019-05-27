
function [wrongPercTrain,wrongPercTest]=testPerceptronDigits(numReps,numIters)

% this prepares an imageDatastore for
% the digit dataset shipped with Matlab
digitDatasetPath = fullfile(matlabroot,'toolbox','nnet', ...
    'nndemos','nndatasets','DigitDataset');
imds = imageDatastore(digitDatasetPath, ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');
% the dataset originally has numbers 0-9,
% but we only want 0 and 1, so split
imds=imds.partition(5,1);

% check the labels of the data
imds.countEachLabel

% repeats the classification reps times
% store performance
wrongPercTrain=[];
wrongPercTest=[];
for rep = 1:numReps
    % split the data into a training and a test set
    [imdsTrain,imdsTest] = splitEachLabel(imds,0.95,'randomized');
    
    % read all images from train set into a cell array
    Xim = imdsTrain.readall;
    % show the pictures
    if rep==1
        montage(Xim)
    end
    % convert cell array into matrix [add bias term]
    X = zeros(length(Xim),numel(Xim{1})+1);
    % class labels
    y = zeros(length(Xim),1);
    for im = 1:length(X)
        % data with bias term
        X(im,:)=[Xim{im}(:) ;1];
        % first half is one class,
        % second half is the other
        if (im<=length(X)/2)
            y(im)=1;
        else
            y(im)=1;
        end
    end
    % train the perceptron
    w = myPerceptron(X,y,numIters,true,false);
    
    % find misclassified images and display (if any)
    wrong = find(y.*(X*w))<=0;
    wrongPercTrain(rep) = length(wrong)*100/size(X,1);
    fprintf('rep %d: misclassifying %d digits = %.3f percent\n',...
        rep,length(wrong),wrongPercTrain(rep));
    if ~isempty(wrong) & rep==1
        figure(101);
        montage(Xim(wrong))
    end
    
    % show weights
    if rep==1
        figure(102);
        imagesc(reshape(w(1:end-1),28,28))
    end
    
    % now convert the TEST set of unseen images
    Xim = imdsTest.readall;
    Xtest = zeros(length(Xim),numel(Xim{1})+1);
    ytest = zeros(length(Xim),1);
    for im = 1:length(Xim)
        Xtest(im,:)=[Xim{im}(:) ;1];
        if (im<=length(Xim)/2)
            ytest(im)=1;
        else
            ytest(im)=-1;
        end
    end
    
    % find misclassified images in TEST set
    % and display if any
    wrong = find(ytest.*(Xtest*w)<=0);
    wrongPercTest(rep)=length(wrong)*100/size(Xtest,1);
    fprintf('misclassifying %d test digits = %.3f percent\n',...
        length(wrong),wrongPercTest(rep));
    if ~isempty(wrong) & rep==1
        figure(103);
        montage(Xim(wrong))
    end
end

fprintf('\n\nTotal performance training = %.3f, testing = %.3f\n',mean(wrongPercTrain),mean(wrongPercTest));