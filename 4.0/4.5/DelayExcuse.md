# Swift 延迟1秒之后执行方法

## 1.使用perform方式

~~~
	perform(#selector(doSomething), with: self, afterDelay: 1)
	
    @objc func doSomething() {
       // Do SomeThing
    }
~~~

## 2.使用GCD方式

~~~
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
        // Do SomeThing
    }
~~~

## 3.使用定时器方式

~~~
	Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(doSomething), userInfo: nil, repeats: false)

    @objc func doSomething() {
        // Do SomeThing
    }
~~~

## 4.使用线程方式

~~~
    let thread: Thread = Thread {
        Thread.sleep(forTimeInterval: 1)
        self.dismiss(animated: true, completion: nil)
    }
    thread.start()
~~~