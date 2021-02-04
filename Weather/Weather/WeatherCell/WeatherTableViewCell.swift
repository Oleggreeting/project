//
//  WeatherTableViewCell.swift
//  Weather
//
//  Created by Oleg on 7/1/20.
//  Copyright © 2020 Oleg. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var highTempLabel: UILabel!
    @IBOutlet var lowTempLabel: UILabel!
    @IBOutlet var icon: UIImageView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    static let identifier = "WeatherTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "WeatherTableViewCell", bundle: nil)
    }
    func configure(with weatherDaily: DailyWeather) {
        if let min = weatherDaily.temp.min {
            self.lowTempLabel.text = "\(Int(min))°"
        } else {
            self.lowTempLabel.text = "-"
        }
        if let max = weatherDaily.temp.max {
            self.highTempLabel.text = "\(Int(max))°"
        } else {
            self.lowTempLabel.text = "-"
        }
        self.dayLabel.text = getDayForDate(Date(timeIntervalSince1970: Double(weatherDaily.dt)))
        let icon = weatherDaily.weather[0].main.lowercased()
//        print(icon)
        switch icon {
        case "clear":
            self.icon.image = UIImage(named: "clear")
        case "rain":
            self.icon.image = UIImage(named: "rain")
        case "clouds":
            self.icon.image = UIImage(named: "clouds")
        default:
            break
        }
        self.icon.contentMode = .scaleAspectFit
        
    }
    func getDayForDate(_ date: Date?) -> String {
        guard let date = date else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE" //sanday
        return formatter.string(from: date)
    }

}

