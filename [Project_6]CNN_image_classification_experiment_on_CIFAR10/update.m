new_img_1 = [];
for i = [1:1000]
    a_image = image_edit(filtered_image_1(i,:));
    new_img_1 = [new_img_1; a_image];
end

new_img_2 = [];
for i = [1:1000]
    a_image = image_edit(filtered_image_2(i,:));
    new_img_2 = [new_img_2; a_image];
end

new_img_3 = [];
for i = [1:1000]
    a_image = image_edit(filtered_image_3(i,:));
    new_img_3 = [new_img_3; a_image];
end

new_img_4 = [];
for i = [1:1000]
    a_image = image_edit(filtered_image_4(i,:));
    new_img_4 = [new_img_4; a_image];
end

new_img_5 = [];
for i = [1:1000]
    a_image = image_edit(filtered_image_5(i,:));
    new_img_5 = [new_img_5; a_image];
end

label = {'airplane';'automobile';'bird';'cat';'deer'};

save('five_classes_dataset_2', 'label','new_img_1','new_img_2','new_img_3','new_img_4','new_img_5');


