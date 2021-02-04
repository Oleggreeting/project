//
//  HourlyTableViewCell.swift
//  Weather
//
//  Created by Oleg on 7/1/20.
//  Copyright © 2020 Oleg. All rights reserved.
//

import UIKit
protocol HourlyTableViewCellDelegate {
    func setIndex(index: Int)
}

class HourlyTableViewCell: UITableViewCell {
    
    @IBOutlet var collectionView: UICollectionView!
    var weatherHourly: [CurrentlWeather] = []
    var delegate: HourlyTableViewCellDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(WetherCollectionViewCell.nib(), forCellWithReuseIdentifier: WetherCollectionViewCell.identifier)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    static let identifier = "HourlyTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "HourlyTableViewCell",
                     bundle: nil)
    }
    func configure(with weatherHourly: [CurrentlWeather]) {
        self.weatherHourly = weatherHourly
        collectionView.reloadData()
    }
    
}
//MARK: - extension UICollectionViewDelegate
extension HourlyTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherHourly.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WetherCollectionViewCell.identifier, for: indexPath) as? WetherCollectionViewCell else {return UICollectionViewCell()}
        self.delegate = cell
        self.delegate.setIndex(index: indexPath.row)
        
        cell.configure(with: weatherHourly[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 100)
    }
    
    
}
