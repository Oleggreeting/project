//
//  CustomCell.swift
//  Race
//
//  Created by Oleg on 6/20/20.
//  Copyright © 2020 Oleg. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
   
    @IBOutlet weak var imageCar: UIImageView!
    @IBOutlet weak var labelCar: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelDistans: UILabel!
    @IBOutlet weak var labelResult: UILabel!
    @IBOutlet weak var labelPriz: UILabel!
    
    let color: [UIColor] = [ #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)]

    override func awakeFromNib() {
        super.awakeFromNib()
        imageCar.layer.cornerRadius = 5
        imageCar.clipsToBounds = true
    }
    func configCell(object: Gamer, index: Int ) {
        self.imageCar.image = UIImage(named: object.nameCar!)
        self.labelCar.text = object.nameCar
        self.labelName.text = object.name
        self.labelDate.text = object.date

        self.labelDistans.text = "\(String(object.distans))m"
        self.labelResult.text = "\(String(object.result)) ⭐️"
                if index == 0 {
                    self.backgroundColor = .green
                    self.labelPriz.text = "🏆"
                }else{
                let index = index % color.count
                self.backgroundColor = color[index]
                }
    }
  

}

