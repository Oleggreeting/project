//
//  MyCollectionViewCell.swift
//  PhotoAlbom
//
//  Created by Oleg on 7/13/20.
//  Copyright © 2020 Oleg. All rights reserved.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var myImageView: UIImageView!

    let identifier = "MyCollectionViewCell"

    
    override func awakeFromNib() {
        super.awakeFromNib()
        scrollView.delegate = self
        myImageView.contentMode = .scaleAspectFill
        myImageView.layer.cornerRadius = 10
        myImageView.clipsToBounds = true
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 3
      
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return myImageView
    }
}
