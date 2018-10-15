# Swift 进阶之 enum

###初始化默认值

~~~
// 整型
enum Movement: Int {
    case left = 0
    case right = 1
    case top = 2
    case bottom = 3
}

// 字符串
enum House: String {
    case baratheon = "Ours is the Fury"
    case greyjoy = "We Do Not Sow"
    case martell = "Unbowed, Unbent, Unbroken"
    case stark = "Winter is Coming"
    case tully = "Family, Duty, Honor"
    case tyrell = "Growing Strong"
}

// float double
enum Constants: Double {
    case pai = 3.14159
    case err = 2.71828
}

// 对于String和Int类型来说，你甚至可以忽略为枚举中的case赋值
enum Planet: Int {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
}

enum CompassPoint: String {
    case north, south, east, west
}
~~~

Swift枚举中支持以下四种关联值类型:

+ 整型(Integer)
+ 浮点数(Float Point)
+ 字符串(String)
+ 布尔类型(Boolean)

使用rawValue构造器构造一个类型

~~~
let rightMovement = Movement(rawValue: 1)
~~~

###读取枚举实际值
~~~
let bestHouse = House.stark
print(bestHouse.rawValue)
~~~

###嵌套枚举
~~~
enum Character {
    enum Weapon: String {
        case gun = "意大利加农炮"
        case bomb = "核弹"
    }
    enum Helmet: String {
        case wooden = "木质头盔"
        case iron = "铁头盔"
        case diamond = "钻石头盔"
    }
    case thief
    case warrior
    case knight
}

// 调用
    print(Character.Weapon.gun.rawValue)
    print(Character.Helmet.diamond.rawValue)
// 输出
   意大利加农炮
	钻石头盔
~~~

###关联值
~~~
enum Trade {
    case buy(stock: String, price: Int)
    case sell(stock: String, price: Int)
}

func trade(type: Trade) {
    switch type {
    case let .buy(stock, price):
        print("\(stock): \(price)")
    case let .sell(stock, price):
        print("\(stock): \(price)")
    }
}

// 调用
    trade(type: .buy(stock: "购买苹果股票", price: 10000))
    trade(type: .sell(stock: "出售美国国债", price: 9999))
// 输出
购买苹果股票: 10000
出售美国国债: 9999
~~~

###方法

~~~
enum Wearable {
    enum Weight: Int {
        case light = 1
    }
    
    enum Armor: Int {
        case light = 2
    }
    
    case helmet(weight: Weight, armor: Armor)
    
    func attributes()-> (weight: Int, armor: Int) {
        switch self {
        case .helmet(let weight, let armor):
            return (weight.rawValue * 2, armor.rawValue * 4)
        }
    }
}

// 调用
    let props = Wearable.helmet(weight: .light, armor: .light).attributes()
    print(props)
// 输出
	(weight: 2, armor: 8)

~~~

###属性
尽管增加一个存储属性到枚举中不被允许，但你依然能够创建计算属性

~~~
enum Device {
    case iPad, iPhone, appleTV, appleWatch
    var year: String {
        switch self {
        case .iPhone:
            return "2016"
        case .iPad:
            return "2017"
        default:
            return "2018"
        }
    }
    
    func introduced() -> String {
        switch self {
        case .appleTV: return "\(self) was introduced 2006"
        case .iPhone: return "\(self) was introduced 2007"
        case .iPad: return "\(self) was introduced 2010"
        case .appleWatch: return "\(self) was introduced 2014"
        }
    }
}

// 调用
    print(Device.iPhone.year)
    print(Device.iPhone.introduced())
// 输出
	2016
	iPhone was introduced 2007
~~~

###可变方法
方法声明为mutating,就允许改变隐藏参数self的case值

~~~
enum TriStateSwitch: Int {
    case offLine = 100, onLine, low, high
    
    mutating func next() {
        switch self {
        case .offLine:
            self = .onLine
        case .onLine:
            self = .offLine
        case .low:
            self = .high
        case .high:
            self = .low
        }
    }
}

// 调用
    var value = TriStateSwitch.low
    print(value.rawValue)
    value.next()
    print(value.rawValue)
    value.next()
    print(value.rawValue)
// 输出
	102
	103
	102
~~~