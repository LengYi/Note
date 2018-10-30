# 模拟器屏幕录制Gif

在开发中有的时候需要演示Demo，或者让产品确认开发效果。如果能够录制屏幕就比较方便了。

## 录制视频
+ 新建文件夹 moves
+ cd 到moves文件夹
+ 打开终端运行以下命令

~~~
   xcrun simctl io booted recordVideo 1.mov
~~~

+ 操作模拟器
+ 停止录制

~~~
    control + c
~~~    
+ 在moves文件夹下将生成一个 1.move的视频文件


## GIf格式转换
AppStore 下载GIF Brewery 3 导入文件然后输出，So Easy！！！


## 真机录屏 （iOS11以上）
+ 前往“设置”>“控制中心”>“自定控制”，然后轻点“屏幕录制”旁边的 绿色加号图标。
+ 从任意屏幕的底部向上轻扫。
+ 找到灰色圆圈按钮。
+ 轻点“开始录制”，然后等待三秒倒计时。 
+ 打开“控制中心”，然后轻点 红色录制图标。或者，轻点屏幕顶部的红色状态栏，然后轻点“停止”。
+ 前往“照片”应用并选择您的屏幕录制。