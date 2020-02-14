//
//  DiarySearchViewController.swift
//  DemoProject
//
//  Created by 조경진 on 2020/02/12.
//  Copyright © 2020 조경진. All rights reserved.
//

import UIKit

class DiarySearchViewController: UIViewController , UISearchBarDelegate{
    
    ///IBOutlets..
    @IBOutlet weak var searchTable: UITableView!
    
    
    ///vars...
    private var movieSearchData = [SearchTitleModel]()
    var searchBar = UISearchBar(frame: CGRect.zero)
    let movieListCellID: String = "MovieDiarySearchViewCell"
    let dateFormatter = DateFormatter()
    let realdateFormatter = DateFormatter()
    var movieDetailData: SearchDetailModel? = nil
    
    ///init....
    override func viewDidLoad() {
        super.viewDidLoad()
        self.makeNavigationItem()
        
        self.view.backgroundColor = .blackgroundBlack
        searchTable.backgroundColor = .blackgroundBlack
        searchBar.delegate = self
        searchBar.searchTextField.textColor = UIColor.init(red: 211/255.0, green: 211/255.0, blue: 211/255.0, alpha: 1)
        setMovieSearchListTableView()
        
        dateFormatter.locale = Locale.init(identifier: "ko_kr")
        dateFormatter.dateFormat = "yyyyMMdd"
        realdateFormatter.dateFormat = "yyyy년 MM월 dd일"
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let DiaryPostViewController = segue.destination as? DiaryPostViewController else {return}
        
        let cell = sender as! MovieDiarySearchViewCell
        
        if let selectedIndex = searchTable.indexPath(for: cell) {
            
            // 다이어리 등록이 엉뚱하게 되는데 이거 찍어봐야할듯 , createDate도 값대로 안들어감
            print("::::::::::::::::::::")
            print(movieSearchData[selectedIndex.row])
            print("::::::::::::::::::::")

            DiaryPostViewController.movieId = movieSearchData[selectedIndex.row].id
            DiaryPostViewController.poster = movieSearchData[selectedIndex.row].poster
            DiaryPostViewController.movieSearchResultData = movieSearchData[selectedIndex.row]
            UserDefaults.standard.set(movieSearchData[selectedIndex.row].id , forKey: "movieId")

            
        }
    }
    
    private func makeNavigationItem() {
        navigationItem.titleView = searchBar
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
        movieSearchData = []
        searchTable.reloadData()
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
                self.searchTable.reloadData()
                
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
}

extension DiarySearchViewController {
    func setMovieSearchListTableView() {
        searchTable.delegate = self
        searchTable.dataSource = self
    }
    
}

extension DiarySearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieSearchData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovieDiarySearchViewCell = tableView.dequeueReusableCell(withIdentifier: movieListCellID) as! MovieDiarySearchViewCell
        
        let movie = movieSearchData[indexPath.row]
        
        cell.backgroundColor = .blackgroundBlack
        cell.selectionStyle = .none
        cell.CountLabel.text = "\(indexPath.row + 1)."
        cell.CountLabel.textColor = .textGray
        cell.TitleLabel.text = movie.korTitle
        cell.TitleLabel.adjustsFontSizeToFitWidth = true
        cell.TitleLabel.textColor = .textGray
        
        if movie.releaseDate != "" {
            
            let date = dateFormatter.date(from: (movie.releaseDate ?? "2020년 02월 20일"))
            let releaseDate = realdateFormatter.string(from: date!)
            cell.DateLabel.text = "개봉일 : " + releaseDate
            cell.DateLabel.textColor = .textGray
            
            
        }
        else {
            cell.DateLabel.text = "개봉일 정보가 없습니다"
        }
        
        cell.NationLabel.text = movie.makingNation
        cell.NationLabel.textColor = .textGray
        cell.ThumnailImageView.imageFromUrl(movie.poster, defaultImgPath: "img_placeholder")
        cell.ThumnailImageView.contentMode = .scaleAspectFit
        
        return cell
    }
    
}

