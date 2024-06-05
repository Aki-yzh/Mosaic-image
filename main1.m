clc
clear
tic

%% 读取并处理小图片
image_folder = 'images/'; % 小图片的文件夹
image_files = dir(fullfile(image_folder, '*.jpg')); % 获取所有.jpg文件
num_images = length(image_files); % 获取图片数量
small_images = cell(1, num_images); % 初始化小图片的cell数组
colors = zeros(num_images, 3); % 初始化颜色数组
hists = cell(1, num_images); % 初始化直方图数组
blocksize = 25; % 小图像的大小

for i = 1:num_images
    img = imread(fullfile(image_folder, image_files(i).name)); % 读取图片
    if size(img, 3) == 1 % 如果是灰度图像
        img = repmat(img, [1 1 3]); % 复制到三个颜色通道
    end
    small_images{i} = imresize(img, [blocksize blocksize]); % 调整图片大小
    colors(i, :) = squeeze(mean(mean(small_images{i}, 1), 2)); % 计算每个小图片的平均颜色
    hists{i} = imhist(rgb2gray(small_images{i})); % 计算每个小图片的颜色直方图
end

%% 读取并处理大图片
large_image = imread('target1.jpg'); % 读取大图片
t= 150;
t=t*blocksize;
large_image = imresize(large_image, [t t]); % 调整大图片大小

%% 创建马赛克图片
n = 8; % 定义要找到的颜色最接近的小图片的数量
method = 'ahash'; % 选择匹配方法
mosaic_image = create_mosaic(large_image, small_images, colors, hists, method, blocksize,n);

% 显示马赛克图片
figure()
imshow(mosaic_image);
%imwrite(mosaic_image, 'mosaic_image.jpg');
toc

