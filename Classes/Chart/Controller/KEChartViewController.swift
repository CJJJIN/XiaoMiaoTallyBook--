//
//  KEChartViewController.swift
//  KETallyBOOK
//
//  Created by 科文 on 17/10/2017.
//  Copyright © 2017 科文. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class KEChartViewController: KEBaseViewController {
    private var titleBtn : UIButton!
    private let disposebag = DisposeBag()
    private var titleItems : Array<Any>!
    private var tableView : UITableView!
    private var isExpend = true
    private var isMouth = true
    private var sectionArry :[Any]!
    private var topArry : Array<Any>!
    private var allExpend : Float!
    private var allIncome : Float!
    var myView : KEChartView!
    var curremtTime : [String] = []
    
    var dateLabel : UILabel!
    var yearLabel : UILabel!
    var titleLabel: UILabel!
    var chartViewModel : KEChartViewModel!{
        get{
            return self.viewModel as! KEChartViewModel
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitleView()
        setHeadView()
        myView = KEChartView.init(frame: CGRect.init(x: 0, y: 120, width: kScreenWidth, height: 160))
        self.view.addSubview(myView)
        let titleView = UIView.init(frame: CGRect.init(x: 0, y: 80, width: kScreenWidth, height: 40)).then{
            titleLabel = UILabel.init(frame: CGRect.init(x: 10, y: 5, width: 150, height: 30)).then{
                $0.backgroundColor = .clear
                $0.font = UIFont.systemFont(ofSize: 16)
                $0.textColor = UIColor.darkText
                $0.text = "总收入：0.00元"
                $0.textAlignment = .left
            }
            $0.addSubview(titleLabel)
        }
       self.view.addSubview(titleView)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        if isMouth {
            chartViewModel.displayTimeData.value = "\( self.dateLabel.text ?? curremtTime[0])"
        }else{
            chartViewModel.displayYearData.value =  yearLabel.text!
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    override func bindViewModel() {
        curremtTime = getCurrentTime()
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: 280, width: self.view.bounds.size.width, height: self.view.bounds.size.height-390)).then{
            $0.rowHeight = 55
            $0.delegate = self
            $0.dataSource = self
            $0.separatorInset = UIEdgeInsets.init(top: 0, left: 1000, bottom: 0, right: 0)
            $0.register(UINib.init(nibName: "KEChartTopTableViewCell", bundle: nil), forCellReuseIdentifier: "ChartTopTableViewCellID")
        }
        self.view.addSubview(tableView)
        
        chartViewModel.billDetailData.asObservable().skip(1).subscribe(onNext: { [weak self] billDetailArry in
            self?.sectionArry = billDetailArry[2] as! [Any]
            self?.topArry = billDetailArry[3] as! [Any]
            self?.allExpend = billDetailArry[0] as! Float
            self?.allIncome = billDetailArry[1] as! Float
            if (self?.isExpend)!{
                self?.titleLabel.text = "总支出：\(self?.allExpend ?? 0.00)"
            }else{
                self?.titleLabel.text = "总收入：\(self?.allIncome ?? 0.00)"
            }
            
            self?.setChartView()
            self?.tableView.reloadData()
        }).addDisposableTo(disposebag)
    }
}


