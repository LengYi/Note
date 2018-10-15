# Charles 使用教程
### 安装Charles
[官网安装](https://www.charlesproxy.com)

[破解包安装](https://www.zzzmode.com/mytools/charles/)

### https抓包设置

 + Proxy –> SSL Proxying Setting –> Enable SSL Proxying
 + 点击Add Host * Port 443
 + 手机客户端安装证书  Help –> SSL Proxying 选择安装手机证书
 + 电脑端安装证书 Help –> SSL Proxying –> Install Charles Root Certificate
 + 在钥匙串中选择Charles证书，然后信任证书
 + 设置-通用-关于本机-证书信任设置 
 + 安装完可能需要重启手机
 + 通过以上设置然后就可以愉快的开始抓包了

 注意：同一台电脑代理不同设备，每台设备都要重新导入charles证书才能抓https包
 
 
### 模拟请求超时
 重现一些由于丢包引发的不易重现的bug
 
 + 点击Charles顶部的Proxy下拉框中的Breakpoints Settings选项
 + 勾选Enable Breakpoints选项
 + 点击add 按钮,根据需要填写
 + 点击OK按钮,当Charles主面板中六角形标志为红色时表示已经拦截

### 模拟404 接口不返回数据
 选择要被处理的域名->右键->Map Remote   填写一个404的域名
 
### 模拟慢速网络
  [链接](https://ntx.me/2014/07/21/charles-advanced/)
  
### 其它高级功能
  [链接](http://blog.devtang.com/2015/11/14/charles-introduction/)
  