# UISearchBar 
### 自定义输入框字体大小颜色

~~~
let searchBar = UISearchBar.init()
if let searchField = searchBar.value(forKey: "searchField") as? UITextField {
            searchField.backgroundColor = UIColor(red: 242, green: 242, blue: 242)
            searchField.font = UIFont.systemFont(ofSize: 12)
            searchField.clearButtonMode = .whileEditing
        }
~~~

### 自定义取消按钮

~~~
let searchBar = UISearchBar.init()
let btn = searchBar.value(forKey: "_cancelButton") as? UIButton
btn?.setTitleColor(UIColor.rightNaviItemDefault, for: .normal)
btn?.setTitle(Language.string(key: "cancel"), for: .normal)
btn?.titleLabel?.font = UIFont.systemFont(ofSize: 15)
~~~