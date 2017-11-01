//
//  KEChargeUpViewController.swift
//  KETallyBOOK
//
//  Created by 科文 on 28/09/2017.
//  Copyright © 2017 科文. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class KEChargeUpViewController: KEBaseViewController {

    private var collectionView : UICollectionView!
    private var titleBtn : UIButton!
    private var titleItems : Array<Any>!
    private let disposebag = DisposeBag()
    private var categoryArry : [KEBillTypeModel]!
    private var isExpend = true
    private var remarkView : UIView!
    private var moneyTextField : GATextField!
    private var remarkTextField : UITextField!
    var billTypeViewModel : KEBillTypeViewModel!{
        get{
           return self.viewModel as! KEBillTypeViewModel
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .all
        setNavigationTitleView()
        setRemarkView()

        
        //categoryArry = KEBillTypeModel.bg_findAll()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func bindViewModel() {
        super.bindViewModel()
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width:50,height:70)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets.init(top: 24, left: 29, bottom: 24, right: 29)
        collectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout:layout).then{
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = .white
            $0.register(UINib.init(nibName: "KECategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionCellID")
        }
        self.view.addSubview(collectionView)
        billTypeViewModel?.categoryData.asObservable().subscribe(onNext:{
            [weak self] categoryData in
                self?.categoryArry = categoryData
                self?.collectionView.reloadData()
        }).addDisposableTo(disposebag)
        billTypeViewModel?.categorySelected.asObservable().skip(1).subscribe(onNext: { [weak self] _ in
            self?.remarkView.isHidden = false
            self?.moneyTextField.becomeFirstResponder()
            self?.moneyTextField.okBtnAction = {
                let detailBill = KEHomeBillModel()
                if self?.moneyTextField.text != "0.00"{
                    detailBill.money = self?.moneyTextField.text
                    if self?.moneyTextField.acButton.titleLabel?.text == "今天"{
                        detailBill.currentTime = String.init(format: "\(getCurrentTime()[0])-\(getCurrentTime()[1])-\(getCurrentTime()[2])")
                    }else{
                        detailBill.currentTime = self?.moneyTextField.acButton.titleLabel?.text
                    }
                    detailBill.remark = self?.remarkTextField.text
                    
                    self?.billTypeViewModel.detailBill.value = detailBill
                    self?.moneyTextField.resignFirstResponder()
                    self?.navigationController?.dismiss(animated: true, completion: nil)
                }
            }
            self?.moneyTextField.dateBtnAction = {
                let datePicker = PGDatePicker.init()
                datePicker.datePickerMode = PGDatePickerMode.date
                datePicker.maximumDate = NSDate.setYear(2020, month: 12, day: 30)
                datePicker.minimumDate = NSDate.setYear(2010, month: 1, day: 1)
                datePicker.show()
                datePicker.titleLabel.text = "请选择时间"
                datePicker.delegate = self
                datePicker.titleLabel.textColor = UIColor.black
                datePicker.lineBackgroundColor = UIColor.lightGray
                datePicker.isDisMissWhenTouchOther = false
                datePicker.titleColorForSelectedRow = UIColor.black
                datePicker.cancelButton.setTitleColor(UIColor.black, for: .normal)
                datePicker.confirmButton.setTitleColor(UIColor.black, for: .normal)
                datePicker.cancelButton.rx.tap.subscribe(onNext:{
                    self?.moneyTextField.becomeFirstResponder()
                }).addDisposableTo((self?.disposebag)!)
            }
            
            self?.collectionView.frame.size.height = (self?.view.bounds.size.height)! * 0.6;
        }).addDisposableTo(disposebag)
    }
}

