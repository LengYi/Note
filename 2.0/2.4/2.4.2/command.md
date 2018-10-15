# Git 常用操作命令

## 仓库操作
### clone远程库所有分支

~~~
git clone xxxxxxx.git  克隆master到本地
进入git
git branch -a 列出所有分支名称
git checkout -b dev origin/dev checkout远程的dev分支,在本地起名为dev分支,并切换到本地的dev分支
~~~


### 查看当前工程连接的远程仓库地址

~~~
 git remote -v
~~~

### 删除当前工程连接的远程仓库地址

~~~
git remote rm origin 
~~~

### 连接新的远程仓库地址

~~~
git remote add origin  xxx.git   远程仓库地址
~~~

### 删除远程分支

~~~
git push origin :serverfix  （serverfix为分支名称）
~~~

### 推送本地新分支至远程服务器并建立新的远程分支

~~~

（1）从已有的分支创建新的分支(如从master分支),创建一个dev分支
git checkout -b dev
（2）创建完可以查看一下,分支已经切换到dev
git branch
    * dev
    master
（3）提交该分支到远程仓库 git push origin dev
（4）测试从远程获取dev git pull origin dev 或者：
如果用命令行，运行 git fetch，可以将远程分支信息获取到本地，再运行 git checkout -b local-branchname origin/remote_branchname  就可以将远程分支映射到本地命名为local-branchname  的一分支
（5）我觉得现在重要的就是设置git push,pull默认的提交获取分支,这样就很方便的使用git push 提交信息或git pull获取信息
git branch --set-upstream-to=origin/dev
取消对master的跟踪
	git branch --unset-upstream master
（6）现在随便修改一下工程文件的内容,然后git commit ,git push,之后就可以直接提交到远程的dev分支中,而不会是master
~~~

## 合并commit
### 合并某个分支上的一系列commits
~~~
git log
commit A
commit B
commit C
commit D
。。。

要合并ABCcommit日志
git rebase -i D

将需要修改注释的行前面改成squash,也可简写成s
按esc退出编辑模式
shift + wq 保存退出，然后重新编辑commit日志

~~~

### 将branch A 上的n个commit合并成一个到 branch B

~~~
git branch 
branch A
branch B
（1）换到branch B，git checkout B
（2）git merge —squash A
（3）git add ./
（4）git commit -m “新的commit信息,之前的所有commit信息将被丢弃”
~~~

### 移除远程仓库最新一条commit记录,ABCD已提交远程仓库，删除远程仓库 上的commit A

~~~
git log
commit A
commit B
commit C
commit D

git reaset —hard B
git push -f       远程仓库 commit A 将被丢弃
~~~

### 修改最后一次本地commit信息

~~~
git commit —amend 
~~~

## tag
git跟其它版本控制系统一样，可以打标签(tag), 作用是标记一个点为一个版本号，如0.1.3, v0.1.7, ver_0.1.3.在程序开发到一个阶段后，我们需要打个标签，发布一个版本，标记的作用显而易见。
下面介绍一下打标签，分享标签，移除标签的操作命令。
### 打标签

~~~
 git tag -a 0.1.3 -m “Release version 0.1.3″
    详解：git tag 是命令
        -a 0.1.3是增加 名为0.1.3的标签
        -m 后面跟着的是标签的注释
    打标签的操作发生在我们commit修改到本地仓库之后。完整的例子
        git add .
        git commit -m “fixed some bugs”
        git tag -a 0.1.3 -m “Release version 0.1.3″
~~~

### 分享提交标签到远程服务器上

~~~
 git push origin master
    git push origin --tags
    –tags参数表示提交所有tag至服务器端，普通的git push origin master操作不会推送标签到服务器端。
~~~

### 删除本地标签

~~~
git tag -d 0.1.3
~~~

### 删除远端服务器的标签

~~~
git push origin :refs/tags/0.1.3
~~~

### 强制创建一个基于指定的tag的分支

~~~
git checkout -B test v0.1.0  （新的分支名test  原始tag  v0.1.0）
~~~