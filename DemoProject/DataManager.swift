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
    private var toggleSwitch: Bool = false
    
    func getSwitch() -> Bool {
        return toggleSwitch
    }
    func setSwitch(toggleSwitch : Bool){
        self.toggleSwitch = toggleSwitch
    }
    
    private var haveId: String!
    
    func getId() -> String {
        return haveId
    }
    func setId(haveId : String) {
        self.haveId = haveId
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
    
    private var haveDate: String!
    
    func getDate() -> String {
        return haveDate
    }
    func setDate(haveDate : String) {
        self.haveDate = haveDate
    }
    
    private var haveRating: Double!
    
    func getRating() -> Double {
        return 4.5
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
    
    private var cachedMovies: [String : [Movie]] = [:]
    private var cachedMovie: [String : MovieDetail] = [:]
    private let session = URLSession.shared
    
    public func fetchData(url: URL, completion: @escaping (Any) -> (), errorHandler: @escaping () -> Void) {
        
        session.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data, let self = self else {
                errorHandler()
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                DispatchQueue.main.async {
                    completion(json)
                }
            } catch {
                errorHandler()
            }
            
            DispatchQueue.main.async {
                print(11)
            }
        }.resume()
    }
    
    
    func fetchMovieDetail(movieId: String, completion: @escaping (MovieDetail) -> Void, errorHandler: @escaping () -> Void) {
        guard let url: URL = URL(string: ServerURLs.base.rawValue + ServerURLs.movieDetail.rawValue + movieId) else {
            errorHandler()
            return
        }
        print(url)
        if let movie = cachedMovie[movieId] {
            
            print("movie detail local cache")
            completion(movie)
            return
        }
        
        DataManager.sharedManager.fetchData(url: url, completion: { [weak self] (json) in
            guard let self = self else { return }
            
            do {
                let response = try MovieDetailApiResponse(json: json)
                
                self.cachedMovie[movieId] = response.movie
                
                completion(response.movie)
            } catch {
                errorHandler()
            }
        }) { errorHandler() }
    }
    
}
