//
//  KEViewModelService.swift
//  KETallyBOOK
//
//  Created by 科文 on 21/09/2017.
//  Copyright © 2017 科文. All rights reserved.
//

import Foundation

@objc public protocol KEViewModelService:NSObjectProtocol{
    @objc func getHotNewsService()->KEViewModelProtocolImpl
}
