# iOS多继承实现方案
+ 通过组合实现多继承
+ 通过协议实现多继承
+ 通过category

### 通过组合实现多继承

~~~
//定义ClassA以及其methodA
@interface ClassA : NSObject {
}
-(void)methodA;
@end

//定义ClassB以及其methodB
@interface ClassB : NSObject {
}
-(void)methodB;
@end

//定义ClassC以及其需要的methodA，methodB
@interface ClassC : NSObject {
ClassA *a;
ClassB *b;
}
-(id)init;
-(void)methodA;
-(void)methodB;
@end

//注意在ClassC的实现
@implementation  ClassC
-(id)init{
a=[[ClassA alloc] init];
b=[[ClassB alloc] init];
}

-(void)methodA{
[a methodA];
}

-(void)methodB{
[b methodB];
}
~~~

### 通过协议实现多继承

~~~
1、定义ClassA 以及 ClassAProtocol
@interface ClassA : NSObject
@end

@protocol ClassAProtocol <NSObject>
-(void)a;
@end
 
2、定义ClassB 以及 ClassBProtocol
@interface ClassB : NSObject
@end

@protocol ClassBProtocol <NSObject>
-(void)b;
@end

3、定义ClassC
@interface ClassC : NSObject
-(void)c;
@end

//ClassC定义以及实现
＃import <Foundation/Foundation.h>
＃import "ClassC.h"
＃import "ClassA.h"
＃import "ClassB.h"

@interface ClassC:NSObject< ClassAProtocol, ClassBProtocol>
-(void)c;
@end


＃import "ClassC.h"
@implement ClassC
-(void)a
{
}

-(void)b
{
}

-(void)c
{
}
@end
~~~

### 通过category(待研究)