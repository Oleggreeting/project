//
//  BigGalleryCollectionView.swift
//  PhotoAlbom
//
//  Created by Oleg on 7/11/20.
//  Copyright © 2020 Oleg. All rights reserved.
//

import UIKit

class BigGalleryCollectionView: UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    
    let shared = Manager.shared
    let identifier = "MyCollectionViewCell"
    var index = 0

    var completion: ((Bool)->())?
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        super.init(frame: .zero, collectionViewLayout: layout)
        backgroundColor = .gray
        delegate = self
        dataSource = self
        register(UINib(nibName: "MyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: identifier)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//MARK: - FlowFunctions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shared.arrayItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? MyCollectionViewCell else {return UICollectionViewCell()}
        if let image = shared.loadImage(fileName: shared.arrayItems[indexPath.row].path!) {
            cell.myImageView.image = image
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let index = Int(scrollView.contentOffset.x / UIScreen.main.bounds.width)
        let item = shared.arrayItems[index]
        self.completion?(item.like)
    }
}

