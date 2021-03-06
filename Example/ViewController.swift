//
//  ViewController.swift
//  LMFloatingKeeper
//
//  Created by 刘明 on 2019/3/19.
//  Copyright © 2019 ming.liu. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    struct Constants {
        struct Segue {
            static let NoInteractive         = "NoInteractive"
            static let Interactive           = "Interactive"
            static let FloatingAble          = "FloatigAble"
        }
        static let titles = [Segue.NoInteractive, Segue.Interactive, Segue.FloatingAble]
        static let imageName = "img"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: - present
    @IBAction func dodPresent() -> Void {
        let viewController = PresentedViewController()
        lm.preset(UINavigationController.init(rootViewController: viewController), animated: true, completion: nil)
    }
    
    //MARK: - tableview
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.titles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let flag = "main.cells"
        let cell = tableView.dequeueReusableCell(withIdentifier: flag) ?? UITableViewCell.init(style: .default, reuseIdentifier: flag)
        cell.textLabel?.text = Constants.titles[indexPath.row]
        cell.accessoryType = .disclosureIndicator
      
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: Constants.titles[indexPath.row], sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.title = segue.identifier
    }

}

// 没有自定义Interactive Pop (如果没有禁用系统自带的侧滑返回，还是会使用系统的)
class NormalViewController: UIViewController {
    
    let imageView = UIImageView.init(image: UIImage.init(named: ViewController.Constants.imageName))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        view.backgroundColor = UIColor.lightGray
    }
    
    override func viewDidLayoutSubviews() {
        if #available(iOS 11.0, *) {
            imageView.frame = view.safeAreaLayoutGuide.layoutFrame
        } else {
            imageView.frame = view.bounds
        }
    }
    
    deinit {
        print("func:[\(#function), class:[\(self.classForCoder)]]")
    }
}

// 支持自定义的侧滑返回，
class InteractiveViewController: NormalViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 根据转场动画的方向，来判断侧滑返回手势添加的位置
        // 如果是确定的方向，直接设定方向添加即可
        if let control = navigationController?.delegate as? FloatingKeeperControl {
            let edg: InteractiveDraggingEdge
            switch control.floatingTransitionProducer.uponAnimationType {
            case .fromLeft:
                edg = .right
                break
            default:
                edg = .left
                break
            }
            if let gesture = lm.interactivePop(edg) {
                view.addGestureRecognizer(gesture)
            }
        }
    }
}

// 支持微信浮窗效果的侧滑返回
class FloatingAbleViewController: InteractiveViewController, FloatingKeepAble {
    
    
    var observer: Any?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 添加通知
        observer = NotificationCenter.default.addObserver(forName: .lm_didKeptByFloatingBar, object: nil, queue: nil) {[weak self] (notification) in
            
            if let anyKeepable = notification.object as? AnyFloatingKeepAble,
                anyKeepable == self {
                print("\(self!.classForCoder) Was been kept by floating bar")
            }
        }
    }
    
    deinit {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
}

