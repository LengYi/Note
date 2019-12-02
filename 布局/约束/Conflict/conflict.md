# 约束冲突解决

## 一、添加UIViewAlertForUnsatisfiableConstraints断点

+ 添加**Symbolic Breakpoints**

![1](/Users/ice/Desktop/1.png)

+ 编辑断点symbol填入

  ```swift
  UIViewAlertForUnsatisfiableConstraints
  ```

+ 添加控制台打印action

  ```swift
  po [[UIWindow keyWindow] _autolayoutTrace]
  ```

  ![2](/Users/ice/Desktop/work/Github/Note/布局/约束/Conflict/Image/2.png)



## 二、定位约束警告冲突

+ 添加好断点之后，当界面有约束冲突，就会触发断点，控制打印如下：

```swift
[LayoutConstraints] Unable to simultaneously satisfy constraints.
    Probably at least one of the constraints in the following list is one you don't want. 
    Try this: 
        (1) look at each constraint and try to figure out which you don't expect; 
        (2) find the code that added the unwanted constraint or constraints and fix it. 
(
    <MASLayoutConstraint:0x604000ab04a0 UIButton:0x7faf99f04010.width == 40>,
    <MASLayoutConstraint:0x604000ab66e0 UIButton:0x7faf99f04010.left == CYBButtonView:0x7faf99f83360.left + 10>,
    <MASLayoutConstraint:0x604000abaa00 UILabel:0x7faf99f5f8e0.left == UIButton:0x7faf99f04010.right>,
    <MASLayoutConstraint:0x604000abd580 UILabel:0x7faf99f5f8e0.left == CYBButtonView:0x7faf99f83360.left + 15>,
)

Will attempt to recover by breaking constraint 
<MASLayoutConstraint:0x604000ab04a0 UIButton:0x7faf99f04010.width == 40>

Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.
The methods in the UIConstraintBasedLayoutDebugging category on UIView listed in <UIKit/UIView.h> may also be helpful.
```

+ 根据提示，找到约束有问题的控件地址**0x7faf99f04010**，然后全局搜索，就能找到具体是哪个控件

+ 如果控制台打印不够直观看出是哪个控件约束有问题，我们可以通过 LLDB命令工具[chisel](https://github.com/facebook/chisel)定位寻找。

  

## 三、解决冲突

```swift
删除多余约束
修改约束优先级
```



## LLDB调试

```swift
(
    "<NSAutoresizingMaskLayoutConstraint:0x170a93740 EAFSMultipleSpecPopupView:0x11e00adf0.width == 414>",
    "<NSLayoutConstraint:0x174a9eaa0 EAFSNormalDetailButton:0x1119de4c0.leading == UIView:0x11337d9c0.leading>",
    "<NSLayoutConstraint:0x17449cbb0 UIView:0x11337d9c0.trailing == EAFSNormalDetailButton:0x1119de4c0.trailing + 394>",
    "<NSLayoutConstraint:0x174a9df60 EAFSMultipleSpecPopupView:0x11e00adf0.trailing == UIView:0x11337d9c0.trailing + 20>",
    "<NSLayoutConstraint:0x174c890b0 UIView:0x11337d9c0.leading == EAFSMultipleSpecPopupView:0x11e00adf0.leading + 20>"
)

Will attempt to recover by breaking constraint 
<NSLayoutConstraint:0x17449cbb0 UIView:0x11337d9c0.trailing == EAFSNormalDetailButton:0x1119de4c0.trailing + 394>


(lldb) po (UIView *)0x11337d9c0
<UIView: 0x11337d9c0; frame = (20 472; 335 45); clipsToBounds = YES; autoresize = RM+BM; layer = <CALayer: 0x174c202c0>>

(lldb) po (UIView *)0x11337d9c0
<UIView: 0x11337d9c0; frame = (20 472; 335 45); clipsToBounds = YES; autoresize = RM+BM; layer = <CALayer: 0x174c202c0>>

(lldb) po [(UIView *)0x11337d9c0 subviews]
<__NSArrayM 0x175a5b480>(
<EAFSNormalDetailButton: 0x1119de4c0; baseClass = UIButton; frame = (0 0; 168 45); hidden = YES; opaque = NO; autoresize = RM+BM; layer = <CALayer: 0x174c2eee0>>,
<EAFSNormalDetailButton: 0x113304fa0; baseClass = UIButton; frame = (168 0; 167 45); opaque = NO; autoresize = RM+BM; layer = <CALayer: 0x174c2c720>>
)

```



定位有冲突的视图

 ```swift
// 该行说明了有约束冲突的视图
Will attempt to recover by breaking constraint 
<NSLayoutConstraint:0x17449cbb0 UIView:0x11337d9c0.trailing == EAFSNormalDetailButton:0x1119de4c0.trailing + 394>
// 使用以下代码在界面上查看约束冲突的具体视图
expression ((UIView *)0x11337d9c0).backgroundColor = [UIColor redColor]
 ```

