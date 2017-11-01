//
//  KECustomTabBarButton.swift
//  KETallyBOOK
//
//  Created by 科文 on 19/09/2017.
//  Copyright © 2017 科文. All rights reserved.
//

import UIKit
 
class KECustomTabBarButton: UIButton {
    var isChangeImage : Bool = false
    typealias ActionBlock = () -> Void
    var chargeUpAction : ActionBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setBackgroundImage(UIImage.init(named: "bottom_add_normal"), for: UIControlState.normal)
        self.frame = CGRect.init(x: 0, y: 0, width: 60, height: 60*160.0/184.0)
        self.contentMode = .scaleAspectFill
        self.addTarget(self, action: #selector(pushMore), for: UIControlEvents.touchUpInside)
        self.setTitle("记账", for: .normal)
        self.titleEdgeInsets.top = 80
        self.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .thin)
        self.setTitleColor(.black, for: .normal)
        self.adjustsImageWhenHighlighted = false
    }
    
    @objc private func pushMore(){
        self.showMore()
    }
    private func showMore(){
        self.chargeUpAction!()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(Coder:) has not been implemented")
    }
    
}
