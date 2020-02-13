//
//  DiaryDetailViewController.swift
//  DemoProject
//
//  Created by 조경진 on 2019/11/16.
//  Copyright © 2019 조경진. All rights reserved.
//

import UIKit

class DiaryPostViewController: UIViewController {
    
    //Vars..
    var movieId: Int?
    var diaryId : Int?
    var poster: String?
    var movieSearchResultData: SearchTitleModel!
    var heartBtn: UIButton!
    var titleLabel: UILabel!
    var dateLabel: UILabel!
    let myTable = DiaryPostStickyHeaderLayout()
    
    let imageName = "account"
    let image2 = UIImage(named: "account")
    var imageView = UIImageView(image: UIImage(named: "account"))
    var thumbView = UIImageView(image: UIImage(named: "account"))
    
    //init..
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.addChild(myTable)
        view.addSubview(myTable.tableView)
        
        //Diary Detail 통신 해야됨.
        //movieId, diaryId 가지고 통신해야됨
        
        
        //이건 DiaryDetail이 아님
        imageView.imageFromUrl(poster, defaultImgPath: "img_placeholder")
        thumbView.imageFromUrl(poster, defaultImgPath: "img_placeholder")
        
        imageView.frame = CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: view.bounds.height / 3))
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        
        //thumbView = UIImageView(image: imageView.image)
        thumbView.contentMode = .scaleAspectFit
        thumbView.clipsToBounds = true
        view.addSubview(thumbView)
        
        heartBtn = UIButton(type: .custom)
        let image = UIImage(named: "heart")?.withRenderingMode(.alwaysTemplate)
        heartBtn.setImage(image, for: .normal)
        heartBtn.tintColor = .white
        heartBtn.contentMode = .scaleAspectFit
        heartBtn.bounds.size = CGSize(width: 30, height: 30)
        heartBtn.isSelected = false
        heartBtn.tintColor = UIColor.clear
        //view.addSubview(heartBtn)
        
        titleLabel = UILabel()
        titleLabel.bounds.size = CGSize(width: 200, height: 30)
        view.addSubview(titleLabel)
        
        dateLabel = UILabel()
        dateLabel.bounds.size = CGSize(width: 200, height: 30)
        view.addSubview(dateLabel)
        
        myTable.imageView = imageView
        myTable.thumbView = thumbView
        myTable.titleLabel = titleLabel
        myTable.dateLabel = dateLabel
        
    }
    
    // Status Bar Hidden..
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func inputCall() {
        print(movieSearchResultData.korTitle, movieSearchResultData.releaseDate)

    }
    
    
    
}


