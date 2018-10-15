
# Swift 进阶之 闭包

1、闭包是什么

闭包的本质是代码块，它是函数的升级版本，函数是有名称、可复用的代码块，闭包则是比函数更加灵活的匿名代码块。

2、为什么需要闭包

函数已经可以满足我们开发中大部分的需求了，那么为什么还需要闭包呢。在开发中我们经常需要传递各种数据，我们习惯了传递一个值：Int，一串符号：String，一个对象：Class，但是有时我们需要传递一种处理问题的逻辑，我们常用的类型似乎满足不了这种需求，而函数恰好是一种处理问题的逻辑，为了让函数像Int、Float、String等常用类型一样灵活的传递和调用，闭包就出现了。

```
//函数
func eatTomatos(a: Int, b: Int) -> Int {
    return a + b
}

//嵌套函数
func eatTomatos(a: Int, b: Int) -> Int {
    //嵌套函数
    func digest(a: Int, b: Int) -> Int {
        return 2 * a + b
    }
    
    return digest(a: a, b: b)
}

//闭包
var eatTomatos = {(a: Int, b: Int) -> Int in
    return a + b
}

```
函数和嵌套函数其实是一回事，唯一的区别是，嵌套函数是定义在一个函数内部的函数，对外部是隐藏的，只能在其定义的函数内部有效。

闭包与函数的区别

```
1、不需要使用func关键字;
2、其次函数有名称如：eatTomatos，而闭包是没有名称的;
3、闭包的参数和函数体都要使用{ }包起来，在参数后要使用in关键字连接函数体;
4、闭包可以作为一种类型赋值给一个变量，上面代码中的闭包类型是：(Int, Int) -> Int;
```

函数是全局的，不能捕获上下文中的变量；而嵌套函数和闭包可以直接嵌套在上下文中使用的，因此可以捕获上下文中的变量，需要注意的是每一个闭包都只会持有一个它所捕获的变量的副本

```
    override func loadView() {
        print(test(a: 1, b: 2))
    }
    
    func test(a: Int, b: Int) -> Int {
        var numArr: Array<Int> = Array.init()
        func digest(a: Int, b: Int) -> Int {
            numArr.append(a)
            numArr.append(b)
            return 2 * a + b
        }
        
        print(numArr.count)
        return digest(a:a,b:b)
    }
    
    结果输出 0 4 

```

闭包作为参数或者返回值

```
  // 闭包作为函数参数
  override func loadView() {
       // 调用test1函数
        test1 { (a, b) in
            print(a)
            print(b)
        }
    }
    
   // test1函数 参数是一个闭包，闭包类型是 (Int,Int) -> Void
  func test1(a: (Int,Int) -> Void) {
       a(1,2)
    }
    
     结果输出 1 2

```


```
// 闭包作为返回值
    var fun: (Int,Int) -> Int = {
        (a: Int, b: Int) -> Int in
        return a + b
    }
    
    override func loadView() {
       let test = test2()
        print(test(100,200))
    }
    
    func test2() -> (Int,Int) -> Int {
        return fun
    }

```
函数test2将闭包 (Int,Int) -> Int 作为返回值，这里返回的是 (Int,Int) -> Int 的一个实例，调用者使用返回的实例获取(Int,Int) -> Int闭包处理参数的逻辑，实现代码的传递和复用

闭包类型起别名

```
   // 把(Int, Int) -> Int类型抽象为pa
   typealias pa = (Int,Int) -> Int
    
    var fun: pa = {
        (a: Int, b: Int) -> Int in
        return a + b
    }
    
    override func loadView() {
       let test = test2()
        print(test(100,200))
    }
    
    func test2() -> pa {
        return fun
    }
    
    输出 300

```

~~~

闭包block传值
class A {
    func test() {
        let b: B = B() // 将类B的值回传给类A
        b.test { (a, b) -> Int in
            let sum = a + b
            print(sum)
            return sum
        }
    }
}

typealias Add = (Int,Int) -> Int
class B {
    var handler: Add?
    func test(calculate: @escaping Add) -> Int {
        self.handler = calculate
        if self.handler != nil {
            return self.handler!(3,4)
        }
        
        return -1
    }
    
    func test2()
}

