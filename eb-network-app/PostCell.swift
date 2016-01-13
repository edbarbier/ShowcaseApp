//
//  PostCell.swift
//  eb-network-app
//
//  Created by Edouard Barbier on 13/01/16.
//  Copyright © 2016 Edouard Barbier. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var showCaseImg: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func drawLayer(layer: CALayer, inContext ctx: CGContext) {

        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        profileImg.clipsToBounds = true
        showCaseImg.clipsToBounds = true 

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
