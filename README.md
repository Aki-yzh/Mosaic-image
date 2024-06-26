# Mosaic-image
数字图像处理的课程设计，千图成像/生成马赛克图片

## 运行指南

### 项目构成

- `main.m`：这是主要的脚本文件，包含了读取和处理图片，以及创建马赛克图片的代码。
- `create_mosaic.m`：这是一个自定义函数，用于创建马赛克图片。它的输入参数包括大图片、小图片的集合、每张小图片的平均颜色、每张小图片的颜色直方图、选择的方法、大图片被划分的块的大小和在找到颜色最接近的n张小图片后，再根据选择的方法找到最相似的一张小图片。输出参数是生成的马赛克图片。
- `images/`：这是存放小图片的文件夹，所有的小图片都应该是.jpg格式。
- `targetX.jpg`：这是需要转换为马赛克的大图片,编号可在main1中选择
- `mosaic_image.jpg`：这是生成的马赛克图片，如果你取消 `imwrite(mosaic_image, 'mosaic_image.jpg');`这行代码的注释，马赛克图片就会被保存为这个文件。
- `课程设计报告.docx`：课程设计报告，因为含有gif动图不好转为pdf文件故为docx文件
- `展示报告.pptx`：课程展示报告
- 
### 可供修改参数

- `image_folder`：存放小图片的文件夹路径，例如 'images/'。
- `blocksize`：小图片的放缩后大小，例如 50。
- `large_image`：需要转换为马赛克的大图片。
- `t`：大图片的需要分解为一行多少个小图片，例如150。
- `n`：找到颜色最接近的n张小图片
- `method`：选择的方法，可以是'rgb'（比较颜色差异）、'ahash'（比较哈希值的差异）或'hist'（比较颜色直方图的差异）。

### 运行方法

设置好相关参数后直接运行main1即可。
如需保存相关图片，把imwrite前的%去掉即可
