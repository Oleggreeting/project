//
//  ViewController.swift
//  Weather
//
//  Created by Oleg on 7/1/20.
//  Copyright © 2020 Oleg. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyKeychainKit

class ViewController: UIViewController {
  
    //MARK: - IBOutlet
    @IBOutlet var table: UITableView!
    //MARK: - Var
    var viewModel: ViewModel?
    var imageView: UIImageView!
    var weatherDaily: [DailyWeather] = []
    var weatherHourly: [CurrentlWeather] = []
    var currentWeather: WeatherResponse?
    var coordinates: CLLocation?
    
    //MARK: - Let
    let locationManager = CLLocationManager()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let keychain = Keychain(service: "com.swifty.keychain")
        let accessTokenKey = KeychainKey<String>(key: "accessToken")
        
        // Save or modify value
        try? keychain.set("some secure text", for: accessTokenKey)

        // Get value
        if let value: String = try? keychain.get(accessTokenKey) {
        print(value)
        }

        table.delegate = self
        table.dataSource = self
        
        table.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
        table.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
      
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setToolbarHidden(false, animated: true)
        navigationController?.toolbar.backgroundColor = .red
          locationSetup()
    }
    
    //MARK: - Flow Functions
    @IBAction func buttonAddLocatio(_ sender: UIButton) {
//        fatalError()
        guard let VC = storyboard?.instantiateViewController(identifier: "LocationViewController") as? LocationViewController else {return}
        present(VC, animated: true, completion: nil)
    }
    
    
    func locationSetup() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    func requestWeatherForLocation() {
//        guard let coordinates = coordinates else {return}
//            let lon = coordinates.coordinate.longitude
//            let lat = coordinates.coordinate.latitude
            let lon = 27.751
            let lat = 53.805
            guard let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&units=metric&appid=e1e8ffb0397f61607ec14d0963b0037b") else {return}
            URLSession.shared.dataTask(with: url, completionHandler: { (data, respons, error) in
                
                guard let data = data, error == nil else {return}
                    do {
                        let json = try JSONDecoder().decode(WeatherResponse?.self, from: data)
                        guard let result = json else {return}
                        
                        self.weatherDaily.append(contentsOf: result.daily)
                        self.weatherHourly = result.hourly
                        self.currentWeather = result
                        DispatchQueue.main.async {
                            self.table.reloadData()
                            self.table.tableHeaderView = self.createTableHeader()
                        }
                        
                    }catch{
                        print(error)
                    }
            }).resume()
        }
    func createTableHeader() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width * 0.8))
        let locationLabel = UILabel(frame: CGRect(x: 10, y: 0, width: headerView.frame.size.width, height: headerView.frame.size.height * 0.5))

        let summaryLabel = UILabel(frame: CGRect(x: 10, y: locationLabel.frame.size.height, width: headerView.frame.size.width, height: headerView.frame.size.height * 0.1))
        
        let tempLabel = UILabel(frame: CGRect(x: 10, y: locationLabel.frame.size.height + summaryLabel.frame.size.height, width: headerView.frame.size.width, height: headerView.frame.size.height * 0.3))
        let dateLabel = UILabel(frame: CGRect(x: 10, y: locationLabel.frame.size.height + summaryLabel.frame.size.height + tempLabel.frame.size.height, width: headerView.frame.size.width / 2 - 10, height: headerView.frame.size.height * 0.1))
        let todayTempLabel = UILabel(frame: CGRect(x: headerView.frame.size.width / 2, y: locationLabel.frame.size.height + summaryLabel.frame.size.height + tempLabel.frame.size.height, width: headerView.frame.size.width / 2 - 10, height: headerView.frame.size.height * 0.1))
        let view = UIView(frame: CGRect(x: 0, y: headerView.frame.size.height - 00.5, width: headerView.frame.size.width, height: 0.5))
       
        locationLabel.text = self.currentWeather?.timezone
        locationLabel.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        locationLabel.font = UIFont(name: "Tamil Sangam MN", size: 42)
        
        summaryLabel.text = self.currentWeather?.current.weather[0].description
        summaryLabel.textColor = #colorLiteral(red: 0.9999235272, green: 1, blue: 0.9998829961, alpha: 1)
        summaryLabel.font = UIFont(name: "Tamil Sangam MN", size: 25)
        
        guard let temp = self.currentWeather?.current.temp else {return UIView()}
        tempLabel.text = "\(Int(temp))°"
        tempLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tempLabel.font = UIFont(name: "Hiragino Sans", size: 62)
        if let date = currentWeather?.current.dt {
        dateLabel.text = "Today \(setDate(date, formattD: "EEEE"))"
        }
        dateLabel.textAlignment = .left
        dateLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        dateLabel.font = UIFont(name: "Tamil Sangam MN", size: 25)
        
        if let lessTemp = currentWeather?.daily[0].temp.night, let hightTemp = currentWeather?.daily[0].temp.day {
            todayTempLabel.text = "    \(Int(lessTemp))°      \(Int(hightTemp))°"
            todayTempLabel.textAlignment = .center
            todayTempLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            todayTempLabel.font = UIFont(name: "Tamil Sangam MN", size: 25)
        }
        view.backgroundColor = .white
        
        headerView.addSubview(locationLabel)
        headerView.addSubview(summaryLabel)
        headerView.addSubview(tempLabel)
        headerView.addSubview(dateLabel)
        headerView.addSubview(todayTempLabel)
        headerView.addSubview(view)
        
        locationLabel.textAlignment = .center
        summaryLabel.textAlignment = .center
        tempLabel.textAlignment = .center
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func setDate(_ time: Int, formattD: String) -> String{
        let nsNumber = time as NSNumber
        let date = Date(timeIntervalSince1970: nsNumber.doubleValue)
        let formatt = DateFormatter()
        formatt.dateFormat = formattD
        let hourly = formatt.string(from: date)
        return hourly
    }
}
//MARK: - extension UITableViewDelegate
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return weatherDaily.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.identifier, for: indexPath) as? HourlyTableViewCell else {return UITableViewCell()}
                cell.configure(with: weatherHourly)
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as? WeatherTableViewCell else { return UITableViewCell() }
        if let element = currentWeather?.daily {
        cell.configure(with: element[indexPath.row + 1])
            }
         return cell
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 100
        }
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    
        return 1.0
    }
    
}
//MARK: - extension CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, coordinates == nil {
            coordinates = locations.first
            locationManager.startUpdatingLocation()
            requestWeatherForLocation()

        }
    }
}


