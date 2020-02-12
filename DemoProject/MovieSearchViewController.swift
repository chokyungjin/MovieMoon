//
//  SearchViewController.swift
//  DemoProject
//
//  Created by 조경진 on 2020/02/11.
//  Copyright © 2020 조경진. All rights reserved.
//
import Foundation

class MovieSearchViewController: UIViewController {
    
    //IBOut....
    @IBOutlet weak var MovieSearchTableView: UITableView!
    
    //Vars..
    var movieSearchData: [SearchTitleModel] = []
    let dataManager = DataManager.sharedManager
    let movieListCellID: String = "MovieSearchCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(movieSearchData)
        setMovieSearchListTableView()
        self.view.backgroundColor = .blackgroundBlack
        MovieSearchTableView.backgroundColor = .blackgroundBlack
        navigationItem.title = "검색 결과"
    }
    
    func navigationSetup() { //네비게이션 투명색만들기
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 55/255.0, green: 55.0/255.0, blue: 55.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "roundArrowBackIosBlack48Pt1X")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "roundArrowBackIosBlack48Pt1X")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .black
        //투명하게 만드는 공식처럼 기억하기
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        //네비게이션바의 백그라운드색 지정. UIImage와 동일
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //shadowImage는 UIImage와 동일. 구분선 없애줌.
        self.navigationController?.navigationBar.isTranslucent = true
        //false면 반투명이다.
        self.navigationController?.view.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        //뷰의 배경색 지정
        //        self.navigationController?.navigationBar.topItem?.title = "Home"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.init(red: 211/255.0, green: 211.0/255.0, blue: 211.0/255.0, alpha: 1.0)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let MovieDetailViewController = segue.destination as? MovieDetailViewController else {return}
        
        let cell = sender as! MovieSearchTableViewCell
        
        if let selectedIndex = MovieSearchTableView.indexPath(for: cell) {
            //여기서 아이디로 디테일 통신 시작해야 할듯
            MovieDetailViewController.movieId = movieSearchData[selectedIndex.row].id
            
            
            
            //            MovieDetailViewController.movieId = String(describing: movie.id)
            //            //StickyHeaderLayout에 들어가는 movie.id , RatingImageView는 Cell에서 처리하므로 싱글톤으로 돌려야할듯
            //            dataManager.setId(haveId:  String(describing: movie.id))
            //            dataManager.setRating(haveRating: Double(movie.id))
            //
            //            //개선시켜보았으나 Data Loading 과정이 오래걸림 , 애초에  thumbnailImage와 posterImage를 잘 써야할듯
            //            //            DataManager.sharedManager.fetchMovieDetail(movieId: movie.id, completion: { [weak self] (movie) in
            //            //                 guard let self = self else { return }
            //            //                 self.movieDetail = movie
            //            //             })
            //            //             { self.showAlertController(title: "요청 실패", message: "알 수 없는 네트워크 에러 입니다.") }
            //            //            let thumnailImage = UIImageView()
            //            //            thumnailImage.imageFromUrl(movieDetail?.image , defaultImgPath: "img_placeholder")
            //            //            MovieDetailViewController.imageView = thumnailImage
            //
            //            //    기존에 쓰던 방식이지만 thumbanilImage의 화질이 좋지 않음
            //            let thumnailImage = UIImageView()
            //            thumnailImage.imageFromUrl(movie.poster , defaultImgPath: "img_placeholder")
            //            MovieDetailViewController.imageView = thumnailImage
            
        }
    }
    
    
}

extension MovieSearchViewController {
    func setMovieSearchListTableView() {
        MovieSearchTableView.delegate = self
        MovieSearchTableView.dataSource = self
    }
    
}

extension MovieSearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieSearchData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovieSearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: movieListCellID) as! MovieSearchTableViewCell
        
        let movie = movieSearchData[indexPath.row]
        
        cell.backgroundColor = .blackgroundBlack
        cell.selectionStyle = .none
        cell.countLabel.text = "\(indexPath.row + 1)."
        cell.countLabel.textColor = .textGray
        cell.titleLabel.text = movie.korTitle
        cell.titleLabel.adjustsFontSizeToFitWidth = true
        cell.titleLabel.textColor = .textGray
        cell.dateLabel.text = "개봉일 : " + movie.releaseDate!
        cell.dateLabel.textColor = .textGray
        cell.nationLabel.text = movie.makingNation
        cell.nationLabel.textColor = .textGray
        cell.thumnailImageView.imageFromUrl(movie.poster, defaultImgPath: "img_placeholder")
        cell.thumnailImageView.contentMode = .scaleAspectFit
        
        return cell
    }
    
}

