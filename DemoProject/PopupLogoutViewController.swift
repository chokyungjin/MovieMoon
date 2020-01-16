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
     
        let logoutAlert = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)

                      logoutAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                          print("검색확인")
                         
                      }))
                      present(logoutAlert, animated: true, completion: nil)
        

    }
    //로그아웃 팝업
    @IBAction func LogoutPopup(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
            self.present(vc, animated: true, completion: nil)   // 식별자 가르키는 곳으로 이동
        
    }
    
}