extension KEChargeUpViewController {
    private func setRemarkView(){
        remarkView = UIView.init(frame: CGRect.init(x: 0, y: self.view.bounds.size.height * 0.6, width: self.view.bounds.size.width, height: self.view.bounds.size.height * 0.08))
        remarkView.backgroundColor = .white
        self.view.addSubview(remarkView)
        remarkView.isHidden = true

        let markLabel = UILabel().then{
            $0.frame = CGRect.init(x: 0, y: 0, width: remarkView.frame.size.width * 0.2, height: remarkView.frame.size.height)
            $0.text = "备注："
            $0.font = UIFont.systemFont(ofSize: 18)
            $0.textAlignment = .center
            
        }
        remarkView.addSubview(markLabel)
        remarkTextField = UITextField.init(frame: CGRect.init(x: remarkView.frame.size.width*0.2, y: 0, width: remarkView.frame.size.width * 0.4, height: remarkView.frame.size.height))
        remarkTextField.returnKeyType = .done
        remarkTextField.delegate = self
        remarkView.addSubview(remarkTextField)
        moneyTextField = GATextField().then{
            $0.frame = CGRect.init(x: remarkView.frame.size.width*0.6, y: 0, width: remarkView.frame.size.width * 0.4 - 20, height: remarkView.frame.size.height)
            $0.headString = "¥"
            $0.font = UIFont.systemFont(ofSize: 18)
            $0.textAlignment = .right
            $0.tintColor = .clear
            $0.ga_delegate = self
        }
        remarkView.addSubview(moneyTextField)
    }
    
    private func setTitleBtn(){
        if isExpend {
            let expendTitle : YCXMenuItem = YCXMenuItem("支出                      ✔︎", image: UIImage.init(named: "ic_expenses.png"), target:self, action:#selector(selectExpendTitle))
            expendTitle.foreColor = .black
            expendTitle.alignment = .left
            expendTitle.titleFont = UIFont.boldSystemFont(ofSize: 17.0)
            let incomeTitle : YCXMenuItem = YCXMenuItem("收入  ", image: UIImage.init(named: "ic_income.png"), target:self, action:#selector(selectIncomeTitle))
            incomeTitle.foreColor = .black
            incomeTitle.alignment = .left
            incomeTitle.titleFont = UIFont.boldSystemFont(ofSize: 17.0)
            titleItems = [expendTitle,incomeTitle]
        }else{
            let expendTitle : YCXMenuItem = YCXMenuItem("支出  ", image: UIImage.init(named: "ic_expenses.png"), target:self, action:#selector(selectExpendTitle))
            expendTitle.foreColor = .black
            expendTitle.alignment = .left
            expendTitle.titleFont = UIFont.boldSystemFont(ofSize: 17.0)
            let incomeTitle : YCXMenuItem = YCXMenuItem("收入                      ✔︎", image: UIImage.init(named: "ic_income.png"), target:self, action:#selector(selectIncomeTitle))
            incomeTitle.foreColor = .black
            incomeTitle.alignment = .left
            incomeTitle.titleFont = UIFont.boldSystemFont(ofSize: 17.0)
            titleItems = [expendTitle,incomeTitle]
        }
        
    }
    
    @objc func selectExpendTitle(){
        self.isExpend = true
        self.billTypeViewModel.isIncome.value = false
        self.remarkView.isHidden = true
        self.collectionView.frame.size.height = self.view.bounds.size.height
        self.moneyTextField.resignFirstResponder()
    }
    @objc func selectIncomeTitle(){
        self.isExpend = false
        self.billTypeViewModel.isIncome.value = true
        self.remarkView.isHidden = true
        self.collectionView.frame.size.height = self.view.bounds.size.height
        self.moneyTextField.resignFirstResponder()
    }
    
    private func setNavigationTitleView(){
        setTitleBtn()
        titleBtn = UIButton().then{
            if isExpend {
                $0.setTitle("支出 ▼", for: .normal)
            }else{
                $0.setTitle("收入 ▼", for: .normal)
            }
            $0.setTitleColor(UIColor.black, for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
            $0.frame = CGRect.init(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 20, height: 20))
            $0.rx.tap.subscribe(onNext:{
                YCXMenu.setHasShadow(false)
                YCXMenu.setTintColor(UIColor.init(red: 246/255, green: 246/255, blue: 246/255, alpha: 1))
                YCXMenu.setSelectedColor(UIColor.lightGray)
                YCXMenu.show(in: self.view, from: CGRect.init(x: self.view.center.x , y:64.0 , width: 0.0, height: 0.0), menuItems: self.titleItems, selected: {
                    (index,item) in
                    if index == 0{
                       
                        self.setTitleBtn()
                        self.selectTitle()
                    }else{
                        
                        self.setTitleBtn()
                        self.selectTitle()
                    }
                })
            }).addDisposableTo(disposebag)
        }
        self.navigationItem.titleView = titleBtn
        let cancelBtn = UIButton().then{
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
            $0.setTitleColor(UIColor.black, for: .normal)
            $0.setTitle("取消", for: .normal)
            $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            $0.sizeToFit()
            $0.rx.tap.subscribe(onNext:{
                self.moneyTextField.resignFirstResponder()
                self.navigationController?.dismiss(animated: true, completion: nil)
            }).addDisposableTo(disposebag)
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: cancelBtn)
    }
    
    
    @objc private func selectTitle(){
        if isExpend {
            self.titleBtn.setTitle("支出 ▼", for: .normal)
        }else{
            self.titleBtn.setTitle("收入 ▼", for: .normal)
        }
    }
}

extension KEChargeUpViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArry.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionCellID", for: indexPath) as! KECategoryCollectionViewCell
        let billType = categoryArry[indexPath.item]
        cell.viewModel = self.billTypeViewModel
        cell.model = billType
        return cell
        
    }
}
extension KEChargeUpViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        moneyTextField.becomeFirstResponder()
        return true
    }
}
extension KEChargeUpViewController : GATextFieldDelegate{
    
}
extension KEChargeUpViewController:PGDatePickerDelegate {
    
