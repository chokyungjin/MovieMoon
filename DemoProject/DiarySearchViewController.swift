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
    
    
    ///init....
    override func viewDidLoad() {
        super.viewDidLoad()
        self.makeNavigationItem()
        
        self.view.backgroundColor = .blackgroundBlack
        searchTable.backgroundColor = .blackgroundBlack
        searchBar.delegate = self
        searchBar.accessibilityAttributedHint = NSAttributedString(string: "영화, 배우, 감독으로 검색", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 211/255.0, green: 211/255.0, blue: 211/255.0, alpha: 1)])
        searchBar.searchTextField.textColor = UIColor.init(red: 211/255.0, green: 211/255.0, blue: 211/255.0, alpha: 1)
        setMovieSearchListTableView()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let DiaryDetailViewController = segue.destination as? DiaryDetailViewController else {return}
        
        let cell = sender as! MovieDiarySearchViewCell
        
        if let selectedIndex = searchTable.indexPath(for: cell) {
            //여기서 아이디로 디테일 통신 시작해야 할듯
            DiaryDetailViewController.movieId = movieSearchData[selectedIndex.row].id
            //방법 0.. select된 데이터 통으로 넘기려고했음.
            
            DiaryDetailViewController.movieSearchResultData = movieSearchData[selectedIndex.row]
            print("#############")
            print(movieSearchData[selectedIndex.row].poster! )
            ///http://file.koreafilm.or.kr/thm/02/00/01/05/tn_DPK002911.jpg 포스터 주소가 넘어가는데 nil으로 떠서 앱이 죽어버림
            print("#############")
        
            //방법 2..
//            DiaryDetailViewController.imageView.imageFromUrl(movieSearchData[selectedIndex.row].poster!, defaultImgPath: "img_placeholder")
                    
            
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
                //                print(self.movieSearchData)
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
        cell.DateLabel.text = "개봉일 : " + movie.releaseDate!
        cell.DateLabel.textColor = .textGray
        cell.NationLabel.text = movie.makingNation
        cell.NationLabel.textColor = .textGray
        cell.ThumnailImageView.imageFromUrl(movie.poster, defaultImgPath: "img_placeholder")
        cell.ThumnailImageView.contentMode = .scaleAspectFit
        
        return cell
    }
    
}

