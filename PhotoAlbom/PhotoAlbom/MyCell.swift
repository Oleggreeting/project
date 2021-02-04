//
//  MyCell.swift
//  PhotoAlbom
//
//  Created by Oleg on 13.09.2020.
//  Copyright © 2020 Oleg. All rights reserved.
//

import UIKit

class MyCell: UICollectionViewCell {
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var lable: UILabel = {
        let label = UILabel()
        label.text = "✓"
        label.textAlignment = .center
        label.textColor = .systemBlue
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension MyCell {
    fileprivate func setup() {
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.addSubview(lable)
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        lable.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        lable.widthAnchor.constraint(equalToConstant: 25).isActive = true
        lable.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
}
