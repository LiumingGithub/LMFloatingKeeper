# LMFloatingKeeper

一个为控制器添加自定义的Transition动画和侧滑返回效果的库。另外附带做了一个微信中的侧滑浮窗效果(包括侧滑中显示右下角按钮，选中按钮后的飞入效果。如果还需要如微信的全屏悬浮窗的效果，后续回更新上去。如果想添加自己的实现，该库也预留有接口)。

## 效果图如下
![Screen shot](Doc/preview1.gif)
![Screen shot](Doc/preview12.gif)

## 介绍
本库的使用非常简单，低耦合。只需要几行代码，即可使应用拥有自定义的转场动画和侧滑返回效果。

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
  
  ### 如果已实现了floatingbar效果
  
  ```swift
 //实现 FloatingBarManagerType 协议，然后调用
 FloatingKeeperManager.shared.floatingBarManager = your floating bar manager
  
  ```
  
## 许可证

LMFloatingKeeper 是基于 MIT 许可证下发布的，详情请参见 LICENSE。
