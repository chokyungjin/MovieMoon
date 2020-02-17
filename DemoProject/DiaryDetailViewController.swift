//
//  DiaryDetailViewController.swift
//  DemoProject
//
//  Created by 조경진 on 2019/11/16.
//  Copyright © 2019 조경진. All rights reserved.
//

import UIKit

class DiaryDetailViewController: UIViewController {
    
    //Vars..
    var movieId: Int?
    var diaryId : Int?
    var poster: String?
    var movieSearchResultData: DiaryGetList!
    var heartBtn: UIButton!
    var titleLabel: UILabel!
    var dateLabel: UILabel!
    let myTable = DiaryStickHeaderLayout()
    var DiaryDetailModel: DiaryDetailModel!
    let dateFormatter = DateFormatter()
    let realdateFormatter = DateFormatter()
    let imageName = "account"
    let image2 = UIImage(named: "account")
    var imageView = UIImageView(image: UIImage(named: "account"))
    var thumbView = UIImageView(image: UIImage(named: "account"))
    
    //init..
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addChild(myTable)
        view.addSubview(myTable.tableView)
        
        dateFormatter.locale = Locale.init(identifier: "ko_kr")
        dateFormatter.dateFormat = "yyyyMMdd"
        realdateFormatter.dateFormat = "yyyy년 MM월 dd일"
        
        //Diary Detail 통신 해야됨.
        DiaryService.shared.diaryDetail(diaryId ?? 16) {
            
            data in
            
            switch data {
            // 매개변수에 어떤 값을 가져올 것인지
            case .success(let data):
                
                // DataClass 에서 받은 유저 정보 반환
                self.DiaryDetailModel = data as? DiaryDetailModel
                self.myTable.DiaryDetailModel = data as? DiaryDetailModel
                self.myTable.titleLabel?.text = self.DiaryDetailModel.movie.korTitle
                if self.DiaryDetailModel.movie.releaseDate != "" {
                    
                    let date = self.dateFormatter.date(from: (self.DiaryDetailModel.movie.releaseDate ?? "2020년 02월 20일"))
                    let releaseDate = self.realdateFormatter.string(from: date!)
                    self.myTable.dateLabel?.text = "개봉일 : " + releaseDate
                    self.myTable.dateLabel?.textColor = .textGray
                }
                else {
                    self.myTable.dateLabel?.text = "개봉일 정보가 없습니다"
                }
                self.myTable.resultMemo = self.DiaryDetailModel.memo
                self.myTable.resultDate = self.DiaryDetailModel.createDate
                self.myTable.resultImage = self.DiaryDetailModel.diaryimages
                
                print("????????????")
                print(self.DiaryDetailModel ?? "파싱 실패!")
                print("????????????")
                
                
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
        myTable.resultDeleteDiaryId = diaryId
        
    }
    
        
    // Status Bar Hidden..
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
}


