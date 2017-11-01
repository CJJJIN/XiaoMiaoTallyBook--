//
//  KEConfigBaseNavigationController.swift
//  KETallyBOOK
//
//  Created by 科文 on 21/09/2017.
//  Copyright © 2017 科文. All rights reserved.
//

import UIKit

class KEConfigBaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        setUpNavigationBarAppearance()
        if viewControllers.count > 0{
             viewController.hidesBottomBarWhenPushed = true
        }
       
        super.pushViewController(viewController, animated: animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setUpNavigationBarAppearance(){
        let navigationBarAppearance = UINavigationBar.appearance()
        var textlAttrs = Dictionary<NSAttributedStringKey, Any>.init()
        textlAttrs[.foregroundColor] = UIColor.black
        textlAttrs[.font] = UIFont.init(name: "Noteworthy-Bold", size:20 )
        navigationBarAppearance.titleTextAttributes = textlAttrs
        navigationBarAppearance.barTintColor = UIColor.init(red: 254/255, green: 217/255, blue: 83/255, alpha: 1)
        navigationBarAppearance.tintColor = UIColor.darkText
    }

}
