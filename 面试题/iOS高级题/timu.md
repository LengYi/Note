### 1. +load的使用
  + +load方法是系统自动调用的，系统自动为每一个类自动调用+load方法
  + +load方法是在所有类被加到runtime以后调用的
  + +load方法按照父类到子类的顺序加载
  +  +load方法先按照父类到子类的顺序加载，之后[Category load]按照CompileSources排列顺序调用
  + 在+load中一定要做唯一性判断，在里面使用方法交换，子类中意外调用了[SuperClass load]将会导致交换失败，方法交换了两次，就等于没有交换

  ~~~
  + (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
            doSomething
    });
}
  ~~~
  
### 2. +initialize的使用
 
 + 在类第一次接收到消息之前被系统自动调用无需手动调用
 + 在调用子类的+initialize方法之前，会先调用父类的+initialize方法
 + 如果父类实现了+initialize方法，但是子类没有，子类会自动继承父类的+initialize，父类的+initialize方法会被自动调用两次
 + Category中的+initialize方法会覆盖类中的+initialize，同一个类中多个Category都实现了+initialize方法时，按CompileSources列表中最后一个Category的+initialize方法覆盖其它的+initialize方法

### [解析和重写NSObject 的isEqual和hash方法](https://www.jianshu.com/p/502c5da1f170)

### [深入理解通知](https://www.jianshu.com/p/83770200d476)
[关于NSNotification你可能不知道的东西](https://www.jianshu.com/p/2901ec15bdea)


### 3. NSAutoreleasePool
+ 自动释放池，ARC下系统自动创建，ARC下使用@autorelease{}
+ 是个栈
+ 原理: 把对release的调用延迟了，对于每一个Autorelease，系统只是把该Object放入了当 前的Autorelease pool中，当该pool被释放时，该pool中的所有Object会被调用Release。
+ 手动释放或者Runloop结束之后自动释放。
+ 不要把大量循环操作放到同一个NSAutoreleasePool之间,这样会造成内存峰值的上升。
+ 创建新线程时使用NSAutoreleasePool
+ 循环创建大量临时对象时使用NSAutoreleasePool
+ 程序不基于UIFramework

### 4. 深入理解RunLoop
[链接](https://blog.ibireme.com/2015/05/18/runloop/)

### 5. LoadView
[链接](https://www.jianshu.com/p/87f66304cdec)

### 6. 深拷贝浅拷贝
[链接](https://www.jianshu.com/p/2a647981b2b9)

一个不可变String a 赋值给 @property (nonatomic, copy) NSString *name;  生成的name是不可变对象

### 7. ARC
[链接](https://www.jianshu.com/p/89ae34fc2ab4)

### 8. delegate使用assign和weak修饰有什么区别
+ 防止循环引用导致内存泄漏
+ 因为assign是单纯的拷贝所赋值变量的值，即进行简单的赋值操作，delegate不持有B，只是保留了B对象的指针的值，不会使引用计数加1。但是如果当B被销毁的时候，引用计数变成0但并不意味着被销毁，delegate不会跟着销毁，仍保存着之前对象的值，就成了野指针，造成内存泄露。当再向delegate发消息的时候，就会crash
+ 用week解决了这个问题，当B对象被销毁的时候，week修饰的delegate也会自动置为nil（销毁），这时再向nil发送消息，不会crash，OC可以向nil对象发送消息

### 用@property声明的NSString（或NSArray，NSDictionary）经常使用copy关键字，为什么？如果改用strong关键字，可能造成什么问题？
+ 因为父类指针可以指向子类对象,使用 copy 的目的是为了让本对象的属性不受外界影响,使用 copy 无论给我传入是一个可变对象还是不可对象,我本身持有的就是一个不可变的副本.
+ 如果我们使用是 strong ,那么这个属性就有可能指向一个可变对象,如果这个可变对象在外部被修改了,那么会影响该属性.
+ copy 此特质所表达的所属关系与 strong 类似。然而设置方法并不保留新值，而是将其“拷贝” (copy)。 当属性类型为 NSString 时，经常用此特质来保护其封装性，因为传递给设置方法的新值有可能指向一个 NSMutableString 类的实例。这个类是 NSString 的子类，表示一种可修改其值的字符串，此时若是不拷贝字符串，那么设置完属性之后，字符串的值就可能会在对象不知情的情况下遭人更改。所以，这时就要拷贝一份“不可变” (immutable)的字符串，确保对象中的字符串值不会无意间变动。只要实现属性所用的对象是“可变的” (mutable)，就应该在设置新属性值时拷贝一份。

### NSObject 协议

[链接](https://www.jianshu.com/p/008d5029b02a)