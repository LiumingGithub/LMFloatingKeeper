//
//  PresentedViewController.swift
//  LMFloatingKeeper
//
//  Created by 刘明 on 2019/3/20.
//  Copyright © 2019 ming.liu. All rights reserved.
//

import UIKit

class PresentedViewController: UIViewController {
    
    let imageView = UIImageView.init(image: UIImage.init(named: ViewController.Constants.imageName))
    
    // MARK: -
    deinit {
        print("func:[\(#function)], class: [\(self.classForCoder)]")
    }
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        view.backgroundColor = UIColor.white
        
        navigationItem.title = "Presented"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(PresentedViewController.doClosed))
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        if #available(iOS 11.0, *) {
            imageView.frame = view.safeAreaLayoutGuide.layoutFrame
        } else {
            imageView.frame = view.bounds
        }
    }
    
    // MARK: - actions
    @objc func doClosed() -> Void {
        (navigationController ?? self).dismiss(animated: true, completion: nil)
    }
}
