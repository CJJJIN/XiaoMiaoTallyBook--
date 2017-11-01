//
//  KEBillDetailTableViewCell.swift
//  KETallyBOOK
//
//  Created by 科文 on 13/10/2017.
//  Copyright © 2017 科文. All rights reserved.
//

import UIKit

class KEBillDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var titleImgBtn: UIButton!
    @IBOutlet weak var monyField: GATextField!
    @IBOutlet weak var titleName: UITextField!
    var viewModel :KEHomeDetailViewModel?

    var model : KEHomeBillModel? {
        didSet{
            guard let model = model else {
                return
            }
            self.titleImgBtn.setBackgroundImage(UIImage.init(named:model.categoryImageFileName_S ), for: .normal)
            if model.remark != "" && model.remark != nil{
                self.titleName.text = model.remark
            }else{
                self.titleName.text = model.typeName
            }
            
            let zero = model.money.split(separator: ".")
            let zeroStr = String.init(describing: zero[1])
            if  zeroStr == "00"{
                if model.isIncome{
                    self.monyField.text = String.init(describing: zero[0])
                }else{
                    self.monyField.text = "-\(String.init(describing: zero[0]))"
                }
            }else{
                if model.isIncome{
                    self.monyField.text = model.money
                }else{
                    self.monyField.text = "-\(model.money!)"
                }
            }
            self.monyField.ga_delegate = self
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        monyField.font = UIFont.systemFont(ofSize: 14)
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    @IBAction func clickTlitleImg(_ sender: Any) {
        let viewModelServices = KEViewModelServicesImpl.init()
        let billTypeViewModel = KEBillTypeViewModel.init(withServices: viewModelServices, params: ["":""])
        billTypeViewModel.isKind = true
        viewModel?.updateModel = self.model
        billTypeViewModel.homeDetailViewModel = viewModel
        let chargeUpVC = KEChargeUpViewController.init(WithViewModel: billTypeViewModel)
        self.viewController()?.present(KEConfigBaseNavigationController.init(rootViewController: chargeUpVC), animated: true, completion: {
            
        })
        
    }

}
extension KEBillDetailTableViewCell : GATextFieldDelegate{
    
}

