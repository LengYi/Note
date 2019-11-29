#  ViewController 容器

利用storyboard来开发项目的话，其实推荐的方法是利用ViewController来封装视图，然后在需要显示该视图的时候，通过
 self.view.addSubview = wrapVC.view 来进行显示，但是这里边有些细节是需要注意的。

###### 为什么要使用UIViewController的容器

这个要从我项目中遇到的一个问题说起，我在当前ViewController视图上显示一个tableView，但我不想直接把一个TableView添加到当前视图，而是想通过UITableViewController来做，于是我这样写的：

```swift
    override func viewDidLoad() {
        super.viewDidLoad()

        var tableVC = self.storyboard!.instantiateViewControllerWithIdentifier("tableViewControllerIdentifier") as UITableViewController
        self.view.addSubview(tableVC.tableView)
    }
```

运行，tableView的内容正常显示，但当我一滑动tableView，里边的数据全部没了，成了空列表。通过这个现象，可以断定当我滑动列表的时候，tableView的数据源可能出问题了，tableView的数据源在TableViewController里边，说明TableViewController可能出了问题，再一分析，原来是UITableViewController对象已经提前释放了，（通过在dealloc里边打断点），所以里边的数据源也不复存在了。那么怎么解决这个问题呢？这就说到今天的主题了，UIViewController容器这个概念是很重要的。

###### UIViewController容器接口

iOS系统给我们默认提供的容器有两个UITabBarController和UINavigationController，除了系统提供的之外，从iOS5开始，SDK增加了几个跟UIViewController容器相关的接口：

```swift
    @availability(iOS, introduced=5.0)
    var childViewControllers: [AnyObject] { get }

    @availability(iOS, introduced=5.0)
    func addChildViewController(childController: UIViewController)
    
    @availability(iOS, introduced=5.0)
    func removeFromParentViewController()
  
    @availability(iOS, introduced=5.0)
    func transitionFromViewController(fromViewController: UIViewController, toViewController: UIViewController, duration: NSTimeInterval, options: UIViewAnimationOptions, animations: (() -> Void)?, completion: ((Bool) -> Void)?)

    @availability(iOS, introduced=5.0)
    func willMoveToParentViewController(parent: UIViewController?)

    @availability(iOS, introduced=5.0)
    func didMoveToParentViewController(parent: UIViewController?)
```

###### 注意点

在调用`[父视图控制器 addChildViewController:子视图控制器]`之前，无需显式调用`[子视图控制器 willMoveToParentViewController:父视图控制器]`方法，因为已经默认调用了。
 在调用`[父视图控制器 addChildViewController:子视图控制器]`之后，要仅接着调用`[子视图控制器 didMoveToParentViewController:父视图控制器]`方法。
 在调用`[子视图控制器 removeFromParentViewController]`之前，必须先调用`[子视图控制器 willMoveToParentViewController:nil]`。
 在调用`[子视图控制器 removeFromParentViewController]`之后，无需显式调用`[子视图控制器didMoveToParentViewController:父视图控制器]`，因为已经默认调用了。
 在调用`transitionFromViewController`之前，调用`[fromController willMoveToParentViewController:nil]`。
 在调用`transitionFromViewController`之后，调用`[toController didMoveToParentViewController:父视图控制器]`。

实例

Apple 已经针对 view controller 容器做了细致的 API，我们可以构造我们能想到的任何容器场景的动画。Apple 还提供了一个基于 block 的便利方法，来切换屏幕上的两个 controller views。方法 `transitionFromViewController:toViewController:(…)` 已经为我们考虑了很多细节。

```objectivec
- (void) flipFromViewController:(UIViewController*) fromController
               toViewController:(UIViewController*) toController
                  withDirection:(UIViewAnimationOptions) direction
{
    toController.view.frame = fromController.view.bounds;                           //  1
    [self addChildViewController:toController];                                     //
    [fromController willMoveToParentViewController:nil];                            //

    [self transitionFromViewController:fromController
                      toViewController:toController
                              duration:0.2
                               options:direction | UIViewAnimationOptionCurveEaseIn
                            animations:nil
                            completion:^(BOOL finished) {

                                [toController didMoveToParentViewController:self];  //  2
                                [fromController removeFromParentViewController];    //  3
                            }];
}
```

1.在开始动画之前，我们把 toController 作为一个 child 进行添加，并通知 fromController 它将被移除。如果 `fromController` 的 `view` 是容器 `view` 层级的一部分，它的 `viewWillDisapear:` 方法就会被调用。

2.`toController` 被告知它有一个新的`parent`，并且适当的 `view` 事件方法将被调用。

3.`fromController` 被移除了。

这个为 view controller 过场动画而准备的便捷方法会自动把老的 `view controller` 换成新的 `view controller`。然而，如果你想实现自己的过场动画，并且希望一次只显示一个`view`，你需要在老的`view` 上调用 `removeFromSuperview`，并为新的 `view` 调用 `addSubview:`。错误的调用次序通常会导致 `UIViewControllerHierarchyInconsistency` 警告。例如：在添加 view 之前调用 `didMoveToParentViewController:`就触发这个警告。

为了能使用 `UIViewAnimationOptionTransitionFlipFromTop` 动画，我们必须把 children’s view 添加到我们的 `view containers` 里面，而不是 `root view controller` 的 view。否则动画将导致整个 `root view` 都翻转。

###### ContainerViewController与ChildViewContrller如何通信

ViewControllers 应该是可复用的、自包含的实体。Child ViewControllers 也不能违背这个经验法则。为了达到目的，parent view controller 应该只关心两个任务：布局 child view controller 的 root view，以及与 child view controller 暴露出来的 API 通信。它绝不应该去直接修改 child view tree 或其他内部状态。Child view controller 应该包含管理它们自己的 view 树的必要逻辑，而不是把它们看作单纯呆板的 views。这样，就有了更清晰的关注点分离和更好的可复用性。

比如在示例 Tunnel中，parent view controller 观察了 map view controllers 上的一个叫 currentLocation 的属性。

```objectivec
_startMapViewConroller.addObserver(self, forKeyPath: "currentLocation", options: NSKeyValueObserving
```

当这个属性跟着拿着铲子的小孩的移动而改变时，parent view controller 将新坐标的对跖点传递给另一个地图：

```css
oppositeController.updateAnnotationLocation([newLocation antipode])
```

像这种监听childViewContrller里的地图坐标，利用KVO很方便，因为KVO就是为了方便监听属性的更改。