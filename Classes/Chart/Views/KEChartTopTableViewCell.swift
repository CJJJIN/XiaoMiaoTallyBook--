//
//  KEChartTopTableViewCell.swift
//  KETallyBOOK
//
//  Created by 科文 on 18/10/2017.
//  Copyright © 2017 科文. All rights reserved.
//

import UIKit

class KEChartTopTableViewCell: UITableViewCell {
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var headTitle: UILabel!
    @IBOutlet weak var moneyTitle: UILabel!
    
    @IBOutlet weak var topProgress: UIProgressView!
    override func awakeFromNib() {
        super.awakeFromNib()
        topProgress.transform = CGAffineTransform.init(scaleX: 1.0, y: 3.0)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
