//
//  KECustomTabBar.swift
//  KETallyBOOK
//
//  Created by 科文 on 18/09/2017.
//  Copyright © 2017 科文. All rights reserved.
//

import UIKit
import Foundation

class KECustomTabBar: UITabBar {

    var customButton : KECustomTabBarButton!

    override init(frame: CGRect) {
        super.init(frame:frame)
        self.sharedInit()
        return
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.sharedInit()
    }

    private func sharedInit(){
        self.customButton = KECustomTabBarButton.init()
        self.customButton.chargeUpAction = ({[weak self] in
            let viewModelServices = KEViewModelServicesImpl.init()
            let billTypeViewModel = KEBillTypeViewModel.init(withServices: viewModelServices, params: ["":""])
            billTypeViewModel.isKind = false
            let chargeUpVC = KEChargeUpViewController.init(WithViewModel: billTypeViewModel)
            self?.getCurrentViewController()?.present(KEConfigBaseNavigationController.init(rootViewController: chargeUpVC), animated: true, completion: {
                (self?.getCurrentViewController() as! UITabBarController).selectedIndex = 0;
            })
        })
        self.addSubview(self.customButton)
    }
    private func getCurrentViewController()->UIViewController?{
        var next:UIView! = self
        repeat{
            if let nextResponder = next.next, nextResponder.isKind(of: UIViewController.self){
                return (nextResponder as! UIViewController)
            }
            next = next?.superview
        }while next != nil
        return nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let barWidth = self.bounds.size.width
        let barHeight = self.bounds.size.height
        let barItemWidth = (barWidth-60)/4
        self.customButton.center = CGPoint.init(x: barWidth * 0.5, y: 0)
        var tabbarButtonIndex = 0;
        for childView in self.subviews {
            if (childView.isKind(of: NSClassFromString("UITabBarButton")!)){
                if tabbarButtonIndex < 2 {
                    childView.frame = CGRect.init(x: CGFloat(tabbarButtonIndex) * barItemWidth, y: 0, width: barItemWidth, height: barHeight)
                }else{
                    childView.frame = CGRect.init(x:  CGFloat(tabbarButtonIndex) * barItemWidth + 60, y: 0, width: barItemWidth, height: barHeight)
                }
                tabbarButtonIndex = tabbarButtonIndex + 1;
            }
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var view = super.hitTest(point, with: event)
        if(view == nil){
            let newPoint = self.customButton.convert(point, from: self)
            if self.customButton.bounds.contains(newPoint) && !self.isHidden{
                view = self.customButton
            }
        }
        return view;
        
    }
    
    
    
    
}

