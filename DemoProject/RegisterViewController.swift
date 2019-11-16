//
//  RegisterViewController.swift
//  club_INU
//
//  Created by 조경진 on 12/08/2019.
//  Copyright © 2019 dong.gyun. All rights reserved.
//

import UIKit
//import Toast_Swift
class RegisterViewController: UIViewController,UITextFieldDelegate {
    
    
    var count : Int = 0

   //IBOutlet..
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var pwCheckTextField: UITextField!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var SignUpBut: UIButton!
    @IBOutlet weak var CancelBut: UIButton!
    
    //SignUp_Check_Func..
     func validate1(text: String) -> Bool {
        return text != ""
    }
     func validate2(text: String) -> Bool {
        return text != ""
    }
    func validate3(text: String) -> Bool {
        return text != ""
    }
    func validate4(text: String) -> Bool {
        return text != ""
    }
    func validate5(text: String) -> Bool {
        return text != ""
    }
    func validate6(text: String) -> Bool {
        return text != ""
    }
    
    //inits..
    override func viewDidLoad() {
        super.viewDidLoad()
        SignUpBut.isEnabled = false
        nameTextField.delegate = self
        idTextField.delegate = self
        pwTextField.delegate = self
        pwCheckTextField.delegate = self
        nickNameTextField.delegate = self
        
        //Placeholder_Colors..
        idTextField.attributedPlaceholder = NSAttributedString(string: "아이디를 입력하세요.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 211/255.0, green: 211/255.0, blue: 211/255.0, alpha: 1)])
        nickNameTextField.attributedPlaceholder = NSAttributedString(string: "닉네임을 입력하세요.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 211/255.0, green: 211/255.0, blue: 211/255.0, alpha: 1)])
        pwTextField.attributedPlaceholder = NSAttributedString(string: "비밀번호를 입력하세요.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 211/255.0, green: 211/255.0, blue: 211/255.0, alpha: 1)])
        nameTextField.attributedPlaceholder = NSAttributedString(string: "이름를 입력하세요.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 211/255.0, green: 211/255.0, blue: 211/255.0, alpha: 1)])
        pwCheckTextField.attributedPlaceholder = NSAttributedString(string: "비밀번호를 다시 입력하세요.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 211/255.0, green: 211/255.0, blue: 211/255.0, alpha: 1)])
        
        self.view.backgroundColor = .blackgroundBlack
        self.SignUpBut.makeRounded(cornerRadius: 20)
        self.CancelBut.makeRounded(cornerRadius: 20)
        self.SignUpBut.backgroundColor = .blurGray
        self.CancelBut.backgroundColor = .blurGray
        self.SignUpBut.tintColor = .textGray
        self.CancelBut.tintColor = .textGray
        
        
    }
    
    //IBAction..
    @IBAction func nameInput(_ sender: UITextField) {
        if validate1(text: sender.text!){
            count += 1
            print(count)
            
        }
    }
    
    @IBAction func nickNameInput(_ sender: UITextField) {
        
        if validate2(text: sender.text!){
                   count += 1
                   print(count)
                   
               }
    }
    
    @IBAction func idInput(_ sender: UITextField) {
        if validate3(text: sender.text!){
            count += 1
            print(count)
        }
    }
   
    @IBAction func pwInput(_ sender: UITextField) {
        if validate4(text: sender.text!){
            count += 1
            print(count)
            
        }
        if count >= 3 && nickNameTextField.text != "" {
            //SignUpBut.setImage(registerOk, for: UIControlState.normal)
            //나중에 image로 바꿔보자!
            SignUpBut.isEnabled = true
        }
    }
    
    @IBAction func passwordCheck(_ sender: UITextField) {
        if validate5(text: sender.text!) && pwCheckTextField.text == pwTextField.text {
            count += 1
            print(count)
        }
    }
    
    @IBAction func SignUp(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVc") as? LoginViewController {
            
            self.present(vc, animated: true, completion: nil)   // 식별자 가르키는 곳으로 이동
        }
    
    }
    @IBAction func CancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        //return 버튼 누르면 키보드 내려갈수있게 설정.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            nickNameTextField.becomeFirstResponder()
        }
        else if textField == nickNameTextField {
            idTextField.becomeFirstResponder()
        }
        else if textField == idTextField{
            pwTextField.becomeFirstResponder()
        }
        else if textField == pwTextField{
            pwCheckTextField.becomeFirstResponder()
        }
        else if textField == pwCheckTextField {
            pwCheckTextField.resignFirstResponder()
        }
        
        return true
    }

}
