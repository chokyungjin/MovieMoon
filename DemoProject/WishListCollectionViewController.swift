//
//  WishListViewController.swift
//  DemoProject
//
//  Created by 조경진 on 2019/10/30.
//  Copyright © 2019 조경진. All rights reserved.
//

import UIKit


class WishListCollectionViewController: UICollectionViewController {
    
    //IBOutlets..
    @IBOutlet weak var WishListCollectionView: UICollectionView!
    
    //Vars..
    var getWishList: [WishListModel] = []
    struct Storyboard {
        static let leftAndRightPaddings: CGFloat = 5.0
        static let numberOfItemsPerRow: CGFloat = 3.0
        static let movieListCellID: String = "WishListCell"
        
    }
    
    
    //Inits..
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blackgroundBlack
        WishListCollectionView.backgroundColor = .blackgroundBlack
        navigationItem.title = "WishList"
        setMovielistCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.WishListCollectionView.reloadData()

    }
    
    func setMovielistCollectionView() {
        
        WishListCollectionView.delegate = self
        WishListCollectionView.dataSource = self
        let collectionViewWidth = (collectionView?.frame.width)!
        let itemWidth = ((collectionViewWidth - Storyboard.leftAndRightPaddings * 2 ) / Storyboard.numberOfItemsPerRow )
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: itemWidth, height: 200)
        
        
        WishListService.shared.getWishList() {
            data in
            
            switch data {
            // 매개변수에 어떤 값을 가져올 것인지
            case .success(let data):
                
                // DataClass 에서 받은 유저 정보 반환
                self.getWishList = data as! [WishListModel]
                print("????????????")
                print(self.getWishList)
                print("????????????")
                self.WishListCollectionView.reloadData()
                
                
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
        print(getWishList.count)
        return getWishList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.movieListCellID, for: indexPath) as! WishListCollectionViewCell
        
        cell.backgroundColor = .blackgroundBlack
        let movie = getWishList[indexPath.row]
        
        cell.ImageThumbnail.imageFromUrl(movie.poster, defaultImgPath: "img_placeholder")
        cell.ImageThumbnail.contentMode = .scaleToFill
        
        return cell
    }
    
    
}


