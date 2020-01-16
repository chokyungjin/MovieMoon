//
//  MovieCollectionViewController.swift
//  boxoffice
//
//  Created by Cho on 17/12/2018.
//  Copyright © 2018 Cho. All rights reserved.
//

import UIKit

class DiaryCollectionViewController: UICollectionViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var MovielistCollectionView: UICollectionView!
    
    //MARK: Variables
    let dataManager = DataManager.sharedManager
    
    let baseURL: String = {
        return ServerURLs.base.rawValue
    }()
    var movies: [Movie] = []
       var selectedImage: UIImage!
       var selectedTitle: String!
       var selectedRating: Double!
       var selectedDate: String!
    
    struct Storyboard {
           static let leftAndRightPaddings: CGFloat = 5.0
           static let numberOfItemsPerRow: CGFloat = 3.0
           static let movieListCellID: String = "MovieListCell"

       }
   
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setMovielistCollectionView()
        MovielistCollectionView.backgroundColor = .blackgroundBlack
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if dataManager.getDidOrderTypeChangedAndDownloaded() {
            reloadMovieLists()
        }
        else {
            let orderType: String = dataManager.getMovieOrderType()
            getMovieList(orderType: orderType)
        }
        
    }
    
   
}

extension DiaryCollectionViewController {
    
    func setMovielistCollectionView() {
        MovielistCollectionView.delegate = self
        MovielistCollectionView.dataSource = self
        let collectionViewWidth = (collectionView?.frame.width)!
        let itemWidth = ((collectionViewWidth - Storyboard.leftAndRightPaddings ) / Storyboard.numberOfItemsPerRow )
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + 10)
        print(itemWidth)
    }
    
    func setDefaultMovieOrderType() {
        let orderType: String = "0"
        dataManager.setMovieOrderType(orderType: orderType)
    }
    
    
    func getMovieList(orderType: String) {
        
        let url: String = baseURL + ServerURLs.movieList.rawValue + orderType
        
        guard let finalURL = URL(string: url) else {
            return
        }
        
        let session = URLSession(configuration: .default)
        let request = URLRequest(url: finalURL)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let resultData = data else {
                return
            }
            
            do {
                let movieLists: ListResponse  = try JSONDecoder().decode(ListResponse.self, from: resultData)
                
                self.dataManager.setMovieList(list: movieLists.results)
                self.dataManager.setDidOrderTypeChangedAndDownloaded(true)
                self.reloadMovieLists()
            }
            catch let error {
                print(error.localizedDescription)
            }
            
        }
        
        task.resume()
    }
    
    func reloadMovieLists() {
        self.movies = dataManager.getMovieList()
        DispatchQueue.main.async {
            self.MovielistCollectionView.reloadData()
        }
    }
    
    func getThumnailImage(withURL thumnailURL: String) -> UIImage? {
        guard let imageURL = URL(string: thumnailURL) else {
            return UIImage(named: "img_placeholder")
        }
        
        guard let imageData: Data = try? Data(contentsOf: imageURL) else {
            return UIImage(named: "img_placeholder")
        }
        
        return UIImage(data: imageData)
    }
    
    func getTitle(title: String) -> String? {
        return title
    }
    func getRating(rating: Double) -> Double? {
        return rating
    }
    func getDate(date: String) -> String? {
        return date
    }
    
    func getGradeImage(grade: Int) -> UIImage? {
        switch grade {
        case 0:
            return UIImage(named: "ic_allages")
        case 12:
            return UIImage(named: "ic_12")
        case 15:
            return UIImage(named: "ic_15")
        case 19:
            return UIImage(named: "ic_19")
        default:
            return nil
        }
    }
    
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width , height: self.view.frame.height)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.movieListCellID, for: indexPath) as! MovieCollectionViewCell
    
        cell.backgroundColor = .blackgroundBlack
        let movie = movies[indexPath.row]
        
        cell.imageThumbnail.imageFromUrl(movie.thumnailImageURL, defaultImgPath: "img_placeholder")
        cell.imageThumbnail.contentMode = .scaleToFill
        
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           
        let movie = movies[indexPath.row]
        let thumnailImage = self.getThumnailImage(withURL: movie.thumnailImageURL)
        self.selectedImage = thumnailImage
        dataManager.setImage(haveImage: self.selectedImage)
        
        let movietitle = self.getTitle(title: movie.title)
        self.selectedTitle = movietitle
        dataManager.setTitle(haveTitle: self.selectedTitle)
        
        let movieRating = self.getRating(rating: movie.userRating)
        self.selectedRating = movieRating
        dataManager.setRating(haveRating: self.selectedRating)
        
        let movieDate = self.getDate(date: movie.date)
        self.selectedDate = movieDate
        dataManager.setDate(haveDate: self.selectedDate)
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "DiaryScreen", bundle: nil)

            let vc = mainStoryboard.instantiateViewController(withIdentifier: "DiaryDetailVC") as! DiaryDetailViewController
               
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                  
       }
    
    
}
