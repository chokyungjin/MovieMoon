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
    var descriptionLabel: UILabel!
    
    //init..
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let myTable = StickyHeadersLayout()

        self.addChild(myTable)
        view.addSubview(myTable.tableView)
       
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
        //heartBtn.tintColor = .white
        heartBtn.setImage(image, for: .normal)
        heartBtn.contentMode = .scaleAspectFit
        heartBtn.bounds.size = CGSize(width: 30, height: 30)
        heartBtn.isSelected = false
       
        //heartBtn.tintColor = UIColor.white
        view.addSubview(heartBtn)
        
        titleLabel = UILabel()
        titleLabel.bounds.size = CGSize(width: 200, height: 30)
        view.addSubview(titleLabel)
        
        descriptionLabel = UILabel()
        descriptionLabel.bounds.size = CGSize(width: 200, height: 30)
        view.addSubview(descriptionLabel)
        
        

        
        myTable.imageView = imageView
        myTable.thumbView = thumbView
        myTable.heartBtn = heartBtn
        myTable.titleLabel = titleLabel
        myTable.descriptionLabel = descriptionLabel
        
        heartBtn.addTarget(self, action: #selector(heartClick), for: .touchUpInside)

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
