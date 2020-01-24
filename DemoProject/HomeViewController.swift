//
//  HomeViewController.swift
//  DemoProject
//
//  Created by 조경진 on 11/09/2019.
//  Copyright © 2019 조경진. All rights reserved.
//

// didSelect 해결해야함
import UIKit
import Kingfisher

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
    var movieDetail: MovieDetail?
    
    struct Storyboard {
        static let photoCell = "PhotoCell"
        static let showDetailVC = "ShowMovieDetail"
        static let leftAndRightPaddings: CGFloat = 2.0
        static let numberOfItemsPerRow: CGFloat = 3.0
    }
    
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
        //이텔릭 적용되는 폰트 받아오기
        
        setMovieListCollectionView()
        self.searchBar.delegate = self
        searchBar.accessibilityAttributedHint = NSAttributedString(string: "영화, 배우, 감독으로 검색", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 211/255.0, green: 211/255.0, blue: 211/255.0, alpha: 1)])
        
        //addObserver
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(HomeinteractionObserve),
                                               name: NSNotification.Name(rawValue: "PostButton"),
                                               object: nil)
        
    }
    
    @objc func HomeinteractionObserve() {
        if DataManager.sharedManager.getSwitch() == false {
            self.searchBar.isUserInteractionEnabled = false
            self.movieCollectionView.isUserInteractionEnabled = false
        }
        else if DataManager.sharedManager.getSwitch() == true {
            self.searchBar.isUserInteractionEnabled = true
            self.movieCollectionView.isUserInteractionEnabled = true
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if dataManager.getDidOrderTypeChangedAndDownloaded() {
            reloadMovieLists()
        }
        else {
            reloadMovieLists()
            let orderType: String = dataManager.getMovieOrderType()
            getMovieList(orderType: orderType)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let MovieDetailViewController = segue.destination as? MovieDetailViewController else {return}
        
        let cell = sender as! MovieCollectionViewCell
        if let selectedIndex = movieCollectionView.indexPath(for: cell) {
            let movie = movies[selectedIndex.row]
            MovieDetailViewController.movieId = movie.id
            //StickyHeaderLayout에 들어가는 movie.id , RatingImageView는 Cell에서 처리하므로 싱글톤으로 돌려야할듯
            dataManager.setId(haveId: movie.id)
            dataManager.setRating(haveRating: movie.userRating)
            
            //개선시켜보았으나 Data Loading 과정이 오래걸림 , 애초에  thumbnailImage와 posterImage를 잘 써야할듯
            //            DataManager.sharedManager.fetchMovieDetail(movieId: movie.id, completion: { [weak self] (movie) in
            //                 guard let self = self else { return }
            //                 self.movieDetail = movie
            //             })
            //             { self.showAlertController(title: "요청 실패", message: "알 수 없는 네트워크 에러 입니다.") }
            //            let thumnailImage = UIImageView()
            //            thumnailImage.imageFromUrl(movieDetail?.image , defaultImgPath: "img_placeholder")
            //            MovieDetailViewController.imageView = thumnailImage
            
            //    기존에 쓰던 방식이지만 thumbanilImage의 화질이 좋지 않음
            let thumnailImage = UIImageView()
            thumnailImage.imageFromUrl(movie.thumnailImageURL , defaultImgPath: "img_placeholder")
            MovieDetailViewController.imageView = thumnailImage
            
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
        return CGSize(width: 200, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: movieListCellID, for: indexPath) as! MovieCollectionViewCell
        let movie = movies[indexPath.row]
        cell.imageThumbnail.imageFromUrl(movie.thumnailImageURL, defaultImgPath: "img_placeholder")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 25, bottom: 20, right: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
    
}

