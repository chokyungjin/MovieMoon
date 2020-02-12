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
    
//    var movies: [Movie] = []
    var mydiaryLists: [DiaryGetList] = []
    
    
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
        self.MovielistCollectionView.reloadData()

       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let DiaryDetailViewController = segue.destination as? DiaryDetailViewController else {return}
        
        let cell = sender as! MovieCollectionViewCell
        
        if let selectedIndex = MovielistCollectionView.indexPath(for: cell) {
            //여기서 아이디로 디테일 통신 시작해야 할듯
            DiaryDetailViewController.movieId = mydiaryLists[selectedIndex.row].movieId
            DiaryDetailViewController.diaryId = mydiaryLists[selectedIndex.row].diaryId
            DiaryDetailViewController.poster = mydiaryLists[selectedIndex.row].poster
            print("#############")
            print(mydiaryLists[selectedIndex.row].poster! )
            ///http://file.koreafilm.or.kr/thm/02/00/01/05/tn_DPK002911.jpg 포스터 주소가 넘어가는데 nil으로 떠서 앱이 죽어버림
            print("#############")
    }
    
    }
    
    
   
}

extension DiaryCollectionViewController {
    
    func setMovielistCollectionView() {
        MovielistCollectionView.delegate = self
        MovielistCollectionView.dataSource = self
        let collectionViewWidth = (collectionView?.frame.width)!
        let itemWidth = ((collectionViewWidth - Storyboard.leftAndRightPaddings ) / Storyboard.numberOfItemsPerRow )
//        let itemWidth = ((view.frame.width / 3) - (Storyboard.leftAndRightPaddings * 2))
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: itemWidth, height: 200)
//        print(itemWidth)
        
        
         DiaryService.shared.getDiary() {
            data in
            
            switch data {
            // 매개변수에 어떤 값을 가져올 것인지
            case .success(let data):
                
                // DataClass 에서 받은 유저 정보 반환
                self.mydiaryLists = data as! [DiaryGetList]
                print("????????????")
                print(self.mydiaryLists)
                print("????????????")
                self.MovielistCollectionView.reloadData()
                
                
            case .requestErr(let message):
                self.simpleAlert(title: "다이어리 가져오기 실패", message: "\(message)")
                
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
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mydiaryLists.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.movieListCellID, for: indexPath) as! MovieCollectionViewCell
    
        cell.backgroundColor = .blackgroundBlack
        let movie = mydiaryLists[indexPath.row]
        
        cell.imageThumbnail.imageFromUrl(movie.poster, defaultImgPath: "img_placeholder")
        cell.imageThumbnail.contentMode = .scaleToFill
        
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           
//        let movie = diaryLists[indexPath.row]
//        let thumnailImage = self.getThumnailImage(withURL: movie.thumnailImageURL)
//        self.selectedImage = thumnailImage
//        dataManager.setImage(haveImage: self.selectedImage)
//
//        let movietitle = self.getTitle(title: movie.title)
//        self.selectedTitle = movietitle
//        dataManager.setTitle(haveTitle: self.selectedTitle)
//
//        let movieRating = self.getRating(rating: movie.userRating)
//        self.selectedRating = movieRating
//        dataManager.setRating(haveRating: self.selectedRating)
//
//        let movieDate = self.getDate(date: movie.date)
//        self.selectedDate = movieDate
//        dataManager.setDate(haveDate: self.selectedDate)
//
//        let mainStoryboard: UIStoryboard = UIStoryboard(name: "DiaryScreen", bundle: nil)
//
//            let vc = mainStoryboard.instantiateViewController(withIdentifier: "DiaryDetailVC") as! DiaryDetailViewController
//
//                    self.navigationController?.pushViewController(vc, animated: true)
//
                  
       }
    
    
}
