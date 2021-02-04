//
//  WetherCollectionViewCell.swift
//  Weather
//
//  Created by Oleg on 7/4/20.
//  Copyright © 2020 Oleg. All rights reserved.
//

import UIKit

class WetherCollectionViewCell: UICollectionViewCell {
    static let identifier = "WetherCollectionViewCell"
    var index = 0
    static func nib() -> UINib {
        return UINib(nibName: "WetherCollectionViewCell",
                     bundle: nil)
    }
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var hourlyLabel: UILabel!
    
    func configure(with model: CurrentlWeather){
        if self.index == 0 {
            self.hourlyLabel.text = "now"
        } else {
          self.hourlyLabel.text = setHourly(model.dt, formattD: "hh")
        }
        self.tempLabel.textAlignment = .center
        self.hourlyLabel.textAlignment = .center
        self.tempLabel.text = "\(Int(model.temp))°"
        
        self.iconImageView.contentMode = .scaleAspectFit
        let icon = model.weather[0].main.lowercased()
        switch icon {
        case "clear":
            self.iconImageView.image = UIImage(named: "clear")
        case "rain":
            self.iconImageView.image = UIImage(named: "rain")
        case "clouds":
            self.iconImageView.image = UIImage(named: "clouds")
        default:
            break
        }
     
        
    }
    func setHourly(_ time: Int, formattD: String) -> String{
        let nsNumber = time as NSNumber
        let date = Date(timeIntervalSince1970: nsNumber.doubleValue)
        let formatt = DateFormatter()
        formatt.dateFormat = formattD
        let hourly = formatt.string(from: date)
        return hourly
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
extension WetherCollectionViewCell: HourlyTableViewCellDelegate{
    func setIndex(index: Int) {
        self.index = index
    }
    
    
}
