//
//  Post.swift
//  eb-network-app
//
//  Created by Edouard Barbier on 14/01/16.
//  Copyright © 2016 Edouard Barbier. All rights reserved.
//

import Foundation
import Firebase

class Post {
    
    private var _postDescription: String!
    private var _imgUrl: String?
    private var _likes: Int!
    private var _username: String!
    private var _postKey: String! //No need to put in initializer because there may not be any _postKey just yet
    private var _postRef: Firebase!
    
    var postDescription: String {
        return _postDescription
    }
    
    var imgUrl: String? {
        return _imgUrl
    }
    
    var likes: Int! {
        return _likes
    }
    
    var username: String! {
        return _username
    }
    
    var postKey: String! {
        return _postKey
    }
    
    init(description: String, imgUrl: String?, username: String) {
        
        self._postDescription = description
        self._imgUrl = imgUrl
        self._username = username
    }
    
    init(postKey: String, dictionary: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        if let likes = dictionary["likes"] as? Int {
            self._likes = likes
        }
        
        if let imgUrl = dictionary["imgUrl"] as? String {
            self._imgUrl = imgUrl
        }
        
        if let desc = dictionary["description"] as? String {
            self._postDescription = desc
        }
        
        self._postRef = DataService.ds.REF_POSTS.childByAppendingPath(self._postKey)
    }
    
    func ajustLikes(addLike: Bool) {
        
        if addLike {
            _likes = _likes + 1
        } else {
            _likes = _likes - 1
        }
        
        _postRef.childByAppendingPath("likes").setValue(_likes)
    }
}
