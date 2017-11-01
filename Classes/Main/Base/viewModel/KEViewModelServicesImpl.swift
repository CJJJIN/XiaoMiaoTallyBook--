//
//  KEViewModelServicesImpl.swift
//  KETallyBOOK
//
//  Created by 科文 on 19/09/2017.
//  Copyright © 2017 科文. All rights reserved.
//

import UIKit

class KEViewModelServicesImpl: NSObject,KEViewModelService{
    
    var homeDetialService : KEHomeDetailProtocolImpl!
    
    override init() {
        
        super.init()
        homeDetialService = KEHomeDetailProtocolImpl()
        
    }
    
    func getHotNewsService() -> KEViewModelProtocolImpl {
        return homeDetialService
    }
}
