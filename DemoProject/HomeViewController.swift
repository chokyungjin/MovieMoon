//
//  HomeViewController.swift
//  DemoProject
//
//  Created by 조경진 on 11/09/2019.
//  Copyright © 2019 조경진. All rights reserved.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController,UISearchBarDelegate {
    
    //IB
    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var homeBoxofficeLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var hometitle: UILabel!
    
    //Variables
    let dataManager = DataManager.sharedManager
    
    
    let movieListCellID: String = "MovieListCell"
    var movies: [Movie] = []
    var movieDetail: MovieDetail?
    var movieSearchData: [SearchTitleModel] = []
    var expectationList: [WishListModel] = []
    
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
        searchBar.accessibilityAttributedHint = NSAttributedString(string: "영화 검색", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 211/255.0, green: 211/255.0, blue: 211/255.0, alpha: 1)])
        searchBar.searchTextField.textColor = UIColor.init(red: 211/255.0, green: 211/255.0, blue: 211/255.0, alpha: 1)
        
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
        setMovieListCollectionView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let MovieDetailViewController = segue.destination as? MovieDetailViewController else {return}
        
        let cell = sender as! MovieCollectionViewCell
        if let selectedIndex = movieCollectionView.indexPath(for: cell) {
//            print(selectedIndex)
            let movie = expectationList[selectedIndex.row]
            MovieDetailViewController.movieId = movie.movieId
            //StickyHeaderLayout에 들어가는 movie.id , RatingImageView는 Cell에서 처리하므로 싱글톤으로 돌려야할듯
            dataManager.setId(haveId: String(describing: movie.movieId))
//            DataManager.sharedManager.setRating(haveRating: Double((movieDetailData?.id)! / 100))
            dataManager.setRating(haveRating: 4.5)
            
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
//            let thumnailImage = UIImageView()
//            thumnailImage.imageFromUrl(movie.thumnailImageURL , defaultImgPath: "img_placeholder")
//            MovieDetailViewController.imageView = thumnailImage
            
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
        
        SearchService.shared.titleSearch(self.searchBar.text!) {
            data in
            
            switch data {
            // 매개변수에 어떤 값을 가져올 것인지
            case .success(let data):
                
                // DataClass 에서 받은 유저 정보 반환
                self.movieSearchData = data as! [SearchTitleModel]
                                
                let storyboard = UIStoryboard(name: "HomeScreen", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "SearchVC") as! MovieSearchViewController
                
                vc.movieSearchData = self.movieSearchData
                vc.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(vc, animated: true)
                
            case .requestErr(let message):
                self.simpleAlert(title: "검색 실패", message: "\(message)")
                
            case .pathErr:
                print(".pathErr")
                
            case .serverErr:
                print(".serverErr")
                
            case .networkFail:
                print("네트워크 오류")
                
            case .dbErr:
                print("디비 에러")
            }
        }
        
        self.searchBar.showsCancelButton = false
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
        
    }
    
    func setMovieListCollectionView() {
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        
        WishListService.shared.getWishList() {
                    data in
                    
                    switch data {
                    // 매개변수에 어떤 값을 가져올 것인지
                    case .success(let data):
                        
                        // DataClass 에서 받은 유저 정보 반환
                        self.expectationList = data as! [WishListModel]
                        print("????????????")
                        print(self.expectationList)
                        print("????????????")
                        self.movieCollectionView.reloadData()
                        
                        
                    case .requestErr(let message):
                        self.simpleAlert(title: "위시리스트 가져오기 실패", message: "\(message)")
                        
                    case .pathErr:
                        print(".pathErr")
                        
                    case .serverErr:
                        print(".serverErr")
                        
                    case .networkFail:
                        print("네트워크 오류")
                        
                    case .dbErr:
                        print("디비 에러")
                    }
                }
    }
    
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return expectationList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: movieListCellID, for: indexPath) as! MovieCollectionViewCell
        let movie = expectationList[indexPath.row]
        cell.imageThumbnail.imageFromUrl(movie.poster, defaultImgPath: "img_placeholder")
        cell.imageThumbnail.contentMode = .scaleAspectFit
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 40, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
}
