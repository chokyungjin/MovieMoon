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
    @IBOutlet weak var plusBut: UIButton!
    
    
    //MARK: Variables
    let dataManager = DataManager.sharedManager
    
    let baseURL: String = {
        return ServerURLs.base.rawValue
    }()
    
    var movies: [Movie] = []
    struct Storyboard {
           static let leftAndRightPaddings: CGFloat = 5.0
           static let numberOfItemsPerRow: CGFloat = 3.0
           static let movieListCellID: String = "MovieListCell"

       }
   
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setMovielistCollectionView()
        self.plusBut.layer.cornerRadius = (self.plusBut.frame.width / 2)
               self.plusBut.layer.borderWidth = 0
               self.plusBut.layer.masksToBounds = true
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
    

    @IBAction func addMovie(_ sender: Any) {
        let addAlert = UIAlertController(title: "영화 추가", message: "아 검색하려는 곳으로 가면되지", preferredStyle: .alert)
               
               addAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action: UIAlertAction!) in
                   print("검색확인")
                  
               }))
               present(addAlert, animated: true, completion: nil)
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
        print(cell.frame.size)
    
        
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
                cell.imageThumbnail.image = thumnailImage
                cell.imageThumbnail.contentMode = .scaleToFill
            }
        }
        
        return cell
    }
    
    
}
