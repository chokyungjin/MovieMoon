//
//  HomeViewController.swift
//  DemoProject
//
//  Created by 조경진 on 11/09/2019.
//  Copyright © 2019 조경진. All rights reserved.
//

// didSelect 해결해야함
import UIKit

class HomeViewController: UIViewController,UISearchBarDelegate {
    
    
    
    //IB
    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var homeBoxofficeLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var hometitle: UILabel!
    
    //Variables
    var menuTableViewController: MenuTableViewController!
    let dataManager = DataManager.sharedManager
    let baseURL: String = {
        return ServerURLs.base.rawValue
    }()
    
    let movieListCellID: String = "MovieListCell"
    var movies: [Movie] = []
    var selectedImage: UIImage!
    var selectedTitle: String!
    var selectedRating: Double!
    var selectedDate: String!
    
    struct Storyboard {
           static let photoCell = "PhotoCell"
           static let showDetailVC = "ShowMovieDetail"
           static let leftAndRightPaddings: CGFloat = 2.0
           static let numberOfItemsPerRow: CGFloat = 3.0
       }
    
    var filterdData: [String]!
    var location = [String]()
    
    //init
    override func viewDidLoad() {
        super.viewDidLoad()
        movieCollectionView.translatesAutoresizingMaskIntoConstraints = false
        movieCollectionView.showsHorizontalScrollIndicator = false
        movieCollectionView.decelerationRate = .fast
    
        self.view.backgroundColor = .blackgroundBlack
        movieCollectionView.backgroundColor = .blackgroundBlack
        
        self.homeBoxofficeLabel.text = "흥행 예상작"
        self.homeBoxofficeLabel.textColor = .textGray
       // self.homeBoxofficeLabel.font = UIFont(name: "NanumSquareBold", size: 20)
        self.homeBoxofficeLabel.font = .NanumSquare(type: .Bold, size: 21.5 - 3.5, isFix: true)
        
        self.hometitle.textColor = .bigTextGray
        self.hometitle.backgroundColor = .blackgroundBlack

        setMovieListCollectionView()
        self.searchBar.delegate = self
        
        searchBar.showsCancelButton = false
        searchBar.accessibilityAttributedHint = NSAttributedString(string: "영화, 배우, 감독으로 검색", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 211/255.0, green: 211/255.0, blue: 211/255.0, alpha: 1)])
  
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if dataManager.getDidOrderTypeChangedAndDownloaded() {
            reloadMovieLists()
        }
        else {reloadMovieLists()
            let orderType: String = dataManager.getMovieOrderType()
            getMovieList(orderType: orderType)
        }
    }
    

    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search text:" , self.searchBar.text!)
        
        let refreshAlert = UIAlertController(title: "검색결과", message: self.searchBar.text!, preferredStyle: .alert)
        
        refreshAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action: UIAlertAction!) in
            print("검색확인")
            self.searchBar.showsCancelButton = false
            self.searchBar.text = ""
            self.searchBar.resignFirstResponder()
        }))
        present(refreshAlert, animated: true, completion: nil)
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
                print("Success")
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
            self.movieCollectionView.reloadData()
        }
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
    
    func setDefaultMovieOrderType() {
        let orderType: String = "0"
        dataManager.setMovieOrderType(orderType: orderType)
    }
    
    func setMovieListCollectionView() {
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
    }
    
    
    
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: movieListCellID, for: indexPath) as! MovieCollectionViewCell
        
        
        let movie = movies[indexPath.row]
        
//        cell.titleLabel.text = movie.title
//        cell.dateLabel.text = movie.date
//
//        let rateString = "\(movie.reservationGrade)위 / \(movie.reservationRate)"
//        cell.ratingsLabel.text = rateString
//
//        let gradeIamge = getGradeImage(grade: movie.grade)
//        cell.gradeImageView.image = gradeIamge
        
        
        OperationQueue().addOperation {
            let thumnailImage = self.getThumnailImage(withURL: movie.thumnailImageURL)
            DispatchQueue.main.async {
                cell.imageThumbnail.image = thumnailImage

            }
        }
        
        return cell
    }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           
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
        
        
        //ImageManager.imageManager.setTitle(haveTitle: self.)
       // performSegue(withIdentifier: Storyboard.showDetailVC , sender: nil)
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "HomeScreen", bundle: nil)

            let vc = mainStoryboard.instantiateViewController(withIdentifier: "MovieDetailVC") as! MovieDetailViewController
               
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                  
       }
    
}