    func datePicker(_ datePicker: PGDatePicker!, didSelectDate dateComponents: DateComponents!) {
        self.moneyTextField.becomeFirstResponder()
        if dateComponents.month! < 10 {
            if dateComponents.day! < 10 {
                self.moneyTextField.acButton.setTitle(String.init(format: "\( dateComponents.year!)-0\( dateComponents.month!)-0\( dateComponents.day!)"), for: .normal)
            }else{
                self.moneyTextField.acButton.setTitle(String.init(format: "\( dateComponents.year!)-0\( dateComponents.month!)-\( dateComponents.day!)"), for: .normal)
            }
        }else{
            if dateComponents.day! < 10 {
                self.moneyTextField.acButton.setTitle(String.init(format: "\( dateComponents.year!)-\( dateComponents.month!)-0\( dateComponents.day!)"), for: .normal)
            }else{
                self.moneyTextField.acButton.setTitle(String.init(format: "\( dateComponents.year!)-\( dateComponents.month!)-\( dateComponents.day!)"), for: .normal)
            }
        }
        self.moneyTextField.acButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    }
}
private func getCurrentTime() -> [String] {
    var timers: [String] = [] //  返回的数组
    
    let calendar: Calendar = Calendar(identifier: .gregorian)
    var comps: DateComponents = DateComponents()
    comps = calendar.dateComponents([.year,.month,.day, .weekday, .hour, .minute,.second], from: Date())
    
    timers.append(String.init(describing: comps.year!))  // 年 ，后2位数
    timers.append(String.init(describing: comps.month!))         // 月
    timers.append(String.init(describing: comps.day!))                // 日
    timers.append(String.init(describing: comps.hour!))               // 小时
    timers.append(String.init(describing: comps.minute!))            // 分钟
    timers.append(String.init(describing: comps.second!))            // 秒
    timers.append(String.init(describing: comps.weekday! - 1))      //星期
    return timers
}


