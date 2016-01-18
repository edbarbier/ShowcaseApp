//
//  RoundedImage.swift
//  eb-network-app
//
//  Created by Edouard Barbier on 18/01/16.
//  Copyright © 2016 Edouard Barbier. All rights reserved.
//

import UIKit

class RoundedImage: UIImageView {

    override func awakeFromNib() {
        
        layer.cornerRadius = frame.size.width / 2
        layer.shadowRadius = 5.0
        clipsToBounds = true
    }

}
