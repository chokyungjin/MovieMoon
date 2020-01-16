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
        "Logout"
    ]
    
    let accountLabel = UILabel()
    let nameLabel = UILabel()
    let profileImageLabel = UIImageView()
    var delegate: MenuViewDelegate?
    let picker = UIImagePickerController()
    var pickButton = UIButton()
    
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
        accountLabel.text = "Chokj1472@gmail.com"
        accountLabel.textColor = .textGray
        accountLabel.font = UIFont.boldSystemFont(ofSize: 11)
        accountLabel.backgroundColor = .clear
        
        let defaultImage = UIImage(named: "account.jpg")
        self.profileImageLabel.image = defaultImage
        self.profileImageLabel.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
        self.pickButton.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
        
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
        v.addSubview(pickButton)
        
        // ③ 생성한 뷰 v를 테이블 헤더 뷰 영역에 등록한다.
        self.tableView.tableHeaderView = v
        self.tableView.tableFooterView?.backgroundColor = UIColor.init(red: 104/255.0, green: 104.0/255.0, blue: 104.0/255.0, alpha: 1.0)
       
        picker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        pickButton.addTarget(self, action: #selector(camerabtn(_:)), for: .touchUpInside)


    }
    
    @objc func camerabtn(_ sender: Any) {
        print(11111)
        
        let alert =  UIAlertController(title: "너를보여줘!", message: "인생사진 어때?", preferredStyle: .actionSheet)
        
        let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in self.openLibrary()
        }
        
        let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in
            self.openCamera()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }
    
    @objc func cancleEvent(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func openLibrary(){
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            present(picker, animated: false, completion: nil)
        }
        else{
            print("Camera not available")
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
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


extension MenuTableViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func imagePickerController(_ _picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageLabel.image = image
            print(info)
        }
        
        dismiss(animated: true)
    }
    
}
