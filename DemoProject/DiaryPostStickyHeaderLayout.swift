//
//  DiaryStickHeaderLayout.swift
//  DemoProject
//
//  Created by 조경진 on 2019/11/16.
//  Copyright © 2019 조경진. All rights reserved.
//

import UIKit

class DiaryPostStickyHeaderLayout: UITableViewController ,UIPickerViewDelegate, UITextFieldDelegate{
    
    //vars..
    var imageView: UIImageView? = nil
    var thumbView: UIImageView? = nil
    var profileImage : [UIImage] = [UIImage(named: "img_placeholder")!, UIImage(named: "img_placeholder")!, UIImage(named: "img_placeholder")!]
    var titleLabel: UILabel? = nil
    var dateLabel: UILabel? = nil
    var movies: [Movie] = []
    var myDateField: UITextField = .init()
    let caLayer: CAGradientLayer = CAGradientLayer()
    let picker = UIImagePickerController()
    let dateFormatter = DateFormatter()
    let realdateFormatter = DateFormatter()
    var movieDetailData: SearchDetailModel? = nil
    
    
    //Post하면서 파라미터로 들어갈 Var..
    var userId: Int? = UserDefaults.standard.integer(forKey: "Id")
    var movieId:String? = UserDefaults.standard.string(forKey: "movieId")
    var memo:String? = nil
    var createDate:String? = UserDefaults.standard.string(forKey: "createDate")
    var src: [String]? = nil
    var rating:String? = nil
    
    
    //inits..
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(DiaryResultFirstCell.self, forCellReuseIdentifier: "cell1")
        tableView.register(DiaryResultSecondCell.self, forCellReuseIdentifier: "cell2")
        tableView.contentInset = UIEdgeInsets(top: view.frame.height / 3, left: 0, bottom: 0, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .blackgroundBlack
        picker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //  createGradient()
        registerForKeyboardNotifications()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        unregisterForKeyboardNotifications()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        //return 버튼 누르면 키보드 내려갈수있게 설정.
    }
    
    // keyboard가 보여질 때 어떤 동작을 수행
    @objc func keyboardWillShow(_ notification: NSNotification) {
        
        self.view.layoutIfNeeded()
    }
    