extension KEChartViewController{
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
        if isMouth {
            chartViewModel.displayTimeData.value = "expend"
        }else{
            chartViewModel.displayYearData.value = "expend"
        }
        
    }
    @objc func selectIncomeTitle(){
        self.isExpend = false
        if isMouth {
            chartViewModel.displayTimeData.value = "income"
        }else{
            chartViewModel.displayYearData.value = "income"
        }
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
                YCXMenu.show(in: self.view, from: CGRect.init(x: self.view.center.x , y:40.0 , width: 0.0, height: 0.0), menuItems: self.titleItems, selected: {
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
        let navigationSubView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 40)).then{
            let segmented = UISegmentedControl().then{
                $0.frame = CGRect(x:10,y:0,width:kScreenWidth-20,height:30)
                $0.insertSegment(withTitle: "月", at: 0, animated: true)
                $0.insertSegment(withTitle: "年", at: 1, animated: true)
                $0.selectedSegmentIndex = 0
                $0.tintColor = .darkText
                $0.addTarget(self, action:#selector(self.didSelect(segmented:)), for: UIControlEvents.valueChanged)
            }
            $0.backgroundColor = UIColor.init(red: 254/255, green: 217/255, blue: 83/255, alpha: 1)
            $0.addSubview(segmented)
        }
        self.view.addSubview(navigationSubView)
    }
    @objc private func selectTitle(){
        if isExpend {
            self.titleBtn.setTitle("支出 ▼", for: .normal)
        }else{
            self.titleBtn.setTitle("收入 ▼", for: .normal)
        }
    }
    @objc func didSelect(segmented:UISegmentedControl){
//        let date = self.dateLabel.text?.split(separator: "-")
//        let year = String.init(describing: date![0])
        switch segmented.selectedSegmentIndex
        {
            
        case 0:
            isMouth = true
            yearLabel.isHidden = true
            dateLabel.isHidden = false
            chartViewModel.displayTimeData.value = "\( self.dateLabel.text ?? curremtTime[0])"
        case 1:
            
            isMouth = false
            yearLabel.isHidden = false
            dateLabel.isHidden = true
            chartViewModel.displayYearData.value =  yearLabel.text!
        default:
            print("未知")
        }
    }
    func setHeadView() {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 40, width: kScreenWidth, height: 40)).then{
            $0.backgroundColor = UIColor.init(red: 247/255, green: 247/255, blue: 247/255, alpha: 247/255)
            let upButton = UIButton.init(frame:CGRect.init(x: 5, y: 5, width: 50, height: 30) ).then{
                $0.setTitle("◀︎", for: .normal)
                $0.setTitleColor(.black, for: .normal)
                $0.rx.tap.subscribe(onNext: {[weak self] _ in
                    if (self?.isMouth)! {
                        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
                        let last = calendar?.date(byAdding: NSCalendar.Unit.month, value: -1, to: KECustomTool.dateFromeString((self?.dateLabel.text))  as Date, options: NSCalendar.Options(rawValue: 0))
                        self?.dateLabel.text = self?.stringFromDate(date: (last! as NSDate))
                        self?.chartViewModel.displayTimeData.value = (self?.dateLabel.text)!
                    }else{
                        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
                        let last = calendar?.date(byAdding: NSCalendar.Unit.year, value: -1, to: KECustomTool.yearFromeString((self?.yearLabel.text))  as Date, options: NSCalendar.Options(rawValue: 0))
                        self?.yearLabel.text = self?.stringFromYear(date: (last! as NSDate))
                        self?.chartViewModel.displayYearData.value = (self?.yearLabel.text)!
                    }
                }).addDisposableTo(disposebag)
            }
            $0.addSubview(upButton)
            let nextButton = UIButton.init(frame:CGRect.init(x: kScreenWidth-55, y: 5, width: 50, height: 30) ).then{
                $0.setTitle("▶︎", for: .normal)
                $0.setTitleColor(.black, for: .normal)
                $0.rx.tap.subscribe(onNext: {[weak self] _ in

                    if (self?.isMouth)! {
                        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
                        let last = calendar?.date(byAdding: NSCalendar.Unit.month, value: +1, to: KECustomTool.dateFromeString((self?.dateLabel.text))  as Date, options: NSCalendar.Options(rawValue: 0))
                        self?.dateLabel.text = self?.stringFromDate(date: (last! as NSDate))
                        self?.chartViewModel.displayTimeData.value = (self?.dateLabel.text)!
                    }else{
                        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
                        let last = calendar?.date(byAdding: NSCalendar.Unit.year, value: +1, to: KECustomTool.yearFromeString((self?.yearLabel.text))  as Date, options: NSCalendar.Options(rawValue: 0))
                        self?.yearLabel.text = self?.stringFromYear(date: (last! as NSDate))
                        self?.chartViewModel.displayYearData.value = (self?.yearLabel.text)!
                    }
                    
                }).addDisposableTo(disposebag)
            }
            $0.addSubview(nextButton)
            dateLabel = UILabel.init(frame: CGRect.init(x: 0, y: 5, width: 150, height: 30)).then{
                $0.backgroundColor = .clear
                $0.center.x = kScreenWidth/2
                $0.font = UIFont.systemFont(ofSize: 12)
                $0.textColor = UIColor.darkText
                $0.text = "\(curremtTime[0])-\(curremtTime[1])"
                $0.textAlignment = .center
            }
            yearLabel = UILabel.init(frame: CGRect.init(x: 0, y: 5, width: 150, height: 30)).then{
                $0.backgroundColor = .clear
                $0.center.x = kScreenWidth/2
                $0.font = UIFont.systemFont(ofSize: 12)
                $0.textColor = UIColor.darkText
                $0.text = "\(curremtTime[0])"
                $0.textAlignment = .center
                $0.isHidden = true
            }
            $0.addSubview(dateLabel)
            $0.addSubview(yearLabel)
        }
        self.view.addSubview(headView)
        
    }
    func setChartView() {
       
        let chartArry = NSMutableArray()
        let date = self.dateLabel.text?.split(separator: "-")
        let year = Int(String.init(describing: date![0]))
        let mouth = Int(String.init(describing: date![1]))
        let mothWithDay = KECustomTool.howManyDays(inThisYear: year!, withMonth: mouth!)
        if isMouth{
            for _ in 0..<mothWithDay {
                chartArry.add(0)
            }
            if isExpend {
                for arry in sectionArry {
                    let singleDate = ((arry as! [Any])[0] as! String).split(separator: "-")
                    let singleDateDay = String.init(describing: singleDate[2])
                    chartArry[Int(singleDateDay)!-1] = (arry as! [Any])[1] as! Float
                }
            }else{
                for arry in sectionArry {
                    let singleDate = ((arry as! [Any])[0] as! String).split(separator: "-")
                    let singleDateDay = String.init(describing: singleDate[2])
                    chartArry[Int(singleDateDay)!-1] = (arry as! [Any])[2] as! Float
                }
            }
        }else{
            for _ in 0..<12 {
                chartArry.add(0)
            }
            if isExpend {
                for arry in sectionArry {
                    let singleDate = ((arry as! [Any])[0] as! String).split(separator: "-")
                    let singleDateDay = String.init(describing: singleDate[1])
                    chartArry[Int(singleDateDay)!-1] = (arry as! [Any])[1] as! Float
                }
            }else{
                for arry in sectionArry {
                    let singleDate = ((arry as! [Any])[0] as! String).split(separator: "-")
                    let singleDateDay = String.init(describing: singleDate[1])
                    chartArry[Int(singleDateDay)!-1] = (arry as! [Any])[2] as! Float
                }
            }
        }
        
        myView.viewArry = chartArry
        if isMouth{
            myView.myView.visibleXRangeDefaultmum = NSNumber.init(value: 32)
            myView.myView.visibleXRangeDefaultmum = NSNumber.init(value: 32)
        }else{
            myView.myView.visibleXRangeDefaultmum = NSNumber.init(value: 12)
            myView.myView.visibleXRangeDefaultmum = NSNumber.init(value: 12)
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
    
    //转换时间为对应格式
    func stringFromDate(date:NSDate) -> String {
        let dateFormate = DateFormatter.init()
        dateFormate.dateFormat = "YYYY-MM"
        return dateFormate.string(from: date as Date)
    }
    func stringFromYear(date:NSDate) -> String {
        let dateFormate = DateFormatter.init()
        dateFormate.dateFormat = "YYYY"
        return dateFormate.string(from: date as Date)
    }
}

extension KEChartViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topArry.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChartTopTableViewCellID", for: indexPath) as! KEChartTopTableViewCell
        let arry = topArry[indexPath.row] as! [Any]
        
        cell.titleImage.image = UIImage.init(named: "\(arry[1])")
        if isExpend {
            
            cell.headTitle.text = "\(arry[0])  \(String.init(format: "%.2f", (arry[2] as! Float)/allExpend * 100))%"
            
            let zero = String.init(describing: arry[2]).split(separator: ".")
            let zeroStr = String.init(describing: zero[1])
            var expendLabelText = ""
            if  zeroStr == "00" || zeroStr == "0"{
                expendLabelText =  String.init(describing:zero[0])
            }else{
                expendLabelText = String.init(describing: arry[2])
            }
            cell.moneyTitle.text = expendLabelText
            cell.topProgress.setProgress((arry[2] as! Float)/allExpend, animated: true)
            if (arry[2] as! Float) == 0 {
                cell.isHidden = true
            }
        }else{
            cell.headTitle.text = "\(arry[0])  \(String.init(format: "%.2f", (arry[3] as! Float)/allIncome * 100))%"
            let zero = String.init(describing: arry[3]).split(separator: ".")
            let zeroStr = String.init(describing: zero[1])
            var incomeLabelText = ""
            if  zeroStr == "00" || zeroStr == "0"{
                incomeLabelText =  String.init(describing:zero[0])
            }else{
                incomeLabelText = String.init(describing: arry[3])
            }
            cell.moneyTitle.text = incomeLabelText
            cell.topProgress.setProgress((arry[3] as! Float)/allIncome, animated: true)
            if (arry[3] as! Float) == 0 {
                cell.isHidden = true
                
            }
        }
       
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 40)).then{
            $0.backgroundColor = UIColor.init(red: 247/255, green: 247/255, blue: 247/255, alpha: 247/255)
            let titleLabel = UILabel.init(frame: CGRect.init(x: 10, y: 0, width: 150, height: 28)).then{
                $0.backgroundColor = .clear
                $0.font = UIFont.systemFont(ofSize: 15)
                $0.textColor = UIColor.darkText
                if  isExpend{
                    $0.text = "支出排行榜："
                }else{
                    $0.text = "收入排行榜："
                }
                
            }
            $0.addSubview(titleLabel)
            
        }
        
        return view
    }

}
