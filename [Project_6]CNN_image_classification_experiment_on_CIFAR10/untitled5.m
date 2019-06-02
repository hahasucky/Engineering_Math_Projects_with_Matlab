% basic clearing
clear;
clc;
clear all;

% repository를 만든다.
filtered_image_1 = [];
filtered_image_2 = [];
filtered_image_3 = [];
filtered_image_4 = [];
filtered_image_5 = [];

% .mat를 로드한다. 파일 하나마다 이터레이트 한다.
for i = [1:5]
    now_struct = load(sprintf('data_batch_%d.mat',i),'data','labels');
    
    % 해당 파일의 10000개의 이미지를 now_data, 10000개의 라벨을 now_label에 저장
    now_data = now_struct.data;
    now_label = now_struct.labels + 1; % (label 1~10)
    
    % label이 n이면, 필터드 이미지에 해당로우 추가
    filter_logic_array = ismember(now_label, [1,2,3,4,5]);
    filter_label = now_label(filter_logic_array);
    filtered_image = []; % 5072개 이미지만 추리기
    
    for j=[1:10000]
        if filter_logic_array(j) == 1
            the_image = now_data(j,:);
            filtered_image = [filtered_image; the_image];
        end
    end
    
    % [ filter_label, filtered_image => [1,2,3,4,5]만 추려짐 ]
    % 필터 라벨에서 1에 해당하는 이미지만 추려서 filtered_image_1에 row column으로 넣기 
    
    class_one_logic = filter_label == 1;
    for k = [1:length(filter_label)]
        if class_one_logic(k) == 1;
            filtered_image_1 = [filtered_image_1; filtered_image(k,:)];
        end
    end
    
 
    
    class_one_logic = filter_label == 2;
    for k = [1:length(filter_label)]
        if class_one_logic(k) == 1
            filtered_image_2 = [filtered_image_2; filtered_image(k,:)];
        end
    end
    
    
    
    class_one_logic = filter_label == 3;
    for k = [1:length(filter_label)]
        if class_one_logic(k) == 1
            filtered_image_3 = [filtered_image_3; filtered_image(k,:)];
        end
    end
    
   
    
    class_one_logic = filter_label == 4;
    for k = [1:length(filter_label)]
        if class_one_logic(k) == 1
            filtered_image_4 = [filtered_image_4; filtered_image(k,:)];
        end
    end
    

    
    class_one_logic = filter_label == 5;
    for k = [1:length(filter_label)]
        if class_one_logic(k) == 1
            filtered_image_5 = [filtered_image_5; filtered_image(k,:)];
        end
    end
    
   
   
end


filtered_image_1 = filtered_image_1(1:1000,:);
filtered_image_2 = filtered_image_2(1:1000,:);
filtered_image_3 = filtered_image_3(1:1000,:);
filtered_image_4 = filtered_image_4(1:1000,:);
filtered_image_5 = filtered_image_5(1:1000,:);









        