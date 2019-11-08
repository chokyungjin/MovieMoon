//
//  MovieCollectionViewController.swift
//  boxoffice
//
//  Created by Cho on 17/12/2018.
//  Copyright © 2018 Cho. All rights reserved.
//

import UIKit

class DiaryViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var movielistCollectionView: UICollectionView!
    
    //MARK: Variables
    let dataManager = DataManager.sharedManager
    
    let baseURL: String = {
        return ServerURLs.base.rawValue
    }()
    
    let movieListCellID: String = "MovieListCell"
    
    var movies: [Movie] = []

   
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setMovielistCollectionView()
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

extension DiaryViewController {
    
    func setMovielistCollectionView() {
        movielistCollectionView.delegate = self
        movielistCollectionView.dataSource = self
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
            self.movielistCollectionView.reloadData()
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
    
}

extension DiaryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width , height: self.view.frame.height)
        //셀이 두개씩 나오고 싶다. 왜 스크린샷 처럼 안나오는지 모르겠음...
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: movieListCellID, for: indexPath) as! MovieListCollectionViewCell
        
        let movie = movies[indexPath.row]
        
       // cell.titlelabel.text = movie.title
      //  cell.datelabel.text = movie.date
        
      //  let rateString = "\(movie.reservationGrade)위 / \(movie.reservationRate)"
       // cell.ratingslabel.text = rateString
        
      //  let gradeIamge = getGradeImage(grade: movie.grade)
      //  cell.gradeimageView.image = gradeIamge
        
        OperationQueue().addOperation {
            let thumnailImage = self.getThumnailImage(withURL: movie.thumnailImageURL)
            DispatchQueue.main.async {
                cell.thumnailimageView.image = thumnailImage
            }
        }
        
        return cell
    }
    
    
}
