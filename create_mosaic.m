% create_mosaic函数用于创建马赛克图片
% 输入参数：
% large_image：大图片，即需要被转换为马赛克的图片
% small_images：小图片的集合，用于创建马赛克
% colors：每张小图片的平均颜色
% hists：每张小图片的颜色直方图
% method：选择的方法，可以是'rgb'（比较颜色差异）、'ahash'（比较哈希值的差异）或'hist'（比较颜色直方图的差异）
% blocksize：大图片被划分的块的大小
% n：在找到颜色最接近的n张小图片后，再根据选择的方法找到最相似的一张小图片
% 输出参数：
% mosaic_image：生成的马赛克图片
function mosaic_image = create_mosaic(large_image, small_images, colors, hists, method, blocksize,n)
   
    % 初始化马赛克图片为大图片的大小，数据类型为uint8
    mosaic_image = zeros(size(large_image), 'uint8'); 

    % 遍历大图片的每一个块
    for i = 1:blocksize:size(large_image, 1)
        for j = 1:blocksize:size(large_image, 2)
            % 计算大图像块的平均颜色
            block_color = squeeze(mean(mean(large_image(i:i+blocksize-1, j:j+blocksize-1, :), 1), 2));
            % 计算大图像块的颜色直方图
            block_hist = imhist(rgb2gray(large_image(i:i+blocksize-1, j:j+blocksize-1, :)));
            % 找到颜色最接近的n张小图片
            color_diffs = sum(abs(colors - block_color'), 2);
            [~, sorted_indices] = sort(color_diffs);
            closest_n = sorted_indices(1:n);
            % 根据选择的方法找到最相似的一张小图片
            if strcmp(method, 'rgb')
                % 如果选择的方法是rgb，那么就比较颜色差异
                min_color_diff = inf;
                best_match = 0;
                for k = 1:n
                    img_color = squeeze(mean(mean(small_images{closest_n(k)}, 1), 2));
                    color_diff = sum(abs(double(img_color) - double(block_color)));
                    if color_diff < min_color_diff
                        min_color_diff = color_diff;
                        best_match = closest_n(k);
                    end
                end
            elseif strcmp(method, 'ahash')
                % 如果选择的方法是ahash，那么就比较哈希值的差异
                min_hash_diff = inf;
                best_match = 0;
                for k = 1:n
                    img_hash = ahash(small_images{closest_n(k)});
                    block_hash = ahash(large_image(i:i+blocksize-1, j:j+blocksize-1, :));
                    hash_diff = sum(block_hash ~= img_hash);
                    if hash_diff < min_hash_diff
                        min_hash_diff = hash_diff;
                        best_match = closest_n(k);
                    end
                end
            elseif strcmp(method, 'hist')
                % 如果选择的方法是hist，那么就比较颜色直方图的差异
                min_hist_diff = inf;
                best_match = 0;
                for k = 1:n
                    hist_diff = sum(abs(hists{closest_n(k)} - block_hist));
                    if hist_diff < min_hist_diff
                        min_hist_diff = hist_diff;
                        best_match = closest_n(k);
                    end
                end
            end
            % 将最相似的小图片放在马赛克图片的相应位置
            mosaic_image(i:i+blocksize-1, j:j+blocksize-1, :) = small_images{best_match};
        end
    end
end

% 计算图像的平均哈希值的函数
function hash = ahash(img)
    % 将图像缩放到8x8的大小
    img = imresize(img, [8 8]);
    % 如果图像是彩色的，将其转换为灰度
    if size(img, 3) == 3
        img = rgb2gray(img);
    end
    % 计算所有像素的平均值
    mean_val = mean(img(:));
    % 生成哈希值，如果像素值大于平均值，那么哈希值为1，否则为0
    hash = img > mean_val;
end