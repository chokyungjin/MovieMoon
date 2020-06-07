//
//  HomeViewController.swift
//  DemoProject
//
//  Created by 조경진 on 11/09/2019.
//  Copyright © 2019 조경진. All rights reserved.
//

//이걸 4개읠 뷰 컨트롤러로 분리시켜줘야함!!!
import UIKit

class RecommendViewController: UICollectionViewController {
    //RecommendVC
    @IBOutlet var RecommendListCollectionView: UICollectionView!
    
    // MARK: - Properties
    var getRecommendList: [RecommendModel] = []
    
    struct Storyboard {
        static let leftAndRightPaddings: CGFloat = 5.0
        static let numberOfItemsPerRow: CGFloat = 3.0
        static let movieListCellID: String = "RecommendListCell"
        
    }

    // MARK: - Init    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blackgroundBlack
        RecommendListCollectionView.backgroundColor = .blackgroundBlack
        setMovielistCollectionView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.RecommendListCollectionView.reloadData()
    }
    
    func setMovielistCollectionView() {
            
            RecommendListCollectionView.delegate = self
            RecommendListCollectionView.dataSource = self
            let collectionViewWidth = (collectionView?.frame.width)!
            let itemWidth = ((collectionViewWidth - Storyboard.leftAndRightPaddings * 2 ) / Storyboard.numberOfItemsPerRow )
            
            let layout = collectionViewLayout as! UICollectionViewFlowLayout
            layout.itemSize = CGSize(width: itemWidth, height: 175)
            
            
            RecommendService.shared.getRecommendList() {
                        data in
                        
                        switch data {
                        // 매개변수에 어떤 값을 가져올 것인지
                        case .success(let data):
                            
                            // DataClass 에서 받은 유저 정보 반환
                            self.getRecommendList = data as! [RecommendModel]
                            print("????????????")
                            print(self.getRecommendList)
                            print("????????????")
                            self.RecommendListCollectionView.reloadData()
                            
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
            print(getRecommendList.count)
            return getRecommendList.count
        }
        
        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.movieListCellID, for: indexPath) as! RecommendListCollectionViewCell
            
            cell.backgroundColor = .blackgroundBlack
            let movie = getRecommendList[indexPath.row]
            
            cell.imageThumbnail.imageFromUrl(movie.movie.poster, defaultImgPath: "img_placeholder")
            cell.imageThumbnail.contentMode = .scaleToFill
            
            return cell
        }
        
        
    }



   

