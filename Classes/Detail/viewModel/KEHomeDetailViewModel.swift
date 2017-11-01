//
//  KEHomeDetailViewModel.swift
//  KETallyBOOK
//
//  Created by 科文 on 21/09/2017.
//  Copyright © 2017 科文. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class KEHomeDetailViewModel: KEViewModel {
    
    
    var billDetailData : Variable<[Any]> = Variable([])
    var displayTimeData = Variable<String>(.init())
    var deleteData = Variable<KEHomeBillModel>(.init())
    var updateData = Variable<KEHomeBillModel>(.init())
    private var billDetailArry : [KEHomeBillModel]!
    let disposebag = DisposeBag()
    var displayTmpTime : String = ""
    var updateModel : KEHomeBillModel?
    
    override init(withServices service: KEViewModelService, params: Dictionary<String, Any>) {
        super.init(withServices: service, params: params)
    }
    
    override func initialize() {
        displayTimeData.asObservable().skip(1).subscribe(onNext: { [weak self] displayTime in
            //self?.billDetailData.value = bg_executeSql("select * from KEHomeBillModel where  BG_currentTime like \"\(displayTime)%\"", "KEHomeBillModel") as! [KEHomeBillModel]
            var myTime = displayTime
            if myTime == "dismiss"{
                myTime = (self?.displayTmpTime)!
            }else{
                self?.displayTmpTime = displayTime
            }
            var allExpendMoney : Float! = 0
            var allIncomeMoney : Float! = 0
            
            let allExpendCount = (((bg_executeSql("select COUNT(BG_money)  from KEHomeBillModel where BG_isIncome = 0 and BG_currentTime like \"\(myTime)%\"", nil) as! NSArray)[0] as! NSDictionary)["COUNT(BG_money)"] as! NSNumber).floatValue
            if allExpendCount != 0  {
                allExpendMoney = (((bg_executeSql("select SUM(BG_money)  from KEHomeBillModel where BG_isIncome = 0 and BG_currentTime like \"\(myTime)%\"", nil) as! NSArray)[0] as! NSDictionary)["SUM(BG_money)"] as! NSNumber).floatValue
            }
            let allIncomeCount = (((bg_executeSql("select COUNT(BG_money)  from KEHomeBillModel where BG_isIncome = 1 and BG_currentTime like \"\(myTime)%\"", nil) as! NSArray)[0] as! NSDictionary)["COUNT(BG_money)"] as! NSNumber).floatValue
            if allIncomeCount != 0  {
                allIncomeMoney = (((bg_executeSql("select SUM(BG_money)  from KEHomeBillModel where BG_isIncome = 1 and BG_currentTime like \"\(myTime)%\"", nil) as! NSArray)[0] as! NSDictionary)["SUM(BG_money)"] as! NSNumber).floatValue
            }
            let timeList = bg_executeSql("select distinct BG_currentTime from KEHomeBillModel where  BG_currentTime like \"\(myTime)%\" ORDER BY \"BG_currentTime\"  desc", "KEHomeBillModel") as! [KEHomeBillModel]
            var array = [Any]()
            for model in timeList{
                var array1 = [Any]()
                var expendMoney : Float! = 0
                var incomeMoney : Float! = 0
                array1.append(model.currentTime)
                let expendCount = (((bg_executeSql("select COUNT(BG_money)  from KEHomeBillModel where BG_isIncome = 0 and BG_currentTime = \"\(model.currentTime!)\"", nil) as! NSArray)[0] as! NSDictionary)["COUNT(BG_money)"] as! NSNumber).floatValue
                if expendCount != 0  {
                    expendMoney = (((bg_executeSql("select SUM(BG_money)  from KEHomeBillModel where BG_isIncome = 0 and BG_currentTime = \"\(model.currentTime!)\"", nil) as! NSArray)[0] as! NSDictionary)["SUM(BG_money)"] as! NSNumber).floatValue
                }
                let incomeCount = (((bg_executeSql("select COUNT(BG_money)  from KEHomeBillModel where BG_isIncome = 1 and BG_currentTime = \"\(model.currentTime!)\"", nil) as! NSArray)[0] as! NSDictionary)["COUNT(BG_money)"] as! NSNumber).floatValue
                if incomeCount != 0  {
                    incomeMoney = (((bg_executeSql("select SUM(BG_money)  from KEHomeBillModel where BG_isIncome = 1 and BG_currentTime = \"\(model.currentTime!)\"", nil) as! NSArray)[0] as! NSDictionary)["SUM(BG_money)"] as! NSNumber).floatValue
                }
                array1.append(expendMoney)
                array1.append(incomeMoney)
                let modelArry = bg_executeSql("select * from KEHomeBillModel where  BG_currentTime = \"\(model.currentTime!)\"", "KEHomeBillModel") as! [KEHomeBillModel]
                array1.append(modelArry)
                array.append(array1)
            }
            self?.billDetailData.value = [allExpendMoney,allIncomeMoney,array]
        }).addDisposableTo(disposebag)
        
        deleteData.asObservable().skip(1).subscribe(onNext: { [weak self] deleteModel in
            KEHomeBillModel.bg_deleteWhere(["bg_id","=","\(deleteModel.bg_id)"])

            let myTime = (self?.displayTmpTime)!
            var allExpendMoney : Float! = 0
            var allIncomeMoney : Float! = 0
            
            let allExpendCount = (((bg_executeSql("select COUNT(BG_money)  from KEHomeBillModel where BG_isIncome = 0 and BG_currentTime like \"\(myTime)%\"", nil) as! NSArray)[0] as! NSDictionary)["COUNT(BG_money)"] as! NSNumber).floatValue
            if allExpendCount != 0  {
                allExpendMoney = (((bg_executeSql("select SUM(BG_money)  from KEHomeBillModel where BG_isIncome = 0 and BG_currentTime like \"\(myTime)%\"", nil) as! NSArray)[0] as! NSDictionary)["SUM(BG_money)"] as! NSNumber).floatValue
            }
            let allIncomeCount = (((bg_executeSql("select COUNT(BG_money)  from KEHomeBillModel where BG_isIncome = 1 and BG_currentTime like \"\(myTime)%\"", nil) as! NSArray)[0] as! NSDictionary)["COUNT(BG_money)"] as! NSNumber).floatValue
            if allIncomeCount != 0  {
                allIncomeMoney = (((bg_executeSql("select SUM(BG_money)  from KEHomeBillModel where BG_isIncome = 1 and BG_currentTime like \"\(myTime)%\"", nil) as! NSArray)[0] as! NSDictionary)["SUM(BG_money)"] as! NSNumber).floatValue
            }
            let timeList = bg_executeSql("select distinct BG_currentTime from KEHomeBillModel where  BG_currentTime like \"\(myTime)%\" ORDER BY \"BG_currentTime\"  desc", "KEHomeBillModel") as! [KEHomeBillModel]
            var array = [Any]()
            for model in timeList{
                var array1 = [Any]()
                var expendMoney : Float! = 0
                var incomeMoney : Float! = 0
                array1.append(model.currentTime)
                let expendCount = (((bg_executeSql("select COUNT(BG_money)  from KEHomeBillModel where BG_isIncome = 0 and BG_currentTime = \"\(model.currentTime!)\"", nil) as! NSArray)[0] as! NSDictionary)["COUNT(BG_money)"] as! NSNumber).floatValue
                if expendCount != 0  {
                    expendMoney = (((bg_executeSql("select SUM(BG_money)  from KEHomeBillModel where BG_isIncome = 0 and BG_currentTime = \"\(model.currentTime!)\"", nil) as! NSArray)[0] as! NSDictionary)["SUM(BG_money)"] as! NSNumber).floatValue
                }
                let incomeCount = (((bg_executeSql("select COUNT(BG_money)  from KEHomeBillModel where BG_isIncome = 1 and BG_currentTime = \"\(model.currentTime!)\"", nil) as! NSArray)[0] as! NSDictionary)["COUNT(BG_money)"] as! NSNumber).floatValue
                if incomeCount != 0  {
                    incomeMoney = (((bg_executeSql("select SUM(BG_money)  from KEHomeBillModel where BG_isIncome = 1 and BG_currentTime = \"\(model.currentTime!)\"", nil) as! NSArray)[0] as! NSDictionary)["SUM(BG_money)"] as! NSNumber).floatValue
                }
                array1.append(expendMoney)
                array1.append(incomeMoney)
                let modelArry = bg_executeSql("select * from KEHomeBillModel where  BG_currentTime = \"\(model.currentTime!)\"", "KEHomeBillModel") as! [KEHomeBillModel]
                array1.append(modelArry)
                array.append(array1)
            }
            self?.billDetailData.value = [allExpendMoney,allIncomeMoney,array]
        }).addDisposableTo(disposebag)
        
        updateData.asObservable().skip(1).subscribe(onNext: { [weak self] updateModel in
            updateModel.bg_updateWhere(["bg_id","=",updateModel.bg_id])
            let myTime = (self?.displayTmpTime)!
            var allExpendMoney : Float! = 0
            var allIncomeMoney : Float! = 0
            
            let allExpendCount = (((bg_executeSql("select COUNT(BG_money)  from KEHomeBillModel where BG_isIncome = 0 and BG_currentTime like \"\(myTime)%\"", nil) as! NSArray)[0] as! NSDictionary)["COUNT(BG_money)"] as! NSNumber).floatValue
            if allExpendCount != 0  {
                allExpendMoney = (((bg_executeSql("select SUM(BG_money)  from KEHomeBillModel where BG_isIncome = 0 and BG_currentTime like \"\(myTime)%\"", nil) as! NSArray)[0] as! NSDictionary)["SUM(BG_money)"] as! NSNumber).floatValue
            }
            let allIncomeCount = (((bg_executeSql("select COUNT(BG_money)  from KEHomeBillModel where BG_isIncome = 1 and BG_currentTime like \"\(myTime)%\"", nil) as! NSArray)[0] as! NSDictionary)["COUNT(BG_money)"] as! NSNumber).floatValue
            if allIncomeCount != 0  {
                allIncomeMoney = (((bg_executeSql("select SUM(BG_money)  from KEHomeBillModel where BG_isIncome = 1 and BG_currentTime like \"\(myTime)%\"", nil) as! NSArray)[0] as! NSDictionary)["SUM(BG_money)"] as! NSNumber).floatValue
            }
            let timeList = bg_executeSql("select distinct BG_currentTime from KEHomeBillModel where  BG_currentTime like \"\(myTime)%\" ORDER BY \"BG_currentTime\"  desc", "KEHomeBillModel") as! [KEHomeBillModel]
            var array = [Any]()
            for model in timeList{
                var array1 = [Any]()
                var expendMoney : Float! = 0
                var incomeMoney : Float! = 0
                array1.append(model.currentTime)
                let expendCount = (((bg_executeSql("select COUNT(BG_money)  from KEHomeBillModel where BG_isIncome = 0 and BG_currentTime = \"\(model.currentTime!)\"", nil) as! NSArray)[0] as! NSDictionary)["COUNT(BG_money)"] as! NSNumber).floatValue
                if expendCount != 0  {
                    expendMoney = (((bg_executeSql("select SUM(BG_money)  from KEHomeBillModel where BG_isIncome = 0 and BG_currentTime = \"\(model.currentTime!)\"", nil) as! NSArray)[0] as! NSDictionary)["SUM(BG_money)"] as! NSNumber).floatValue
                }
                let incomeCount = (((bg_executeSql("select COUNT(BG_money)  from KEHomeBillModel where BG_isIncome = 1 and BG_currentTime = \"\(model.currentTime!)\"", nil) as! NSArray)[0] as! NSDictionary)["COUNT(BG_money)"] as! NSNumber).floatValue
                if incomeCount != 0  {
                    incomeMoney = (((bg_executeSql("select SUM(BG_money)  from KEHomeBillModel where BG_isIncome = 1 and BG_currentTime = \"\(model.currentTime!)\"", nil) as! NSArray)[0] as! NSDictionary)["SUM(BG_money)"] as! NSNumber).floatValue
                }
                array1.append(expendMoney)
                array1.append(incomeMoney)
                let modelArry = bg_executeSql("select * from KEHomeBillModel where  BG_currentTime = \"\(model.currentTime!)\"", "KEHomeBillModel") as! [KEHomeBillModel]
                array1.append(modelArry)
                array.append(array1)
            }
            self?.billDetailData.value = [allExpendMoney,allIncomeMoney,array]
        }).addDisposableTo(disposebag)
    }
}
