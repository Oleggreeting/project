//
//  Model.swift
//  Race
//
//  Created by Oleg on 5/10/20.
//  Copyright © 2020 Oleg. All rights reserved.
//


import Foundation

class Gamer: Codable {
    var name: String?
    var nameCar: String?
    var distans: Double = 0
    var result: Int = 0
    var difficulty: Double = 1
    var date: String
    var music: Bool?
    
    init(name: String?, nameCar: String?) {
        self.name = name
        self.nameCar = nameCar
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "dd.MM.YYYY"
        self.date = format.string(from: date)
    }

}
