# 依赖注入解耦

## 普通封装方式
~~~
class Phone {
    func call(number: String){
        print ("Real phone calling to \(number)")
    }
}
class PersonalAssitant {
    let phone = Phone()
    let bossNumber = "12345678"

    func callBoss(){
        phone.call(number: bossNumber)
    }
}
~~~

phone，bossNumber 都是不可控的，由 PersonalAssitant 内部自己管理，他们的耦合度很高

## 依赖注入封装
~~~
protocol PhoneProtocol {
    func call(number: String)
}

class Phone: PhoneProtocol {
    func call(number: String){
        print ("Real phone calling to \(number)")
    }
}

class PersonalAssistant {
    let phone: PhoneProtocol
    let bossNumber: String
    
    init(aPhone: PhoneProtocol, myBossNumber: String) {
        phone = aPhone
        bossNumber = myBossNumber
    }
    
    func callBoss(){
        phone.call(number: bossNumber)
    }
}
~~~

通过依赖注入，我们获得了对phone何number的完全控制，我们可以传人任意的号码，任意的通讯设备，这使得整个代码的扩展性更好了，同时也降低了耦合度