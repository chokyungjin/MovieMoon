//
//  DataManager.swift
//  boxoffice
//
//  Created by Cho on 17/12/2018.
//  Copyright © 2018 Cho. All rights reserved.
//

import Foundation

class DataManager {
    
    static let sharedManager: DataManager = {
        let dm = DataManager()
        return dm
    }()
    
    private init() {
        
    }
    private var haveImage: UIImage!
    
    func getImage() -> UIImage {
           return haveImage
       }
       func setImage(haveImage : UIImage) {
           self.haveImage = haveImage
       }
    
    private var haveTitle: String!

    func getTitle() -> String {
        return haveTitle
    }
    func setTitle(haveTitle : String) {
        self.haveTitle = haveTitle
    }
    
    private var haveRating: Double!

    func getRating() -> Double {
        return haveRating
    }
    func setRating(haveRating : Double) {
        self.haveRating = haveRating
    }
    
    
    //For Not Do Many Networking Process
    private var didOrderTypeChangedAndDownloaded: Bool = false
    
    func setDidOrderTypeChangedAndDownloaded(_ state: Bool) {
        didOrderTypeChangedAndDownloaded = state
    }
    
    
    func getDidOrderTypeChangedAndDownloaded() -> Bool {
        return didOrderTypeChangedAndDownloaded
    }
    
    //Shared MovieOrderType
    private var movieOrderType: String = ""
    
    func setMovieOrderType(orderType: String) {
        movieOrderType = orderType
    }
    
    func getMovieOrderType() -> String {
        return "0"
    }
    
    //Shared MovieLists
    private var movieList: [Movie] = []
    
    func setMovieList(list: [Movie]) {
        movieList = list
    }
    
    func getMovieList() -> [Movie] {
        return movieList
    }
}
