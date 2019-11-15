//
//  MovieDetailViewController.swift
//  DemoProject
//
//  Created by 조경진 on 02/10/2019.
//  Copyright © 2019 조경진. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    
    //Vars..
    var thumbView: UIImageView!
    var heartBtn: UIButton!
    var imageView: UIImageView!
    var titleLabel: UILabel!
    var dateLabel: UILabel!
    
    //init..
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = UIColor.init(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)

        let myTable = StickyHeadersLayout()

        self.addChild(myTable)
        view.addSubview(myTable.tableView)
       
       // let url = URL(string: "http://file.koreafilm.or.kr/thm/02/00/01/46/tn_DPK004440.JPG")
        //let data = try! Data(contentsOf: url!)
        // self.profileImageLabel.image = UIImage(data: data)
        
        imageView = UIImageView(image: DataManager.sharedManager.getImage())
        imageView.frame = CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: view.bounds.height / 4))

        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        
       
        
        view.addSubview(imageView)
        
        
        thumbView = UIImageView(image: imageView.image)
        thumbView.contentMode = .scaleAspectFit
        thumbView.clipsToBounds = true
        view.addSubview(thumbView)
        
        heartBtn = UIButton(type: .custom)
        let image = UIImage(named: "heart")?.withRenderingMode(.alwaysTemplate)
        heartBtn.setImage(image, for: .normal)
        heartBtn.contentMode = .scaleAspectFit
        heartBtn.bounds.size = CGSize(width: 30, height: 30)
        heartBtn.isSelected = false
        view.addSubview(heartBtn)
        heartBtn.addTarget(self, action: #selector(heartClick), for: .touchUpInside)
        
        titleLabel = UILabel()
        titleLabel.bounds.size = CGSize(width: 200, height: 30)
        view.addSubview(titleLabel)
        
        dateLabel = UILabel()
        dateLabel.bounds.size = CGSize(width: 200, height: 30)
        view.addSubview(dateLabel)
        
        
        myTable.imageView = imageView
        myTable.thumbView = thumbView
        myTable.heartBtn = heartBtn
        myTable.titleLabel = titleLabel
        myTable.dateLabel = dateLabel
        

    }
    
    @objc func heartClick(sender: UIButton) {
           
        print(heartBtn.isSelected)
        
        if (heartBtn.isSelected) == false{
        let image = UIImage(named: "like")?.withRenderingMode(.alwaysTemplate)
        heartBtn!.setImage(image, for: .normal)
        heartBtn.isSelected = true
        let Alert = UIAlertController(title: "", message: "heart", preferredStyle: .alert)
        Alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
        }))
        present(Alert, animated: true, completion: nil)
        }
        else if heartBtn.isSelected
        {
            let image = UIImage(named: "heart")?.withRenderingMode(.alwaysTemplate)
            heartBtn!.setImage(image, for: .normal)
            heartBtn.isSelected = false
            let Alert = UIAlertController(title: "", message: "cancel", preferredStyle: .alert)
            Alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            }))
            present(Alert, animated: true, completion: nil)
        }
        
       }
       
}
