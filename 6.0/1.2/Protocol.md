# Protocol(协议)

### 定义

~~~
protocol SomeProtocol {
	// 协议内容
}
~~~

### 使用

~~~
struct SomeStructure: FirstProtocol, SecondProtocol {

}
~~~

+ 同时使用多个协议，协议之间以逗号，分隔
+ 某个类含有父类同时实现了协议，应当把父类放到所有协议的前面

~~~
class SomeClass: SomeSuperClass, FirstProtocol, AnotherProtocol { 
	// 类的内容} 
~~~


### 属性 
协议可以声明属性变量，并标识可读写

~~~
	protocol SomeProtocol {
		var age: Int { get set }
		var height: Int { get }
	}
~~~

+ 使用类实现协议时，使用class关键字表示该属性为类成员
+ 用结构体或者枚举实现协议时，使用static关键字表示成员

### 协议类型
+ 当作函数参数类型，返回值类型
+ 作为常量，变量。属性类型
+ 作为数组，字典或其它容器中的元素类型
+ 协议类型与其它普通类型写法相同
+ 协议类型能够被赋值为任意遵循该协议的类型

### 协议合成

~~~
protocol Named {	var name: String { get }}
protocol Aged {
	var age: Int { get }
}
struct Person: Named, Aged {
	var name: String
	var age: Int
}

func wishHappyBirthday(celebrator: protocol<Named, Aged>) {	println("Happy birthday \(celebrator.name) - you're \(celebrator.a ge)!")}
~~~
wishHappyBirthday 函数的形参 celebrator 的类型为 protocol<Named,Aged>。可以传入任意遵循这两个协议的类型的实例

### 可选协议

+ 可选协议实现方案一

~~~
@objc protocol ExampleProtocol {
    @objc optional func method()
}
~~~
默认协议都要实现,以下方法实现协议的可选实现,这样声明的协议，本质是一个objc的协议，并且只用由class类型实例可以遵守，对swift中struct的enum不可用

+ 可选协议实现方案二

~~~
protocol ExampleProtocol {
    func optionalMethod() //可选
    func necessaryMethod() //必须实现
}
extension ExampleProtocol {
    func optionalMethod() {
        print("hi")
    }
}
~~~
extension可以为方法编写默认实现，这样即使我们的实力类型不写任何实现，也可用通过编译