// 调用
    override func loadView() {
        let a: A = A()
        a.test()
    }
// 输出 7
~~~

1、使用闭包时要注意管理内存； 

2、当作闭包为函数参数使用时可以脱离函数独立使用时，要将此闭包声明为逃逸闭包，在参数类型前面加上@escaping，否则会报错


懒加载

~~~
private lazy var tmpStr:UILabel = {
	let tmpLabel:UILabel = UILabel()
	return tmpLabel
}()

~~~

尾随闭包
闭包作为函数的参数，并且这个参数是最后一个
闭包包含的代码块不用写在"()"之内，而是写在"()"之后的"{}"之内

~~~
	func funcA(text:String, closure:() -> Void) {
	    closure()
	}
	
	func funcB(text:String, closure_A:() -> Void, closure_B:() -> Void) {
	    closure_A()
	    closure_B()
	}
	
	func funcC(closure:(_ a:Int,_ b:Int) -> Int) {
	    let sum = closure(100, 200)
	    print(sum)
	}

    override func loadView() {
        // 尾随闭包调用方式
        funcA(text: "123") {
            print("尾随闭包调用方式")
        }
        
        funcA(text: "", closure: {
            print("非尾随闭包调用方式")
        })
        
        funcB(text: "456", closure_A: {
            
        }) {
            print("多回调尾随闭包调用方式,只有最后一个闭包才有成为尾随闭包的权利")
        }
        
        funcB(text: "789", closure_A: {
            
        }, closure_B: {
            print("多回调非尾随闭包调用方式")
        })
        
        funcC { (a, b) -> Int in
            a + b // 只有一行语句可以省略 return 等效于 return a + b ,多行语句不能省略return
        }
    }
~~~

逃逸闭包

~~~
当一个闭包作为参数传到一个函数中，但是这个闭包在函数返回之后才被执行，我们称该闭包从函数中逃逸。逃逸闭包多用来做函数回调，与Objective-C里的Block有异曲同工之妙

// 逃逸闭包示例：下面的闭包被方法外的数组引用，也就意味着，这个闭包在函数执行完后还可能被调用，所以必须使用逃逸闭包，不然编译不过去
    var completionHandlers: [() -> Void] = []
    func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
        completionHandlers.append(completionHandler)
    }
// 非逃逸闭包
    func someFunctionWithNoneEscapingClosure(closure: () -> Void) {
        closure()
    }

    var x = 10
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib. 
        // 逃逸闭包
        someFunctionWithEscapingClosure {
            // 注意：逃逸闭包类必须显式的引用self，
            self.x = 100
        }
        someFunctionWithNoneEscapingClosure {
            x = 200
        }
        print("x= \(x)")// x= 200
        completionHandlers.first?()
        print("x= \(x)")// x= 100
    }
~~~

自动闭包

~~~
自动闭包：闭包作为参数传递给函数时，可以将闭包定义为自动闭包（使用关键字@autoclosure）。这样传递参数时，可以直接传递一段代码（或者一个变量、表达式），系统会自动将这段代码转化成闭包。需要注意：过度使用 autoclosures 会让你的代码变得难以理解
~~~

循环引用

```
声明被捕获的引用为弱引用(weak)或无主引用(unowned)就可打破循环引用，至于使用弱引用还是无主引用应当根据上下文来选择。

 var name: String = "打破循环"
    lazy var printName_A: () -> () = { [unowned self] in
        print("无主引用: " + self.name)
    }
    
    lazy var printName_B: () -> () = { [weak self] in
        if let strongSelf = self {
            print("弱引用: \(strongSelf.name)")
        }
    }
    
    override func loadView() {
        self.printName_A()
        self.printName_B()
    }
    
```

参数捕获

~~~
    override func loadView() {
        // 在闭包一开始创建的时候捕获变量的值，
        // []内的为捕获列表，一开始捕获值，而非引用。
        // 捕获的为原始变量的副本->常量，并且只能在闭包内访问
        var str = "Hello,playground"
        let show = { [strcopy = str] in
            print("这是str-----\(str)\n这是strcopy-----\(strcopy)")
        }
        
        str = "hello"
        show()
    }
    
    // 输出
    这是str-----hello
	这是strcopy-----Hello,playground
~~~