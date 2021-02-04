//
//  Item.swift
//  PhotoAlbom
//
//  Created by Oleg on 6/5/20.
//  Copyright © 2020 Oleg. All rights reserved.
//

import UIKit

class Item: Codable {
    var path: String?
    var description: String?
    var like: Bool = false
    var dateStr: String
    var selected: Bool = false
    init(){
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM, YYYY"
        dateStr = formatter.string(from: now)
    }
}
