//
//  ResultViewController.swift
//  Race
//
//  Created by Oleg on 5/10/20.
//  Copyright © 2020 Oleg. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var labelNewRecord: UILabel!    
    @IBOutlet weak var labelResultat: UILabel!
    
    let shared = Manager.shared
    var gamer: Gamer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelNewRecord.isHidden = true
        if gamer != nil {
        labelResultat.text = String(Int(gamer!.distans * gamer!.difficulty))
        }
        if shared.newRecord {
            labelNewRecord.isHidden = false
        }
    }
  
    @IBAction func buttonList(_ sender: UIButton) {
     guard let VC = storyboard?.instantiateViewController(identifier: "ListVictoryViewController") as?
        ListVictoryViewController else {return}
        guard let settingVC = self.navigationController?.viewControllers.first(where: {$0 is SettingViewController}) as? SettingViewController else {return}
        VC.delegate = settingVC
            self.present(VC,animated: true)
    }
    
    @IBAction func buttonSetting(_ sender: UIButton) {
        guard let VC = storyboard?.instantiateViewController(identifier: "SettingViewController") as? SettingViewController else {return}
        navigationController?.pushViewController(VC, animated: true)
    }
}
