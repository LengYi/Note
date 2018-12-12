#category

## 作用
+ 对现有类进行功能扩展
+ 将类的实现分散到不同的框架中，方便代码管理

## 局限
+ category只能给某个已有的类扩充方法，不能扩充成员变量。
+ category中也可以添加属性，只不过@property只会生成setter和getter的声明，不会生成setter和getter的实现以及成员变量。
+ 如果category中的方法和类中原有方法同名，运行时会优先调用category中的方法。
+ 如果多个category中存在同名的方法，运行时到底调用哪个方法由编译器决定，最后一个参与编译的方法会被调用。