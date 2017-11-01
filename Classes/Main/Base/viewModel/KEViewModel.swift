//
//  KEViewModel.swift
//  KETallyBOOK
//
//  Created by 科文 on 21/09/2017.
//  Copyright © 2017 科文. All rights reserved.
//

import UIKit


class KEViewModel: NSObject {
    
    var services : KEViewModelService!
    
    init(withServices service:KEViewModelService,params:Dictionary<String, Any>) {
        super.init()
        self.services = service
        initialize()
    }
    func initialize() {
    
    }
    
}

