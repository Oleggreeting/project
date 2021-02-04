//
//  ViewPin.swift
//  PhotoAlbom
//
//  Created by Oleg on 6/5/20.
//  Copyright © 2020 Oleg. All rights reserved.
//

import UIKit

class ViewPin: UIView {

        @IBOutlet weak var textField: UITextField!
        @IBOutlet weak var buttonOk: UIButton!
        @IBOutlet weak var buttonCancel: UIButton!
        @IBOutlet weak var viewAlert: UIView!
        @IBOutlet weak var labelWrongCode: UILabel!
    
        class func instanceFromNib() -> ViewPin {
            return UINib(nibName: "ViewPin", bundle: nil).instantiate(withOwner: nil, options: nil).first as! ViewPin
        }
}
