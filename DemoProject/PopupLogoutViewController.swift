//
//  PopUpLogOutViewController.swift
//  club_INU
//
//  Created by 황동주 on 2018. 2. 6..
//  Copyright © 2018년 dong.gyun. All rights reserved.
//

import UIKit

class PopUpLogOutViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PopupView.layer.cornerRadius = 10   //팝업뷰 둥글게 설정
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)//배경색 설정
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var PopupView: UIView!   //popupView 선언
    @IBAction func ClosePopup(_ sender: Any) {
        
//        let alert = UIAlertController(title:"로그아웃 하시겠습니까?",message: "",preferredStyle: .alert)
//        
//        alert.addAction(UIAlertAction(title: "예", style: .default, handler: { action in
//            
//            let urlString: String = APIConstants.LogoutURL
//            guard let requestURL = URL(string: urlString) else { return }
//            var request = URLRequest(url: requestURL)
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.httpMethod = "POST"
//            let session = URLSession.shared
//            let task = session.dataTask(with: request) { (responseData, response, responseError) in
//                guard responseError == nil else { return }
//            }
//            task.resume()
//            
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
//            vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
//            self.present(vc, animated: true, completion: nil)   // 식별자 가르키는 곳으로 이동
//        }))
//        alert.addAction(UIAlertAction(title: "아니오", style: .cancel, handler: nil))
//        
//        UserDefaults.standard.set(nil , forKey: "Nickname")
//        UserDefaults.standard.set(nil , forKey: "Id")
//        UserDefaults.standard.set(nil , forKey: "userId")
//        UserDefaults.standard.set(nil , forKey: "src")
//        UserDefaults.standard.set(nil , forKey: "createdAt")
//        UserDefaults.standard.set(nil , forKey: "updatedAt")
//        
        
    }
    //로그아웃 팝업
    @IBAction func LogoutPopup(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(vc, animated: true, completion: nil)   // 식별자 가르키는 곳으로 이동
        
    }
    
}
