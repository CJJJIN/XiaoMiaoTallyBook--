//
//  WKCustomeRefreshHeader.swift
//  KETallyBOOK
//
//  Created by 科文 on 16/10/2017.
//  Copyright © 2017 科文. All rights reserved.
//

import UIKit
import MJRefresh

class WKCustomeRefreshHeader: MJRefreshNormalHeader {

    override func prepare() {
        super.prepare()
        self.lastUpdatedTimeLabel.isHidden = true
        self.setTitle("下拉查看下月数据", for: .willRefresh)
        self.setTitle("松开可查看下月数据", for: .pulling)
        self.setTitle("读取中～～", for: .refreshing)
        self.setTitle("下拉可以查看下月数据", for: .idle)
    }

}

class WKCustomeRefreshFotoer: MJRefreshBackNormalFooter {
    override func prepare() {
        super.prepare()
        self.setTitle("上拉查看上月数据", for: .idle)
        self.setTitle("上拉查看上月数据", for: .willRefresh)
        self.setTitle("松开可查看上月数据", for: .pulling)
        self.setTitle("读取中～～", for: .refreshing)
        self.setTitle("", for: .noMoreData)
    }
}
