//
//  LocationViewController.swift
//  Weather
//
//  Created by Oleg on 7/5/20.
//  Copyright © 2020 Oleg. All rights reserved.
//

import UIKit
struct Weather: Codable {
    let main: MainData?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let name: String?
    
}
struct MainData: Codable {
    let temp: Double?
    let feels_like: Double?
    let temp_min: Double?
    let temp_max: Double?
    let pressure: Double?
    let humidity: Int?
}
struct Clouds: Codable {
    let all: Int?
}
struct Wind: Codable {
    let speed: Double?
}

class LocationViewController: UIViewController {
    
    @IBOutlet weak var viewDescribtion: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var nightTempLabel: UILabel!
    @IBOutlet weak var dayTempLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var speedWindLabel: UILabel!
    @IBOutlet weak var cloudsLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        self.viewDescribtion.isHidden = true
   
    }
}
extension LocationViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.viewDescribtion.isHidden = true
        return true
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let city = searchBar.text else {return}
        guard let url = URL(string:"https://api.openweathermap.org/data/2.5/weather?q=\(city)&units=metric&appid=e1e8ffb0397f61607ec14d0963b0037b") else {
            print("The city: \(city) is not existing")
            return}
        URLSession.shared.dataTask(with: url) { [weak self](data, response, error) in
            if let date = data, error == nil {
                do {
                    let json = try JSONDecoder().decode(Weather.self, from: date)
//                    let json = try JSONSerialization.jsonObject(with: date, options: .mutableLeaves)
                    let result = json
          
                    DispatchQueue.main.async {
                        if let name = result.name{
                          self?.cityLabel.text = "\(name)"
                        }
                        if let temp = result.main?.temp{
                        self?.tempLabel.text = "\(Int(temp))°"
                        }
                        if let feels = result.main?.feels_like {
                        self?.feelsLikeLabel.text = "\(Int(feels))°"
                        }
                        if let tMin = result.main?.temp_min {
                        self?.nightTempLabel.text = "\(Int(tMin))°"
                        }
                        if let tMax = result.main?.temp_max {
                            self?.dayTempLabel.text = "\(Int(tMax))°"
                            
                        }
                        if let pressure = result.main?.pressure {
                        self?.pressureLabel.text = "\(pressure)mm Hg"
                        }
                        if let humidity = result.main?.humidity {
                        self?.humidityLabel.text = "\(humidity)%"
                        }
                        if let speed = result.wind?.speed {
                        self?.speedWindLabel.text = "\(speed)m/s"
                        }
                        if let clouds = result.clouds?.all {
                        self?.cloudsLabel.text = "\(clouds)%"
                        }
                        if let visibility = result.visibility {
                        self?.visibilityLabel.text = "\(visibility)m"
                        }
                        self?.viewDescribtion.isHidden = false
                    }

                } catch {
                    DispatchQueue.main.async {
                        self?.searchBar.text = "The \(city) is not data!"
                    }
                    print(error)
                }
            }
        }.resume()
        
        
    }
    
}
