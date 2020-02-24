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
    let dateFormatter = DateFormatter()
    let realdateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMovieSearchListTableView()
        self.view.backgroundColor = .blackgroundBlack
        MovieSearchTableView.backgroundColor = .blackgroundBlack
        navigationItem.title = "검색 결과"
       // navigationItem.backBarButtonItem?.tintColor = .white
        self.navigationItem.backBarButtonItem?.tintColor = .white

        dateFormatter.locale = Locale.init(identifier: "ko_kr")
        dateFormatter.dateFormat = "yyyyMMdd"
        realdateFormatter.dateFormat = "yyyy년 MM월 dd일"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let MovieDetailViewController = segue.destination as? MovieDetailViewController else {return}
        
        let cell = sender as! MovieSearchTableViewCell
        
        if let selectedIndex = MovieSearchTableView.indexPath(for: cell) {
            //여기서 아이디로 디테일 통신 시작해야 할듯
            MovieDetailViewController.movieId = movieSearchData[selectedIndex.row].id
            
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
        
        if movie.releaseDate! != "" {
            
            let date = dateFormatter.date(from: movie.releaseDate!)
            let releaseDate = realdateFormatter.string(from: date!)
            cell.dateLabel.text = "개봉일 : " + releaseDate

        }
        else {
            cell.dateLabel.text = "개봉일 정보가 없습니다"
        }
        
        cell.dateLabel.textColor = .textGray
        cell.nationLabel.text = movie.makingNation
        cell.nationLabel.textColor = .textGray
        cell.thumnailImageView.imageFromUrl(movie.poster, defaultImgPath: "img_placeholder")
        cell.thumnailImageView.contentMode = .scaleAspectFit
        
        return cell
    }
    
    
    
}


