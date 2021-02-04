//
//  Model.swift
//  Weather
//
//  Created by Oleg on 7/2/20.
//  Copyright © 2020 Oleg. All rights reserved.
//

import Foundation
class Question {
    let url: String
    init(url: String) {
        self.url = url
    }
}

struct WeatherResponse: Codable {
    let current: CurrentlWeather
    let lat: Float
    let lon: Float
    let timezone:String
    let timezone_offset: Int
    let minutely: [MinutlyWeather]?
    let hourly: [CurrentlWeather]
    let daily: [DailyWeather]
}
struct DailyWeather: Codable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: TempData
    let feels_like: TempData
    let pressure: Int
    let humidity: Int
    let dew_point: Double
    let wind_speed: Double
    let wind_deg: Int
    let weather: [DescriptionWeathe]
    let clouds: Int
    let uvi: Double
}
struct TempData: Codable{
    let day: Double
    let night: Double
    let eve: Double
    let morn: Double
    let min: Double?
    let max: Double?
    
}
struct FeelData: Codable {
    let day: Double
    let night: Double
    let eve: Double
    let morn: Double
}

struct MinutlyWeather: Codable {
    let dt: Int
    let precipitation: Int
}
struct CurrentlWeather: Codable {
    let clouds: Int
    let dew_point: Double
    let dt: Int
    let feels_like: Double
    let humidity: Int
    let pressure: Int
    let sunrise: Int?
    let sunset: Int?
    let temp: Double
    let uvi: Double?
    let visibility: Int?
    let weather: [DescriptionWeathe]
    let wind_deg: Int
    let wind_speed: Double
}
struct DescriptionWeathe: Codable {
    let description: String
    let icon: String
    let id: Int
    let main: String
}
