//
//  KETallyHeadView.swift
//  KETallyBOOK
//
//  Created by 科文 on 25/09/2017.
//  Copyright © 2017 科文. All rights reserved.
//

import UIKit
import RxSwift
import Then
import SnapKit

import RxCocoa

class KETallyHeadView: UIView {
    
    public var dateButton : UIButton!
    private var dateLabel : UILabel!
     private var dateLabelNian : UILabel!
    public var dateYearLabel : UILabel!
    private var expendLabel : UILabel!  //支出
    public var expendNumber : UILabel!  //支出数
    private var incomeLabel : UILabel!  //收入
    public var incomeNumber : UILabel!  //收入数
    typealias ActionBlock = () -> Void
    var dateAction : ActionBlock?
    private let disposebag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI(){
        self.backgroundColor = UIColor.white
        dateButton = UIButton().then{
            $0.setTitle("09", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.rx.tap.subscribe(onNext: {[weak self] _ in
                if let action = self?.dateAction{
                    action()
                }
            }).addDisposableTo(disposebag)
        }
        self.addSubview(dateButton)
        dateLabel = UILabel().then{
            $0.text = "月 ▼"
            $0.font = UIFont.systemFont(ofSize: 10)
        }
        self.addSubview(dateLabel)
        dateLabelNian = UILabel().then{
            $0.text = "年"
            $0.font = UIFont.systemFont(ofSize: 11)
        }
        self.addSubview(dateLabelNian)
        dateYearLabel = UILabel().then{
            $0.text =  "2017年"
            $0.font = UIFont.systemFont(ofSize: 11)
            $0.textAlignment = .center
        }
        self.addSubview(dateYearLabel)
        expendLabel = UILabel().then{
            $0.text = "支出（元）"
            $0.font = UIFont.systemFont(ofSize: 13)
        }
        self.addSubview(expendLabel)
        incomeLabel = UILabel().then{
            $0.text = "收入（元）"
            $0.font = UIFont.systemFont(ofSize: 13)
        }
        self.addSubview(incomeLabel)
        expendNumber = UILabel().then{
            $0.text = "5000"
            $0.font = UIFont.systemFont(ofSize: 16)
        }
        self.addSubview(expendNumber)
        incomeNumber = UILabel().then{
            $0.text = "1000"
            $0.font = UIFont.systemFont(ofSize: 16)
        }
        self.addSubview(incomeNumber)
        
        dateYearLabel.snp.makeConstraints{(make) in
            make.centerX.equalTo(dateButton.snp.centerX)
            make.top.equalTo(self.snp.top).offset(10)
            make.width.equalTo(50)
            make.height.equalTo(10)
        }
        dateLabelNian.snp.makeConstraints{(make) in
            make.top.equalTo(self.snp.top).offset(10)
            make.left.equalTo(55)
            make.width.equalTo(50)
            make.height.equalTo(10)
        }
        dateLabel.snp.makeConstraints{(make) in
            make.left.equalTo(self.snp.left).offset(50)
            make.top.equalTo(self.snp.top).offset(20)
            make.bottom.equalTo(self.snp.bottom).offset(-10)
            make.width.equalTo(30)
        }
        
        dateButton.snp.makeConstraints{ (make) in
            make.left.equalTo(self.snp.left).offset(0)
            make.top.equalTo(self.snp.top).offset(0)
            make.bottom.equalTo(self.snp.bottom).offset(0)
            make.width.equalTo(80)
        }
        
        expendLabel.snp.makeConstraints{ (make) in
            make.right.equalTo(incomeLabel.snp.left).offset(-20)
            make.top.equalTo(self.snp.top).offset(10)
            make.bottom.equalTo(self.snp.bottom).offset(-40)
            make.width.equalTo(100)
        }
        
        incomeLabel.snp.makeConstraints{ (make) in
            make.right.equalTo(self.snp.right).offset(-20)
            make.top.equalTo(self.snp.top).offset(10)
            make.bottom.equalTo(self.snp.bottom).offset(-40)
            make.width.equalTo(100)
        }
        
        expendNumber.snp.makeConstraints{ (make) in
            make.centerX.equalTo(expendLabel.snp.centerX)
            make.top.equalTo(expendLabel.snp.top).offset(5)
            make.bottom.equalTo(self.snp.bottom).offset(-5)
            make.width.equalTo(100)
        }
        
        incomeNumber.snp.makeConstraints{ (make) in
            make.centerX.equalTo(incomeLabel.snp.centerX)
            make.top.equalTo(expendLabel.snp.top).offset(5)
            make.bottom.equalTo(self.snp.bottom).offset(-5)
            make.width.equalTo(100)
        }
    }

    
}
