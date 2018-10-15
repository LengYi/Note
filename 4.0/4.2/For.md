# Swift 进阶之 For 循环
将当前代码贴到Playground 中运行即可看到效果

~~~
//: Playground - noun: a place where people can play

import UIKit

// 正序输出 1 2 3 4 5 包含1 5
for i in 1...5 {
    print(i)
}

// 仅循环忽略变量索引值
for _ in 1...5 {
    
}

// 正序输出 1 2 3 4 不包含5
for i in 1..<5 {
    print(i)
}

// 逆序输出 10 9 8 7 6 5 4 3 2 1 0
for i in (0...10).reversed() {
    print(i)
}

for i in stride(from: 10, through: 0, by: -1) {
    print(i)
}

// 逆序输出 10 9 8 7 6 5 4 3 2 1 不包含0
for i in stride(from: 10, to: 0, by: -1) {
    print(i)
}

// 遍历数组
let names = ["Anna", "Alex", "Brian", "Jack"]
for name in names {
    print("Hello, \(name)")
}

// 遍历字典
let numberOfLegs = ["spider": 8, "ant": 6, "cat": 4]
for (animalName, legCount) in numberOfLegs {
    print("\(animalName)s have \(legCount) legs")
}

~~~