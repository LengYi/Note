###通知中心(NotificationCenter)的使用
1.添加通知

```
/// 通知名
     let notificationName = "XMNotification"
     /// 自定义通知
     NotificationCenter.default.addObserver(self, selector: #selector(notificationAction), name: NSNotification.Name(rawValue: notificationName), object: nil)
```

2.设置监听方法

```
/// 接受到通知后的方法回调
    @objc private func notificationAction(noti: Notification) {
        /// 获取键盘的位置/高度/时间间隔...
        print(noti)
    }
```

3、在通知用完后及时销毁

```
/// 析构函数.类似于OC的 dealloc
    deinit {
        /// 移除通知
        NotificationCenter.default.removeObserver(self)
    }
```

4、发送通知

```
/// 发送简单数据
    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "XMNotification"), object: "Hello 2017")

    /// 发送额外数据
    let info = ["name":"Eric","age":21] as [String : Any]
    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "XMNotification"), object: "GoodBye 2016", userInfo: info)
```

5.监听键盘的变动

```
 /// 通知中心监听键盘的变化
 #selector(notificationAction), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)

```

6.键盘的其他通知名称

```
   public static let UIKeyboardWillShow: NSNotification.Name
     /// 键盘显示完毕
     public static let UIKeyboardDidShow: NSNotification.Name
     /// 键盘将要隐藏
     public static let UIKeyboardWillHide: NSNotification.Name
     /// 键盘隐藏完毕
     public static let UIKeyboardDidHide: NSNotification.Name
     /// 键盘将要改变自身的frame
     public static let UIKeyboardWillChangeFrame: NSNotification.Name
     /// 键盘frame改变完成
     public static let UIKeyboardDidChangeFrame: NSNotification.Name

```




