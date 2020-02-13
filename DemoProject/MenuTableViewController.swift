//
//  MenuTableViewController.swift
//  DemoProject
//
//  Created by 조경진 on 13/09/2019.
//  Copyright © 2019 조경진. All rights reserved.
//

import UIKit
import Alamofire

private let reuseIdentifer = "SettingMenuCell"

protocol MenuViewDelegate {
    func menuViewController(_ viewController: UIViewController , didSelect indexPath: IndexPath)
}

class MenuTableViewController: UITableViewController , UITextFieldDelegate{
    
    //IBOutlet
    @IBOutlet var menuTable: UITableView!
    
    
    //Variables
    let titles = [
        "WishList",
        "Logout"
    ]
    
    let accountLabel = UILabel()
    let nameTextView = UITextField()
    var profileImageLabel = UIImageView()
    var delegate: MenuViewDelegate?
    let picker = UIImagePickerController()
    var pickButton = UIButton()
    let profileImage = UIImageView()
    var locationLink: String? = nil
    
    //init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 104/255.0, green: 104.0/255.0, blue: 104.0/255.0, alpha: 1.0)
        
        
        nameTextView.frame = CGRect(x:70, y:15, width: 100, height: 30)
        nameTextView.text = UserDefaults.standard.string(forKey: "Nickname")
        nameTextView.textColor = .textGray
        nameTextView.font = UIFont.boldSystemFont(ofSize: 15)
        nameTextView.backgroundColor = .clear
        
        accountLabel.frame = CGRect(x:70, y:30, width: 180, height: 30)
        accountLabel.textColor = .textGray
        accountLabel.font = UIFont.boldSystemFont(ofSize: 11)
        accountLabel.backgroundColor = .clear
        
        self.profileImageLabel.imageFromUrl(UserDefaults.standard.string(forKey: "src"), defaultImgPath: "account")
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
        v.addSubview(nameTextView)
        v.addSubview(profileImageLabel)
        v.addSubview(pickButton)
        
        // ③ 생성한 뷰 v를 테이블 헤더 뷰 영역에 등록한다.
        self.tableView.tableHeaderView = v
        self.tableView.tableFooterView?.backgroundColor = UIColor.init(red: 104/255.0, green: 104.0/255.0, blue: 104.0/255.0, alpha: 1.0)
        
        picker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        pickButton.addTarget(self, action: #selector(camerabtn(_:)), for: .touchUpInside)
        nameTextView.delegate = self
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.nameTextView.resignFirstResponder()
    }
    
    
    // 여기서 닉네임 변경 통신 시작
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextView {
            if nameTextView.text != UserDefaults.standard.string(forKey: "Nickname")   {
                AuthService.shared.patchNickname(nameTextView.text!) {
                    data in
                    
                    switch data {
                    // 매개변수에 어떤 값을 가져올 것인지
                    case .success(let data):
                        
                        print(data)
                        UserDefaults.standard.set(self.nameTextView.text, forKey: "Nickname")
                        
                        
                    case .requestErr(let message):
                        self.simpleAlert(title: "닉네임 변경 실패", message: "\(message)")
                        
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
                
            else {
                
            }
            
            nameTextView.resignFirstResponder()
        }
        
        
        return true
    }
    
    @objc func camerabtn(_ sender: Any) {
        
        let alert =  UIAlertController(title: "앨범 접근", message: "", preferredStyle: .actionSheet)
        let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in self.openLibrary()}
        let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in
            self.openCamera()}
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
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.menuViewController(self, didSelect: indexPath)
    }
    
    func getThumnailImage(withURL thumnailURL: String) -> UIImage? {
        guard let imageURL = URL(string: thumnailURL) else {
            return UIImage(named: "img_placeholder")
        }
        
        guard let imageData: Data = try? Data(contentsOf: imageURL) else {
            return UIImage(named: "img_placeholder")
        }
        
        return UIImage(data: imageData)
    }
    
}


extension MenuTableViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func imagePickerController(_ _picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            //로컬에 올라가는 이미지
            
            AuthService.shared.postImage(image) {
                data in
                
                switch data {
                // 매개변수에 어떤 값을 가져올 것인지
                case .success(let data):
                    
                    // PostImageModel 에서 받은 유저 정보 반환
                    let user_data = data as! PostImageModel
                    //이부분에서 로그인이 되어있는지 쿠키검사 등을 해야되나,, 여기서 막힘
                    print("user_data-----")
                    self.locationLink = user_data.location
                    
                    //location 주소를 src로 보내야함
                    //여기서 patching을 해야하나
                    AuthService.shared.patchImage(self.locationLink ?? "https://user-images.githubusercontent.com/46750574/71548829-55b7ef00-29f7-11ea-9048-343674ae2774.png") {
                        data in
                        
                        switch data {
                        // 매개변수에 어떤 값을 가져올 것인지
                        case .success(let data):
                            
                            let user_data2 = data
                            // self.profileImageLabel.image = image
                            //self.locationLink에 주소는 있는데
                           
                            print("user_data2-----")
                            print(user_data2)
                            self.profileImageLabel.imageFromUrl(self.locationLink, defaultImgPath: "account")
                            UserDefaults.standard.set(self.locationLink, forKey: "src")
                            print("user_data2-----")

                        case .requestErr(let message):
                            self.simpleAlert(title: "저장 실패", message: "\(message)")
                            
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
                    
                    UserDefaults.standard.set(self.locationLink, forKey: "src")
                    self.profileImageLabel.imageFromUrl(self.locationLink, defaultImgPath: "account")
                    print("user_data-----")

                    
                    
                case .requestErr(let message):
                    self.simpleAlert(title: "저장 실패", message: "\(message)")
                    
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
        
        dismiss(animated: true)
    }
    
}



