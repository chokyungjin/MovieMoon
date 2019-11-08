//
//  menu.swift
//  DemoProject
//
//  Created by 조경진 on 13/09/2019.
//  Copyright © 2019 조경진. All rights reserved.
//

import Foundation

class Menu {
    
    var profile: String!
    var setting: String!
    var logout: String!
    var wishlist : String!
    
    init(profile : String, setting : String , logout : String, wishlist : String){
        self.profile = profile
        self.setting = setting
        self.logout = logout
        self.wishlist = wishlist
       
    }
    
    static var menuList = [
        "profile", "setting", "logout", "wishlist"
    ]
    
}
