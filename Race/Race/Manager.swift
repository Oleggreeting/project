//
//  Manager.swift
//  Race
//
//  Created by Oleg on 5/10/20.
//  Copyright © 2020 Oleg. All rights reserved.
//

import Foundation

class Manager {
    
    static let shared = Manager()
    private init() {}
    let arrayType: [String] = ["Ferrari", "Model S","Maserati","McLaren P1", "Camaro"]
    let arrayCarOncoming: [String] = ["oncomingBlack", "oncomingRed", "oncomingYellow"]
    let arrayDifficulty: [String] = ["1", "2", "3", "4"]
    
    
    var newRecord: Bool = false
    var listGamers: [Gamer] = []
    
    let key = "race"
    func save() {
        UserDefaults.standard.set(encodable: listGamers, forKey: key)
    }
    func load() {
        if let list = UserDefaults.standard.value([Gamer].self, forKey: key) {
            listGamers = list
        }
    }
    
    func addGamerToList(gamer: Gamer) {
        let result = Int(gamer.distans * gamer.difficulty)
        if listGamers.count == 0 {
            gamer.result = result
            listGamers.append(gamer)
            return
        }
        newRecord = false
        var index = 0
        for element in listGamers {
            if element.name == gamer.name {
                element.result = result
                let date = Date()
                let format = DateFormatter()
                format.dateFormat = "dd.MM.YYYY"
                gamer.date = format.string(from: date)
                return
            }
            index += 1
        }
        gamer.result = result
        listGamers.append(gamer)
        let sort = listGamers.sorted(by: {$0.result > $1.result})
        if sort[0].name == gamer.name {
            newRecord = true
        }
        listGamers = sort
    }
    
}

extension UserDefaults {
    func set<T: Encodable>(encodable: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(encodable) {
            set(data, forKey: key)
        }
    }
    
    func value<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        if let data = object(forKey: key) as? Data,
            let value = try? JSONDecoder().decode(type, from: data) {
            return value
        }
        return nil
    }
}
