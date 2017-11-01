//
//  KECategoryCollectionViewCell.swift
//  KETallyBOOK
//
//  Created by 科文 on 08/10/2017.
//  Copyright © 2017 科文. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class KECategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var titleBtn: UIButton!
    private let disposeBag = DisposeBag()
    var viewModel :KEBillTypeViewModel?
    private let disposebag = DisposeBag()
    var model : KEBillTypeModel? {
        didSet{
            guard let model = model else {
                return
            }
            if model.isSelected {
                self.titleBtn.setBackgroundImage(UIImage.init(named:model.categoryImageFileName_Selected ), for: .normal)
            }else{
                self.titleBtn.setBackgroundImage(UIImage.init(named:model.categoryImageFileName_Normal ), for: .normal)
            }
            self.categoryTitleLabel.text = model.categoryName
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func clickTitleBtn(_ sender: Any) {
        if (self.viewModel?.isKind)!{
            self.viewModel?.homeDetailViewModel?.updateModel?.categoryImageFileName_S = model?.categoryImageFileName_S
            self.viewModel?.homeDetailViewModel?.updateData.value = (self.viewModel?.homeDetailViewModel!.updateModel)!
            self.viewController()?.dismiss(animated: true, completion: nil)
        }else{
            self.viewModel?.categorySelected.value = self.model!
        }
       
        
    }
}
