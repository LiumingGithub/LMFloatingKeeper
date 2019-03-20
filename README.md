# LMFloatingKeeper
===========

一个简单使用的，为控制器添加自定义的Transition动画和侧滑返回效果。另外附带做了一个微信中的侧滑浮窗效果(包括侧滑中显示右下角按钮，选中按钮后的飞入效果)。

## 效果图如下

## 介绍
本库的使用非常简单，耦合较低。只需要几行代码中即可替换系统的自带的Transition动画和并带有侧滑效果。

## 使用说明
### 普通的 Transition 和 侧滑返回
step 1 给NavigationController 设置delegate
  ```swift
    //下面是NavigationController viewDidLoad 方法
    override func viewDidLoad() {
        super.viewDidLoad()
        let control = GeneralTransitionControl()
        delegate = control
        self.control = control
    }
        
  ```
  
step 2 给需要侧滑效果的ViewController添加侧滑手势
  ```swift
  override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 默认的手势是左侧，向右侧滑。
        /// 如果你的设置的Transition动画是从左侧push，则这里设定为.right
        if let gesture = self.lm.interactivePop(.left) {
            view.addGestureRecognizer(gesture)
        }
    }
  ```

### 仿微信的floating bar 侧滑效果

step 1 给NavigationController 设置delegate，这里使用 FloatingKeeperControl
  ```swift
    //下面是NavigationController viewDidLoad 方法
    override func viewDidLoad() {
        super.viewDidLoad()
        let control = FloatingKeeperControl()
        delegate = control
        self.control = control
    }
        
  ```
  
step 2 给需要侧滑效果的ViewController添加侧滑手势，无变化
  ```swift
  override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 默认的手势是左侧，向右侧滑。
        /// 如果你的设置的Transition动画是从左侧push，则这里设定为.right
        if let gesture = self.lm.interactivePop(.left) {
            view.addGestureRecognizer(gesture)
        }
    }
  ```
  
step 3 给需要添加微信floatingbar侧滑的控制器,实现FloatingKeepAble协议即可
```swift
// 支持微信浮窗效果的侧滑返回
class FloatingAbleViewController: UIViewController, FloatingKeepAble {
    // your implemention
}
  ```
