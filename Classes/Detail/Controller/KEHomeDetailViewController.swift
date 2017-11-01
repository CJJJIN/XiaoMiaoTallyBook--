//
//  KEHomeDetailViewController.swift
//  KETallyBOOK
//
//  Created by 科文 on 21/09/2017.
//  Copyright © 2017 科文. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DZNEmptyDataSet


class KEHomeDetailViewController: KEBaseViewController {
    private var headView : KETallyHeadView!
    private var detailTableView : UITableView!
    private var detailBillArry : [KEHomeBillModel]!
    private var viewDateComponents : DateComponents?
    private let disposebag = DisposeBag()
    private var tmpCell : KEBillDetailTableViewCell!
    private var sectionArry :[Any]!
    var curremtTime : [String] = []
    var billDetailViewModel : KEHomeDetailViewModel!{
        get{
            return self.viewModel as! KEHomeDetailViewModel
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bg_setDebug(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        billDetailViewModel.displayTimeData.value = "\( self.headView.dateYearLabel.text ?? curremtTime[0])-\( self.headView.dateButton.titleLabel?.text ?? curremtTime[1])"
        self.detailTableView.reloadData()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        curremtTime = getCurrentTime()
        setupHead()
        detailTableView = UITableView.init(frame: CGRect.init(x: 0, y: 70, width: self.view.bounds.size.width, height: self.view.bounds.size.height-70-64-50)).then{
            $0.rowHeight = 55 
            $0.delegate = self
            $0.dataSource = self
            $0.separatorInset = UIEdgeInsets.init(top: 0, left: 1000, bottom: 0, right: 0)
            $0.register(UINib.init(nibName: "KEBillDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "BillDetailTableViewCellID")
            $0.mj_header = WKCustomeRefreshHeader(refreshingBlock: { [weak self] in
                self?.detailTableView.mj_header.endRefreshing()
                if Int((self?.headView.dateButton.titleLabel?.text)!)!-1 < 10 && Int((self?.headView.dateButton.titleLabel?.text)!)!-1 > 0 {
                    self?.billDetailViewModel.displayTimeData.value = "\(self?.headView.dateYearLabel.text ?? "2017")-0\(Int((self?.headView.dateButton.titleLabel?.text)!)! - 1)"
                    self?.headView.dateButton.setTitle("0\(String.init(describing: Int((self?.headView.dateButton.titleLabel?.text)!)! - 1))", for: .normal)
                }else if Int((self?.headView.dateButton.titleLabel?.text)!)!-1 >= 10{
                    self?.billDetailViewModel.displayTimeData.value = "\(self?.headView.dateYearLabel.text ?? "2017")-\(Int((self?.headView.dateButton.titleLabel?.text)!)! - 1)"
                    self?.headView.dateButton.setTitle(String.init(describing: Int((self?.headView.dateButton.titleLabel?.text)!)! - 1), for: .normal)
                }else{
                    
                }
                self?.detailTableView.reloadData()
            })
            $0.mj_footer = WKCustomeRefreshFotoer(refreshingBlock: { [weak self] in
                self?.detailTableView.mj_footer.endRefreshing()
                if Int((self?.headView.dateButton.titleLabel?.text)!)!+1 < 10 {
                    self?.billDetailViewModel.displayTimeData.value = "\(self?.headView.dateYearLabel.text ?? "2017")-0\(Int((self?.headView.dateButton.titleLabel?.text)!)! + 1)"
                    self?.headView.dateButton.setTitle("0\(String.init(describing: Int((self?.headView.dateButton.titleLabel?.text)!)! + 1))", for: .normal)
                }else if Int((self?.headView.dateButton.titleLabel?.text)!)!+1 < 13{
                    self?.billDetailViewModel.displayTimeData.value = "\(self?.headView.dateYearLabel.text ?? "2017")-\(Int((self?.headView.dateButton.titleLabel?.text)!)! + 1)"
                    self?.headView.dateButton.setTitle(String.init(describing: Int((self?.headView.dateButton.titleLabel?.text)!)! + 1), for: .normal)
                }else{
                    
                }
                self?.detailTableView.reloadData()
            })
            
        }
        self.view.addSubview(detailTableView)
        
        //billDetailViewModel.displayTimeData.value = String.init(format: "\(curremtTime[0])-\(curremtTime[1])")
        billDetailViewModel.billDetailData.asObservable().skip(1).subscribe(onNext: { [weak self] billDetailArry in
            self?.sectionArry = billDetailArry[2] as! [Any]
            self?.headView.expendNumber.text = String.init(describing: billDetailArry[0])
            self?.headView.incomeNumber.text = String.init(describing: billDetailArry[1])
            
        }).addDisposableTo(disposebag)
    }
}

extension KEHomeDetailViewController {

    private func setupHead() {
        headView = KETallyHeadView().then{
            $0.dateAction = {
                let datePicker = PGDatePicker.init()
                datePicker.delegate = self
                datePicker.datePickerMode = .yearAndMonth
                datePicker.maximumDate = NSDate.setYear(2020)
                datePicker.minimumDate = NSDate.setYear(2010)
                datePicker.show()
                datePicker.titleLabel.text = "请选择时间"
                datePicker.titleLabel.textColor = UIColor.black
                datePicker.lineBackgroundColor = UIColor.lightGray
                datePicker.titleColorForSelectedRow = UIColor.black
                datePicker.cancelButton.setTitleColor(UIColor.black, for: .normal)
                datePicker.confirmButton.setTitleColor(UIColor.black, for: .normal)
                if self.viewDateComponents != nil{
                    datePicker.setDate(NSDate.setYear(UInt.init(bitPattern:(self.viewDateComponents?.year)!), month: UInt.init(bitPattern:(self.viewDateComponents?.month)!)), animated: true)
                }
            }
            $0.frame = CGRect.init(x: 0, y: 0, width: 375, height: 70)
            $0.dateYearLabel.text = String.init(format: "\(curremtTime[0])")
            $0.dateButton.setTitle(curremtTime[1], for: .normal)
        }
        self.view.addSubview(headView)
    }
    private func setupTableView() {
        detailTableView = UITableView(frame: self.view.bounds, style: .plain).then {
            $0.tableFooterView = UIView()
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
    
    private func dateFomartString(str:String) -> String{
        let strArry = str.split(separator: "-")
        return "\(strArry[1])月\(strArry[2])日"
    }
}
extension KEHomeDetailViewController:PGDatePickerDelegate {
    
    func datePicker(_ datePicker: PGDatePicker!, didSelectDate dateComponents: DateComponents!) {
        viewDateComponents = dateComponents
        if datePicker.datePickerMode == PGDatePickerMode.yearAndMonth {
            headView.dateYearLabel.text = String.init(format: "\( dateComponents.year!)")
            if dateComponents.month! >= 10 {
                headView.dateButton.setTitle(String.init(format: "\( dateComponents.month!)"), for: .normal)
                billDetailViewModel.displayTimeData.value = String.init(format: "\(dateComponents.year!)-\(dateComponents.month!)")
            }else{
                headView.dateButton.setTitle(String.init(format: "0\( dateComponents.month!)"), for: .normal)
                billDetailViewModel.displayTimeData.value = String.init(format: "\(dateComponents.year!)-0\(dateComponents.month!)")
            }
            self.detailTableView.reloadData()
        }else{
            tmpCell.monyField.becomeFirstResponder()
            if dateComponents.month! < 10 {
                if dateComponents.day! < 10 {
                     tmpCell.monyField.acButton.setTitle(String.init(format: "\( dateComponents.year!)-0\( dateComponents.month!)-0\( dateComponents.day!)"), for: .normal)
                }else{
                     tmpCell.monyField.acButton.setTitle(String.init(format: "\( dateComponents.year!)-0\( dateComponents.month!)-\( dateComponents.day!)"), for: .normal)
                }
            }else{
                if dateComponents.day! < 10 {
                     tmpCell.monyField.acButton.setTitle(String.init(format: "\( dateComponents.year!)-\( dateComponents.month!)-0\( dateComponents.day!)"), for: .normal)
                }else{
                     tmpCell.monyField.acButton.setTitle(String.init(format: "\( dateComponents.year!)-\( dateComponents.month!)-\( dateComponents.day!)"), for: .normal)
                }
            }
             tmpCell.monyField.acButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        }
        
    }
}

extension KEHomeDetailViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arry = (sectionArry[section] as! [Any])[3] as! [Any]
        return arry.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BillDetailTableViewCellID", for: indexPath) as! KEBillDetailTableViewCell
        let detailBillModel = ((sectionArry[indexPath.section] as! [Any])[3] as! [KEHomeBillModel])[indexPath.row]
        cell.model = detailBillModel
        cell.titleName.returnKeyType = .done
        cell.titleName.delegate = self
        cell.viewModel = billDetailViewModel
        cell.monyField.acButton.setTitle(detailBillModel.currentTime, for: .normal)
        cell.monyField.acButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.monyField.okBtnAction = {
            let detailBill = KEHomeBillModel()
            if cell.monyField.text != "0.00"{
                detailBill.money = cell.monyField.text
                if cell.monyField.acButton.titleLabel?.text == "今天"{
                    detailBill.currentTime = String.init(format: "\(self.getCurrentTime()[0])-\(self.getCurrentTime()[1])-\(self.getCurrentTime()[2])")
                }else{
                    detailBill.currentTime = cell.monyField.acButton.titleLabel?.text
                }
                detailBill.remark = detailBillModel.remark
                detailBill.isIncome = detailBillModel.isIncome
                detailBill.typeName = detailBillModel.typeName
                detailBill.categoryImageFileName_S = detailBillModel.categoryImageFileName_S
                detailBill.bg_id = detailBillModel.bg_id
                detailBill.bg_createTime = detailBillModel.bg_createTime
                self.billDetailViewModel.updateData.value = detailBill
                cell.monyField.resignFirstResponder()
                self.detailTableView.reloadData()
            }
        }
         cell.monyField.dateBtnAction = {
            let datePicker = PGDatePicker.init()
            datePicker.datePickerMode = PGDatePickerMode.date
            datePicker.maximumDate = NSDate.setYear(2020, month: 12, day: 30)
            datePicker.minimumDate = NSDate.setYear(2010, month: 1, day: 1)
            datePicker.show()
            self.tmpCell = cell
            datePicker.titleLabel.text = "请选择时间"
            datePicker.delegate = self
            datePicker.titleLabel.textColor = UIColor.black
            datePicker.lineBackgroundColor = UIColor.lightGray
            //datePicker.isDisMissWhenTouchOther = false
            datePicker.titleColorForSelectedRow = UIColor.black
            datePicker.cancelButton.setTitleColor(UIColor.black, for: .normal)
            datePicker.confirmButton.setTitleColor(UIColor.black, for: .normal)
            datePicker.cancelButton.rx.tap.subscribe(onNext:{
                cell.monyField.becomeFirstResponder()
            }).addDisposableTo((self.disposebag))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let time = (sectionArry[section] as! [Any])[0] as! String
        let fomartWeek = dateFomartString(str:time)
        let week = KECustomTool.weekdayString(fromDate: time)
        let zero = String.init(describing: (sectionArry[section] as! [Any])[1]).split(separator: ".")
        let zeroStr = String.init(describing: zero[1])
        var expendLabelText = ""
        if  zeroStr == "00" || zeroStr == "0"{
            expendLabelText =  String.init(describing:zero[0])
        }else{
            expendLabelText = String.init(describing: (sectionArry[section] as! [Any])[1])
        }
        var incomeLabelText = ""
        
        let zero2 = String.init(describing: (sectionArry[section] as! [Any])[2]).split(separator: ".")
        let zeroStr2 = String.init(describing: zero2[1])
        if  zeroStr2 == "00" || zeroStr2 == "0"{
            incomeLabelText =  String.init(describing:zero2[0])
        }else{
            incomeLabelText = String.init(describing: (sectionArry[section] as! [Any])[2])
        }
        var eiLabelText = ""
        if incomeLabelText == "0" {
            eiLabelText = "支出：\(expendLabelText)"
        }else if expendLabelText == "0"{
            eiLabelText = "收入：\(incomeLabelText)"
        }else{
            eiLabelText = "支出：\(expendLabelText) 收入：\(incomeLabelText)"
        }
        
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 40)).then{
            $0.backgroundColor = UIColor.init(red: 247/255, green: 247/255, blue: 247/255, alpha: 247/255)
            let timeLabel = UILabel.init(frame: CGRect.init(x: 10, y: 5, width: 60, height: 20)).then{
                $0.backgroundColor = .clear
                $0.font = UIFont.systemFont(ofSize: 12)
                $0.textColor = UIColor.darkText
                $0.text = fomartWeek
            }
            $0.addSubview(timeLabel)
            let weekLabel = UILabel.init(frame: CGRect.init(x: 70, y: 5, width: 50, height: 20)).then{

                $0.backgroundColor = .clear
                $0.font = UIFont.systemFont(ofSize: 12)
                $0.textColor = UIColor.darkText
                $0.text = week
            }
            $0.addSubview(weekLabel)
            let eiLabel = UILabel.init(frame: CGRect.init(x: 200, y: 5, width: 170, height: 20)).then{
                $0.backgroundColor = .clear
                $0.font = UIFont.systemFont(ofSize: 12)
                $0.textColor = UIColor.darkText
                $0.text = eiLabelText
                $0.textAlignment = .right
            }
            $0.addSubview(eiLabel)
            
        }
        
        return view
    }
    
    //返回编辑类型，滑动删除
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    //在这里修改删除按钮的文字
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    //点击删除按钮的响应方法，在这里处理删除的逻辑
    internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            if ((sectionArry[indexPath.section] as! [Any])[3] as! [KEHomeBillModel]).count == 1 {
                self.billDetailViewModel.deleteData.value = ((sectionArry[indexPath.section] as! [Any])[3] as! [KEHomeBillModel])[indexPath.row]
                self.detailTableView!.deleteSections(IndexSet.init(integer: indexPath.section), with: UITableViewRowAnimation.left)
            }else{
                self.billDetailViewModel.deleteData.value = ((sectionArry[indexPath.section] as! [Any])[3] as! [KEHomeBillModel])[indexPath.row]
                self.detailTableView!.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            }
             self.detailTableView.reloadData()
        }
    }
    
}
extension KEHomeDetailViewController: DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{

}
extension KEHomeDetailViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let cell = textField.superviewOfClassType(KEBillDetailTableViewCell.self) as! KEBillDetailTableViewCell
        let detailBill = KEHomeBillModel()
        detailBill.remark = textField.text
        detailBill.money = cell.model?.money
        detailBill.isIncome = (cell.model?.isIncome)!
        detailBill.typeName = cell.model?.typeName
        detailBill.categoryImageFileName_S = cell.model?.categoryImageFileName_S
        detailBill.bg_id = (cell.model?.bg_id)!
        detailBill.bg_createTime = (cell.model?.bg_createTime)!
        self.billDetailViewModel.updateData.value = detailBill
        textField.resignFirstResponder()
        self.detailTableView.reloadData()
        return true
    }
}
