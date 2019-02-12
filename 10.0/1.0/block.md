# Block的使用
## 声明定义
+ 不带参数

~~~
void (^SayHello)(void) = ^{
        NSLog(@"9999999");
    };
    SayHello();
~~~
输出结果：9999999

+ 带参数

~~~
   void (^test)(NSString*,NSString*) = ^(NSString * a, NSString *b) {
        NSLog(@"%@%@",a,b);
    };
    test(@"a",@"n");
~~~
输出结果：an

+ 定义block类型

~~~
typedef void (^ClickBlock)(NSString *);
@property (nonatomic, copy) ClickBlock block;
~~~

## 使用场景
+ block 作为类属性
+ block 作为方法参数
+ block 代替代理

## 作用
+ 回调传值
+ 对象之间能通信交互
+ 改变或传递控制链，减少框架复制度

## 循环引用
+ MRC 
+ ARC

~~~
    __weak typeof(self) weakSelf = self;
~~~

## 优缺点
+ 优点
	1. 简洁
	2. 轻量，能够之间访问上下文，连贯易读
+ 缺点
   1. 不够安全容易造成循环引用，不好排查
   2. 通信事件多时不够直观，不易维护
