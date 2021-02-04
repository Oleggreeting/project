//
//  Manager.swift
//  PhotoAlbom
//
//  Created by Oleg on 6/5/20.
//  Copyright © 2020 Oleg. All rights reserved.
//

import UIKit

class Manager {
    enum Keys: String {
        case key
    }
    static let shared = Manager()
    private init(){}
    var arrayItems: [Item] = []
    
    func saveItems() {
        UserDefaults.standard.set(encodable: arrayItems, forKey: Keys.key.rawValue)
    }
    
    func loadItems() {
        if let list = UserDefaults.standard.value([Item].self, forKey: Keys.key.rawValue){
            arrayItems = list
        }
    }
    
    func saveImage(image: UIImage) -> String? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return nil}
        let fileName = UUID().uuidString
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else {return nil}
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileName)
                print("Remove old image")
            } catch {
                print("could't remove file at path", error)
            }
        }
        do {
            try data.write(to: fileURL)
            return fileName
        } catch {
            print("saving file with error", error)
            return nil
        }
       
    }
    func loadImage(fileName: String) -> UIImage? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let path = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let path = path.first {
            let imageUrl = URL(fileURLWithPath: path).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        }
        return nil
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

