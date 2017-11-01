//
//  KECustomTabBarController.swift
//  KETallyBOOK
//
//  Created by 科文 on 18/09/2017.
//  Copyright © 2017 科文. All rights reserved.
//

import Foundation
import UIKit

class KECustomTabBarController: UITabBarController {
    
    var tabBarItemsAttributes : Array<Dictionary<String, String>>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpCustomTabBar()
    }
    
    private func setUpCustomTabBar() {
        self.setValue(KECustomTabBar.init(frame: CGRect.zero), forKey: "tabBar")
    }
    
    public init(viewControllers:Array<UIViewController>,tabBarItemsAttributes:Array<Dictionary<String, String>>) {
        super.init(nibName: nil, bundle: nil)
        self.tabBarItemsAttributes = tabBarItemsAttributes
        self.viewControllers = viewControllers
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool) {
        if (viewControllers != nil) && ((viewControllers?.count) != nil) {
            for viewController in viewControllers! {
                viewController.willMove(toParentViewController: nil)
                viewController.view.removeFromSuperview()
                viewController.removeFromParentViewController()
            }
        }
        if viewControllers != nil {
            if tabBarItemsAttributes == nil || tabBarItemsAttributes.count != viewControllers?.count{
                print("确保属性与元素数量相同")
            }
            var idx = 0
            for viewController in viewControllers! {
                var title : String? = nil
                var normalImageName : String? = nil
                var selectedImageName : String? = nil
                title = tabBarItemsAttributes[idx]["KETabBarItemTitle"]
                normalImageName = tabBarItemsAttributes[idx]["KETabBarItemImage"]
                selectedImageName = tabBarItemsAttributes[idx]["KETabBarItemSelectedImage"]
                self.addOneChildViewController(viewController: viewController, title: title!, normalImageName: normalImageName!, selectedImageName: selectedImageName!)
                idx = idx + 1
                
            }
        }
    }
    
    private func addOneChildViewController(viewController: UIViewController,title:String,normalImageName:String,selectedImageName:String){
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = UIImage.init(named: normalImageName)?.withRenderingMode(.alwaysOriginal)
        viewController.tabBarItem.selectedImage = UIImage.init(named: selectedImageName)?.withRenderingMode(.alwaysOriginal)
        self.addChildViewController(viewController)
    }
    
    
    
}
