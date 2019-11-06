//
//  LoginManager.swift
//  club_INU
//
//  Created by 조경진 on 06/08/2019.
//  Copyright © 2019 dong.gyun. All rights reserved.
//

import Foundation

class ImageManager {
    
    static let imageManager = ImageManager()
    private init() {}
    private var haveImage: UIImage!
    private var haveTitle: UILabel!
    
    
    func getImage() -> UIImage {
        return haveImage
    }
    func setImage(haveImage : UIImage) {
        self.haveImage = haveImage
    }
    func getTitle() -> UILabel {
        return haveTitle
    }
    func setTitle(haveTitle : UILabel) {
        self.haveTitle = haveTitle
    }
}
