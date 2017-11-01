//
//  KEBillTypeViewModel.swift
//  KETallyBOOK
//
//  Created by 科文 on 09/10/2017.
//  Copyright © 2017 科文. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class KEBillTypeViewModel: KEViewModel {
    /** 分类数据*/
    var categoryData : Variable<[KEBillTypeModel]> = Variable([])
    var categorySelected = Variable<KEBillTypeModel>(.init())
    var detailBill = Variable<KEHomeBillModel>(.init())
    var isIncome : Variable<Bool> = Variable(false)
    var homeDetailViewModel : KEHomeDetailViewModel?
    
    private var selectedModel :KEBillTypeModel?
    private var categoryArry : [KEBillTypeModel]!
    private var expendArry : [KEBillTypeModel]!
    private var incomeArry : [KEBillTypeModel]!
    private var tmpBtn : NSInteger?
    private var itmpBtn : NSInteger?
    var isKind = false
    let disposeBag = DisposeBag()
    
    override init(withServices service: KEViewModelService, params: Dictionary<String, Any>) {
        super.init(withServices: service, params: params)
    }
    
    override func initialize() {

        //categoryData.value = KEBillTypeModel.bg_findAll() as! [KEBillTypeModel]
        
        isIncome.asObservable().subscribe(onNext: {[weak self] income in
            self?.categoryArry = KEBillTypeModel.bg_findWhere( ["isIncome","=",income]) as! [KEBillTypeModel]
            if income{
                self?.incomeArry = self?.categoryArry
            }else{
                self?.expendArry = self?.categoryArry
            }
            self?.categoryData.value = (self?.categoryArry)!
        
        }).addDisposableTo(disposeBag)
        
        categorySelected.asObservable().skip(1).subscribe(onNext: { [weak self] model in
            self?.selectedModel = model
            if model.isIncome{
                if self?.itmpBtn == nil {
                    if self?.tmpBtn == nil {
                    }else{
                        self?.expendArry[(self?.tmpBtn!)!].isSelected = false
                        self?.tmpBtn = nil
                    }
                    self?.incomeArry[model.bg_id.intValue-1-(self?.expendArry.count)!].isSelected = true
                    self?.itmpBtn = model.bg_id.intValue-1-(self?.expendArry.count)!
                    self?.categoryData.value = (self?.incomeArry)!
                }else if self?.itmpBtn != nil && self?.itmpBtn == model.bg_id.intValue-1-(self?.expendArry.count)! {
                    // self.categoryArry[model.bg_id.intValue].isSelected = true
                }else if self?.itmpBtn != nil && self?.itmpBtn != model.bg_id.intValue-1-(self?.expendArry.count)!{
                    self?.incomeArry[(self?.itmpBtn!)!].isSelected = false
                    self?.incomeArry[model.bg_id.intValue-1-(self?.expendArry.count)!].isSelected = true
                    self?.itmpBtn = model.bg_id.intValue-1-(self?.expendArry.count)!
                    self?.categoryData.value = (self?.incomeArry)!
                }
            }else{
                if self?.itmpBtn == nil {
                    
                }else{
                    self?.incomeArry[(self?.itmpBtn!)!].isSelected = false
                    self?.itmpBtn = nil
                }
                if self?.tmpBtn == nil {
                    self?.expendArry[model.bg_id.intValue-1].isSelected = true
                    self?.tmpBtn = model.bg_id.intValue-1
                    self?.categoryData.value = (self?.expendArry)!
                }else if self?.tmpBtn != nil && self?.tmpBtn == model.bg_id.intValue-1 {
                    // self.categoryArry[model.bg_id.intValue].isSelected = true
                }else if self?.tmpBtn != nil && self?.tmpBtn != model.bg_id.intValue-1{
                    self?.expendArry[(self?.tmpBtn!)!].isSelected = false
                    self?.expendArry[model.bg_id.intValue-1].isSelected = true
                    self?.tmpBtn = model.bg_id.intValue-1
                    self?.categoryData.value = (self?.expendArry)!
                }
            }
            
        }).addDisposableTo(disposeBag)
        
        detailBill.asObservable().skip(1).subscribe(onNext: { [weak self] model in
            model.typeName = self?.selectedModel?.categoryName
            model.categoryImageFileName_S = self?.selectedModel?.categoryImageFileName_S
            model.isIncome = (self?.selectedModel?.isIncome)!
            model.bg_save()
        }).addDisposableTo(disposeBag)
        
        
    }
}
