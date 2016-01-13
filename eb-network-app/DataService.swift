//
//  DataService.swift
//  eb-network-app
//
//  Created by Edouard Barbier on 13/01/16.
//  Copyright © 2016 Edouard Barbier. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    
    static let ds = DataService()
    
    private var _REF_BASE = Firebase(url: "https://eb-network-app.firebaseio.com")
    
    var REF_BASE: Firebase {
        return _REF_BASE
    }
}