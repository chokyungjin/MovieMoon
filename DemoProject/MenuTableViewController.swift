//
//  MenuTableViewController.swift
//  DemoProject
//
//  Created by 조경진 on 13/09/2019.
//  Copyright © 2019 조경진. All rights reserved.
//

import UIKit

private let reuseIdentifer = "SettingMenuCell"

protocol MenuViewDelegate {
    func menuViewController(_ viewController: UIViewController , didSelect indexPath: IndexPath)
}

class MenuTableViewController: UITableViewController {
    
    //IBOutlet
    @IBOutlet var menuTable: UITableView!
    
    
    //Variables
    let titles = [
        "WishList",
        "Configuration",
        "Logout"

    ]
    
    let accountLabel = UILabel()
    let nameLabel = UILabel()
    let profileImageLabel = UIImageView()
    var delegate: MenuViewDelegate?

    
    //init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 104/255.0, green: 104.0/255.0, blue: 104.0/255.0, alpha: 1.0)
        
        
        nameLabel.frame = CGRect(x:70, y:15, width: 100, height: 30)
        nameLabel.text = "조경진"
        nameLabel.textColor = .textGray
        nameLabel.font = UIFont.boldSystemFont(ofSize: 15)
        nameLabel.backgroundColor = .clear
        
        accountLabel.frame = CGRect(x:70, y:30, width: 180, height: 30)
        accountLabel.text = "201501528@inu.ac.kr"
        accountLabel.textColor = .textGray
        accountLabel.font = UIFont.boldSystemFont(ofSize: 11)
        accountLabel.backgroundColor = .clear
        
        let defaultImage = UIImage(named: "account.jpg")
        self.profileImageLabel.image = defaultImage
        self.profileImageLabel.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
        
        //프로필 이미지 둥글게 만들기!!!!
        self.profileImageLabel.layer.cornerRadius = (self.profileImageLabel.frame.width / 2)
        self.profileImageLabel.layer.borderWidth = 0
        self.profileImageLabel.layer.masksToBounds = true
        
        
        // ② 테이블 뷰 상단에 표시될 뷰를 정의한다.
        let v = UIView()
        v.frame = CGRect(x:0, y:0, width: self.view.frame.width, height:70)
        
        v.addSubview(accountLabel)
        v.addSubview(nameLabel)
        v.addSubview(profileImageLabel)
        
        // ③ 생성한 뷰 v를 테이블 헤더 뷰 영역에 등록한다.
        self.tableView.tableHeaderView = v
        self.tableView.tableFooterView?.backgroundColor = UIColor.init(red: 104/255.0, green: 104.0/255.0, blue: 104.0/255.0, alpha: 1.0)
       

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    
    //MenuTableViewController에서 햄버거 셀 처리
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let id = "SettingMenuCell" // 재사용 큐에 등록할 식별자
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer) ?? UITableViewCell(style: .default, reuseIdentifier: reuseIdentifer)
        
        cell.backgroundColor = UIColor.init(red: 104/255.0, green: 104.0/255.0, blue: 104.0/255.0, alpha: 1.0)
        // 타이틀과 이미지를 대입한다.
        cell.textLabel?.text = self.titles[indexPath.row]
        cell.textLabel?.textColor = .textGray
        // 폰트 설정
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        delegate?.menuViewController(self, didSelect: indexPath)
        
    }
   
}
