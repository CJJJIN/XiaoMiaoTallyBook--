//
//  KEBaseViewController.swift
//  KETallyBOOK
//
//  Created by 科文 on 21/09/2017.
//  Copyright © 2017 科文. All rights reserved.
//

import UIKit

class KEBaseViewController: UIViewController {
    
    var viewModel : KEViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    public init(WithViewModel viewModel:KEViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func loadView()
    {
        super.loadView()
        self.view.backgroundColor = UIColor.white
        // UI适配
        if self.responds(to:#selector(getter: UIViewController.edgesForExtendedLayout))
        {
            self.edgesForExtendedLayout = []
        }
    }
    
    func bindViewModel(){
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
