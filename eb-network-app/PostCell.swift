//
//  PostCell.swift
//  eb-network-app
//
//  Created by Edouard Barbier on 13/01/16.
//  Copyright © 2016 Edouard Barbier. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var showCaseImg: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var likeImage: UIImageView!

    var post: Post!
    var request: Request?
    var likeRef
    : Firebase!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: "likeTapped:")
        tap.numberOfTapsRequired = 1
        likeImage.addGestureRecognizer(tap)
        likeImage.userInteractionEnabled = true
    }
    
    override func drawLayer(layer: CALayer, inContext ctx: CGContext) {

        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        profileImg.clipsToBounds = true
        showCaseImg.clipsToBounds = true 

    }

    func configureCell(post: Post, img: UIImage?) {
        self.post = post
        likeRef = DataService.ds.REF_USER_CURRENT.childByAppendingPath("likes").childByAppendingPath(post.postKey)
        self.descriptionText.text = post.postDescription
        self.likesLbl.text = "\(post.likes)"
        
        if post.imgUrl != nil {
            
            if img != nil {
                self.showCaseImg.image = img
            } else {
                request = Alamofire.request(.GET, post.imgUrl!).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data, err in
                    
                    if err == nil {
                        let img = UIImage(data: data!)!
                        self.showCaseImg.image = img
                        FeedVC.imgCache.setObject(img, forKey: self.post.imgUrl!)
                    }
                })
                
            }
            
        } else {
            self.showCaseImg.hidden = true
        }
        
        //Check if post has been liked or not by current user
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let _ = snapshot.value as? NSNull { // if there's not data in .Value we will receive a NSNull from Firebase
                //We have not like this specific post
                self.likeImage.image = UIImage(named: "heart-empty")
                
            } else {
                self.likeImage.image = UIImage(named: "heart-full")
            }
        
        })
        
    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let _ = snapshot.value as? NSNull { // if there's not data in .Value we will receive a NSNull from Firebase
                //We have not like this specific post
                self.likeImage.image = UIImage(named: "heart-full")
                self.post.ajustLikes(true) // + 1 like
                self.likeRef.setValue(true)
                
            } else {
                self.likeImage.image = UIImage(named: "heart-empty")
                self.post.ajustLikes(false) // -1 like
                self.likeRef.removeValue()
            }
            
        })

    }
    


}
