% 1. downloaded 'five_classes_dataset.mat' file in your current directory &
% load

load('five_classes_dataset.mat','new_img_1','new_img_2','new_img_3','new_img_4','new_img_5','label');

current_path = pwd;

mkdir('cifar/1');
mkdir('cifar/2');
mkdir('cifar/3');
mkdir('cifar/4');
mkdir('cifar/5');

% 각각의 매트리스에서
% 한줄 한줄의 그레이 사진 어레이를 .jpeg로 각각에 저장.

for i = [1:size(new_img_1,1)]
    
    a_img_vec = new_img_1(i,:);
    a_img_mat = reshape(a_img_vec,[28,28]);
    
    imwrite(a_img_mat,sprintf([current_path,'/cifar/1/','%d.jpg'],i),'jpg');
    
end

for i = [1:size(new_img_2,1)]
    
    a_img_vec = new_img_2(i,:);
    a_img_mat = reshape(a_img_vec,[28,28]);
    
    imwrite(a_img_mat,sprintf([current_path,'/cifar/2/','%d.jpg'],i),'jpg');
    
end

for i = [1:size(new_img_3,1)]
    
    a_img_vec = new_img_3(i,:);
    a_img_mat = reshape(a_img_vec,[28,28]);
    
    imwrite(a_img_mat,sprintf([current_path,'/cifar/3/','%d.jpg'],i),'jpg');
    
end

for i = [1:size(new_img_4,1)]
    
    a_img_vec = new_img_4(i,:);
    a_img_mat = reshape(a_img_vec,[28,28]);
    
    imwrite(a_img_mat,sprintf([current_path,'/cifar/4/','%d.jpg'],i),'jpg')
    
end

for i = [1:size(new_img_5,1)]
    
    a_img_vec = new_img_5(i,:);
    a_img_mat = reshape(a_img_vec,[28,28]);
    
    imwrite(a_img_mat,sprintf([current_path,'/cifar/5/','%d.jpg'],i),'jpg')
    
end

%digitDatasetPath = fullfile(matlabroot,'toolbox','nnet','nndemos',...
 %   'nndatasets','DigitDataset');  
imds = imageDatastore(sprintf([current_path,'/cifar/']),...
    'IncludeSubfolders',true,'LabelSource','foldernames','FileExtensions','.jpg');

figure;
perm = randperm(5000,20);
for i = 1:20
    subplot(4,5,i);
    imshow(digitData.Files{perm(i)});
end

labelCount = countEachLabel(digitData);

img = readimage(digitData,1);
size(img)

numTrainFiles = 900;
[imdsTrain,imdsValidation] = splitEachLabel(imds,numTrainFiles,'randomize');


layers = [
    imageInputLayer([28 28 1])
    
    convolution2dLayer(3,8,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(5)
    softmaxLayer
    classificationLayer];



options = trainingOptions('sgdm', ...
    'InitialLearnRate',0.025, ...
    'MaxEpochs',12, ...
    'Shuffle','every-epoch', ...
    'ValidationData',imdsValidation, ...
    'ValidationFrequency',30, ...
    'Verbose',false, ...
    'Plots','training-progress');

net = trainNetwork(imdsTrain,layers,options);