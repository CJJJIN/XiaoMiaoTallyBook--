//
//  KECustomTabBarControllerConfig.swift
//  KETallyBOOK
//
//  Created by 科文 on 18/09/2017.
//  Copyright © 2017 科文. All rights reserved.
//

import Foundation
import UIKit

class KECustomTabBarControllerConfig: NSObject {
    
    var viewModelServices:KEViewModelServicesImpl!
    var HomeDetailViewModel:KEViewModel!
    
   public var tabBarController : KECustomTabBarController! {
        get{
            self.customizeTabBarApperance()
            return KECustomTabBarController.init(viewControllers: viewControllers(), tabBarItemsAttributes: tabBarItemsAttrbutesForContrller())
        }
    }
    
    private func viewControllers()->Array<UIViewController> {
        
        viewModelServices = KEViewModelServicesImpl.init()
        let homeDetailViewModel = KEHomeDetailViewModel.init(withServices: viewModelServices, params: ["":""])
        let homeController =  KEHomeDetailViewController.init(WithViewModel: homeDetailViewModel)
        homeController.title = "小喵记账"
        let controller1 = KEConfigBaseNavigationController.init(rootViewController: homeController)
        let chartViewModel = KEChartViewModel.init(withServices: viewModelServices, params: ["":""])
        let chartController =  KEChartViewController.init(WithViewModel: chartViewModel)
        let controller2 = KEConfigBaseNavigationController.init(rootViewController: chartController)
        let findController = KEFindViewController()
        let controller3 = KEConfigBaseNavigationController.init(rootViewController: findController)
        let settingController = KESettingController()
        let controller4 = KEConfigBaseNavigationController.init(rootViewController: settingController)
        let viewControllers = [controller1,controller2,controller3,controller4]
        return viewControllers
    }
    
    private func tabBarItemsAttrbutesForContrller() -> Array<Dictionary<String, String>>{
        let dict1 = ["KETabBarItemTitle":"明细","KETabBarItemImage":"bottom_detail_normal","KETabBarItemSelectedImage":"bottom_detail_pressed"]
        let dict2 = ["KETabBarItemTitle":"图表","KETabBarItemImage":"bottom_chart_normal","KETabBarItemSelectedImage":"bottom_chart_pressed"]
        let dict3 = ["KETabBarItemTitle":"发现","KETabBarItemImage":"bottom_find_normal","KETabBarItemSelectedImage":"bottom_find_pressed"]
        let dict4 = ["KETabBarItemTitle":"设置","KETabBarItemImage":"bottom_setting_normal","KETabBarItemSelectedImage":"bottom_setting_pressed"]
        let tabBarItemsAttributes = [dict1,dict2,dict3,dict4];
        return tabBarItemsAttributes
    }
    
    private func customizeTabBarApperance(){
        var normalAttrs = Dictionary<NSAttributedStringKey, Any>.init()
        normalAttrs[.foregroundColor] = UIColor.black
        normalAttrs[.font] = UIFont.systemFont(ofSize: 10, weight: .thin)
        var selectAttrs = Dictionary<NSAttributedStringKey, Any>.init()
        selectAttrs[.font] = UIFont.systemFont(ofSize: 10, weight: .thin)
        selectAttrs[.foregroundColor] = UIColor.black
        let tabBar = UITabBarItem.appearance()
        tabBar.setTitleTextAttributes(normalAttrs, for: .normal)
        tabBar.setTitleTextAttributes(selectAttrs, for: .selected)
        UITabBar.appearance().backgroundImage = UIImage.init()
        UITabBar.appearance().backgroundColor = UIColor.white
    }
}
