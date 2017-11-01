//
//  KEChartViewModel.swift
//  KETallyBOOK
//
//  Created by 科文 on 17/10/2017.
//  Copyright © 2017 科文. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class KEChartViewModel: KEViewModel {
    var billDetailData : Variable<[Any]> = Variable([])
    var displayTimeData = Variable<String>(.init())
    var displayYearData = Variable<String>(.init())
    private var billDetailArry : [KEHomeBillModel]!
    let disposebag = DisposeBag()
    var displayTmpTime : String = ""
    var displayYearTime : String = ""
    var isIncome = false
    
    override init(withServices service: KEViewModelService, params: Dictionary<String, Any>) {
        super.init(withServices: service, params: params)
    }
    
    override func initialize() {
        displayTimeData.asObservable().skip(1).subscribe(onNext: { [weak self] displayTime in
            //self?.billDetailData.value = bg_executeSql("select * from KEHomeBillModel where  BG_currentTime like \"\(displayTime)%\"", "KEHomeBillModel") as! [KEHomeBillModel]
            var myTime = displayTime
            if myTime == "income"{
                myTime = (self?.displayTmpTime)!
                self?.isIncome = true
            }else if myTime == "expend"{
                myTime = (self?.displayTmpTime)!
                self?.isIncome = false
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
//                let modelArry = bg_executeSql("select * from KEHomeBillModel where  BG_currentTime = \"\(model.currentTime!)\"", "KEHomeBillModel") as! [KEHomeBillModel]
//                array1.append(modelArry)
                array.append(array1)
            }
            let typeList = bg_executeSql("select distinct BG_typeName, BG_categoryImageFileName_S  from KEHomeBillModel where  BG_currentTime like \"\(myTime)%\" ORDER BY \"BG_currentTime\"  desc", "KEHomeBillModel") as! [KEHomeBillModel]
            
            var topArray = [Any]()
            for model in typeList{
                var array1 = [Any]()
                var expendMoney : Float! = 0
                var incomeMoney : Float! = 0
                let expendCount = (((bg_executeSql("select COUNT(BG_money)  from KEHomeBillModel where BG_isIncome = 0 and BG_typeName = \"\(model.typeName!)\" and BG_currentTime like \"\(myTime)%\"", nil) as! NSArray)[0] as! NSDictionary)["COUNT(BG_money)"] as! NSNumber).floatValue
                if expendCount != 0  {
                    expendMoney = (((bg_executeSql("select SUM(BG_money)  from KEHomeBillModel where BG_isIncome = 0 and BG_typeName = \"\(model.typeName!)\" and BG_currentTime like \"\(myTime)%\"", nil) as! NSArray)[0] as! NSDictionary)["SUM(BG_money)"] as! NSNumber).floatValue
                }
                let incomeCount = (((bg_executeSql("select COUNT(BG_money)  from KEHomeBillModel where BG_isIncome = 1 and BG_typeName = \"\(model.typeName!)\" and BG_currentTime like \"\(myTime)%\"", nil) as! NSArray)[0] as! NSDictionary)["COUNT(BG_money)"] as! NSNumber).floatValue
                if incomeCount != 0  {
                    incomeMoney = (((bg_executeSql("select SUM(BG_money)  from KEHomeBillModel where BG_isIncome = 1 and BG_typeName = \"\(model.typeName!)\" and BG_currentTime like \"\(myTime)%\"", nil) as! NSArray)[0] as! NSDictionary)["SUM(BG_money)"] as! NSNumber).floatValue
                }
                array1.append(model.typeName)
                array1.append(model.categoryImageFileName_S)
                array1.append(expendMoney)
                array1.append(incomeMoney)
                topArray.append(array1)
            }
            if (self?.isIncome)!{
                topArray.sort(by: { (num1, num2) in
                    return (num1 as! [Any])[3] as! Float > (num2 as! [Any])[3] as! Float
                })
            }else{
                topArray.sort(by: { (num1, num2) in
                    return (num1 as! [Any])[2] as! Float > (num2 as! [Any])[2] as! Float
                })
            }
            self?.billDetailData.value = [allExpendMoney,allIncomeMoney,array,topArray]
        }).addDisposableTo(disposebag)
        displayYearData.asObservable().skip(1).subscribe(onNext: { [weak self] displayTime in
            //self?.billDetailData.value = bg_executeSql("select * from KEHomeBillModel where  BG_currentTime like \"\(displayTime)%\"", "KEHomeBillModel") as! [KEHomeBillModel]
            var myTime = displayTime
            if myTime == "income"{
                myTime = (self?.displayYearTime)!
                self?.isIncome = true
            }else if myTime == "expend"{
                myTime = (self?.displayYearTime)!
                self?.isIncome = false
            }else{
                self?.displayYearTime = displayTime
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
            var timeList = [String]()
            for i in 0..<12{
                if i<9{
                    timeList.append("\(myTime)-0\(i+1)")
                }else{
                    timeList.append("\(myTime)-\(i+1)")
                }
            }
            var array = [Any]()
            for model in timeList{
                var array1 = [Any]()
                var expendMoney : Float! = 0
                var incomeMoney : Float! = 0
                array1.append(model)
                let expendCount = (((bg_executeSql("select COUNT(BG_money)  from KEHomeBillModel where BG_isIncome = 0 and BG_currentTime like \"\(model)%\"", nil) as! NSArray)[0] as! NSDictionary)["COUNT(BG_money)"] as! NSNumber).floatValue
                if expendCount != 0  {
                    expendMoney = (((bg_executeSql("select SUM(BG_money)  from KEHomeBillModel where BG_isIncome = 0 and BG_currentTime like \"\(model)%\"", nil) as! NSArray)[0] as! NSDictionary)["SUM(BG_money)"] as! NSNumber).floatValue
                }
                let incomeCount = (((bg_executeSql("select COUNT(BG_money)  from KEHomeBillModel where BG_isIncome = 1 and BG_currentTime like \"\(model)%\"", nil) as! NSArray)[0] as! NSDictionary)["COUNT(BG_money)"] as! NSNumber).floatValue
                if incomeCount != 0  {
                    incomeMoney = (((bg_executeSql("select SUM(BG_money)  from KEHomeBillModel where BG_isIncome = 1 and BG_currentTime like \"\(model)%\"", nil) as! NSArray)[0] as! NSDictionary)["SUM(BG_money)"] as! NSNumber).floatValue
                }
                array1.append(expendMoney)
                array1.append(incomeMoney)
                //                let modelArry = bg_executeSql("select * from KEHomeBillModel where  BG_currentTime = \"\(model.currentTime!)\"", "KEHomeBillModel") as! [KEHomeBillModel]
                //                array1.append(modelArry)
                array.append(array1)
            }
            let typeList = bg_executeSql("select distinct BG_typeName, BG_categoryImageFileName_S  from KEHomeBillModel where  BG_currentTime like \"\(myTime)%\" ORDER BY \"BG_currentTime\"  desc", "KEHomeBillModel") as! [KEHomeBillModel]
            
            var topArray = [Any]()
            for model in typeList{
                var array1 = [Any]()
                var expendMoney : Float! = 0
                var incomeMoney : Float! = 0
                let expendCount = (((bg_executeSql("select COUNT(BG_money)  from KEHomeBillModel where BG_isIncome = 0 and BG_typeName = \"\(model.typeName!)\"", nil) as! NSArray)[0] as! NSDictionary)["COUNT(BG_money)"] as! NSNumber).floatValue
                if expendCount != 0  {
                    expendMoney = (((bg_executeSql("select SUM(BG_money)  from KEHomeBillModel where BG_isIncome = 0 and BG_typeName = \"\(model.typeName!)\"", nil) as! NSArray)[0] as! NSDictionary)["SUM(BG_money)"] as! NSNumber).floatValue
                }
                let incomeCount = (((bg_executeSql("select COUNT(BG_money)  from KEHomeBillModel where BG_isIncome = 1 and BG_typeName = \"\(model.typeName!)\"", nil) as! NSArray)[0] as! NSDictionary)["COUNT(BG_money)"] as! NSNumber).floatValue
                if incomeCount != 0  {
                    incomeMoney = (((bg_executeSql("select SUM(BG_money)  from KEHomeBillModel where BG_isIncome = 1 and BG_typeName = \"\(model.typeName!)\"", nil) as! NSArray)[0] as! NSDictionary)["SUM(BG_money)"] as! NSNumber).floatValue
                }
                array1.append(model.typeName)
                array1.append(model.categoryImageFileName_S)
                array1.append(expendMoney)
                array1.append(incomeMoney)
                topArray.append(array1)
            }
            if (self?.isIncome)!{
                topArray.sort(by: { (num1, num2) in
                    return (num1 as! [Any])[3] as! Float > (num2 as! [Any])[3] as! Float
                })
            }else{
                topArray.sort(by: { (num1, num2) in
                    return (num1 as! [Any])[2] as! Float > (num2 as! [Any])[2] as! Float
                })
            }
            
            self?.billDetailData.value = [allExpendMoney,allIncomeMoney,array,topArray]
        }).addDisposableTo(disposebag)
    }

}
