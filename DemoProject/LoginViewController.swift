//
//  ViewController.swift
//  DemoProject
//
//  Created by 조경진 on 06/09/2019.
//  Copyright © 2019 조경진. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var signUpBut: UIButton!
    @IBOutlet weak var loginBut: UIButton!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var kakaoBut: KOLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.signUpBut.makeRounded(cornerRadius: 20)
        self.loginBut.makeRounded(cornerRadius: 20)
        self.kakaoBut.makeRounded(cornerRadius: 20)
        self.view.backgroundColor = .blackgroundBlack
        self.signUpBut.backgroundColor = .blurGray
        self.loginBut.backgroundColor = .blurGray
        self.kakaoBut.tintColor = .textGray
        self.signUpBut.tintColor = .textGray
        self.loginBut.tintColor = .textGray
        self.kakaoBut.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        initGestureRecognizer()
        
        idTextField.attributedPlaceholder = NSAttributedString(string: "아이디를 입력해주세요.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        pwTextField.attributedPlaceholder = NSAttributedString(string: "비밀번호를 입력해주세요.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
    }
    
    @IBAction func LoginBut(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RootVC") as! RootViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func SignUpBut(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterViewController
        vc.modalPresentationStyle = .fullScreen
        self.show(vc, sender: nil)
    }
  
    @IBAction func loginKakao(_ sender : UIButton){
        let session = KOSession.shared()
        
        if let s = session {
            if s.isOpen(){
                s.close()
            }
            s.open(completionHandler: {(error) in
                if error == nil {
                    print("no error")
                    if s.isOpen() {
                        KOSessionTask.userMeTask(completion: {(error , me) in
                            if let error = error as NSError? {
                                print(error)
                                //  UIAlertController.showMessage(error.description)
                            } else if let me = me as KOUserMe? {
                                print("id: \(String(describing: me.id)), \(String(describing: me.nickname)),\(String(describing: me.account)) ")
                                //id 는 카카오톡 고유의 id, nickname이 내 이름, account는 모르겠음
                                if me.nickname == "조경진" {
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let vc = storyboard.instantiateViewController(withIdentifier: "RootVC") as! RootViewController
                                    //self.present(vc, animated: true, completion: nil)
                                    //self.navigationController?.present(vc, animated: true, completion: nil)
                                    vc.modalPresentationStyle = .fullScreen
                                    self.present(vc, animated: true, completion: nil)
                                    
                                }
                            } else {
                                print("has no id")
                            }
                        })
                        print("Success")
                        
                    }
                    else {
                        print("Fail")
                    }
                }
                else {
                    print("Error login: \(error!)")
                }
            })
        }
        else {
            print("Something wrong")
        }
    }
    
    
}

extension LoginViewController: UIGestureRecognizerDelegate {
    
    func initGestureRecognizer() {
        let textFieldTap = UITapGestureRecognizer(target: self, action: #selector(handleTapTextField(_:)))
        textFieldTap.delegate = self
        view.addGestureRecognizer(textFieldTap)
    }
    
    // 다른 위치 탭했을 때 키보드 없어지는 코드
    @objc func handleTapTextField(_ sender: UITapGestureRecognizer) {
        self.idTextField.resignFirstResponder()
        self.pwTextField.resignFirstResponder()
    }
    
    func gestureRecognizer(_ gestrueRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: idTextField))! || (touch.view?.isDescendant(of: pwTextField))! {
            return false
        }
        return true
    }
}