    // keyboard가 사라질 때 어떤 동작을 수행
    @objc func keyboardWillHide(_ notification: NSNotification) {
        
        self.view.layoutIfNeeded()
    }
    
    
    // observer
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func createGradient() {
        // print(111)
        caLayer.startPoint = CGPoint(x: 0.5, y: 0)
        caLayer.endPoint = CGPoint(x: 0.5, y: 1)
        caLayer.locations = [0,1]
        caLayer.frame = imageView!.frame
        caLayer.colors = [UIColor.clear.cgColor, UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor]
        imageView!.layer.addSublayer(caLayer)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == [0,0] {
            return 150
        }
        else if indexPath == [1,0] {
            return 670
        }
        
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath == [0,0]{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! DiaryResultFirstCell
            
            cell.backgroundColor = .blackgroundBlack
            cell.myRatingLabel.text = "Rate 0점"
            cell.myRatingLabel.textColor = .textGray
            cell.myDateLabel.text = "Date"
            cell.myDateLabel.textColor = .textGray
            cell.myDateField.layer.addBorder([.bottom], color: .textGray, width: 1)
            cell.selectionStyle = .none
            
            rating = cell.myRatingLabel.text
            print(rating)
            
            return cell
            
        }
            
        else if indexPath == [1,0] {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! DiaryResultSecondCell
            
            cell.delegate = self
            
            cell.stillcutImage.image = profileImage[0]
            cell.stillcutImage2.image = profileImage[1]
            cell.stillcutImage3.image = profileImage[2]
            
            cell.plotField.text = "지금까지 이런 맛은 없었다. 이것은 갈비인가 통닭인가, 예 수원 왕갈비 통닭입니다!"
            cell.plotField.backgroundColor = .color130
            cell.plotField.textColor = .textGray
            cell.plotField.isUserInteractionEnabled = true
            cell.selectionStyle = .none
            cell.backgroundColor = .blackgroundBlack
            
            //이미지 또 경로로 전송해야됨
            // src = [cell.stillcutImage.image , cell.stillcutImage2.image, cell.stillcutImage3.image]
            memo = cell.plotField.text
            
            return cell
        }
        else {
            return UITableViewCell()
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let imageView = imageView, let thumbView = thumbView, let titleLabel = titleLabel, let dateLabel = dateLabel else{return}
        
        let stretchedHeight = -scrollView.contentOffset.y + 10
        let thumbPosition = stretchedHeight - thumbView.bounds.height - 50
        
        imageView.frame = CGRect(origin: .zero, size: CGSize(width: scrollView.bounds.width, height: stretchedHeight))
        thumbView.frame = CGRect(origin: CGPoint(x: 20, y: thumbPosition), size: CGSize(width: 99.0, height: 141.0))
        
        
        titleLabel.frame = CGRect(origin: CGPoint(x: scrollView.bounds.width - 250, y: thumbView.frame.origin.y + 70), size: titleLabel.bounds.size)
        titleLabel.textColor = .textGray
        
        //        if movieDetailData?.releaseDate! != "" {
        //
        //            let date = dateFormatter.date(from: (movieDetailData?.releaseDate!)!)
        //            let releaseDate = realdateFormatter.string(from: date!)
        //            dateLabel.text = "개봉일 : " + releaseDate
        //            dateLabel.textColor = .textGray
        //
        //        }
        //        else {
        //            dateLabel.text = "개봉일 정보가 없습니다"
        //        }
        
        dateLabel.frame = CGRect(origin: CGPoint(x: scrollView.bounds.width - 250, y: thumbView.frame.origin.y + 100), size: dateLabel.bounds.size)
        
        dateLabel.textColor = .textGray
        
        
        caLayer.frame = CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: stretchedHeight))
        
    }
}

extension DiaryPostStickyHeaderLayout: PlusActionDelegate {
    
    
    func didClickedOk() {
        //다이어리 post 하는 통신 여기서 하면 됨.
        print(userId ?? 1 ,movieId ?? "2",memo ?? "3",createDate ?? "4")
        DiaryService.shared.diaryPost(userId ?? 1 ,movieId ?? "2",memo ?? "3",createDate ?? "4"){
            data in
            
            switch data {
            // 매개변수에 어떤 값을 가져올 것인지
            case .success(let data):
                
                // DataClass 에서 받은 유저 정보 반환
                // let user_data = data as! DataClass
                
                print("등록 성공")
                let addAlert = UIAlertController(title: "다이어리 추가", message: "", preferredStyle: .alert)
                
                addAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action: UIAlertAction!) in
                    print("확인")
                }))
                self.present(addAlert, animated: true, completion: nil)
                
                self.dismiss(animated: true, completion: nil)

            case .requestErr(let message):
                self.simpleAlert(title: "등록 실패", message: "\(message)")
                
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
    
    func didClickedCancel() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func didClickedPlus() {
        print(11111)
        
        let alert =  UIAlertController(title: "", message: "다이어리 사진 추가", preferredStyle: .actionSheet)
        
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
    
}

// image 가 cell.image에 적용되지 않음!
extension DiaryPostStickyHeaderLayout : UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func imagePickerController(_ _picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            if profileImage[0] == UIImage(named: "img_placeholder") {
                profileImage[0] = image
            }
            else if profileImage[1] == UIImage(named: "img_placeholder") {
                profileImage[1] = image
            }
            else if profileImage[2] == UIImage(named: "img_placeholder") {
                profileImage[2] = image
            }
            
            print(image)
        }
        
        picker.dismiss(animated: true)
        tableView.reloadData()
        
    }
    
}