# Xcode断点调试

## 一、全局断点

![2](/Users/ice/Desktop/work/Github/Note/Xcode/调试/Image/2.png)

+ **选择Add Exception Breakpoint 添加全局断点**

## 二、符号断点

+ 首先进入到断点设置

  ![1](/Users/ice/Desktop/work/Github/Note/Xcode/调试/Image/1.png)

+ 然后点击+选择Add Symbolic Breakpoint

![2](/Users/ice/Desktop/work/Github/Note/Xcode/调试/Image/2.png)

+ 在弹出的视图中输入-[NSException raise]

![3](/Users/ice/Desktop/work/Github/Note/Xcode/调试/Image/3.png)

+ 然后敲回车，点击空白处就行了

+ 然后再次重复上一步Add Symbolic Breakpoint

![4](/Users/ice/Desktop/work/Github/Note/Xcode/调试/Image/4.png)



+ 在弹出的视图中输入objc_exception_throw

+ 然后敲回车，点击空白处。

+ 以上步骤就完成了全局断点的设置。