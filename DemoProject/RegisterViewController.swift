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
    @IBOutlet weak var birthDayTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var pwCheckTextField: UITextField!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var SignUpBut: UIButton!
    @IBOutlet weak var CancelBut: UIButton!
    
    
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
    
 
    @IBAction func nameInput(_ sender: UITextField) {
        if validate1(text: sender.text!){
            count += 1
            print(count)
            
        }
    }
    @IBAction func birthDatInput(_ sender: UITextField) {
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
    }
    
    @IBAction func passwordCheck(_ sender: UITextField) {
        if validate5(text: sender.text!) && pwCheckTextField.text == pwTextField.text {
            count += 1
            print(count)
        }
    }
    @IBAction func nickNameInput(_ sender: UITextField) {
        
        if count >= 4 && nickNameTextField.text != "" {
            //            SignUpBut.setImage(registerOk, for: UIControlState.normal)
            //나중에 image로 바꿔보자!
            SignUpBut.isEnabled = true
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
    
    override func viewDidLoad() {
        SignUpBut.isEnabled = false
        super.viewDidLoad()
      // nameTextField.returnKeyType = .next
        nameTextField.delegate = self
        birthDayTextField.delegate = self
        idTextField.delegate = self
        pwTextField.delegate = self
        pwCheckTextField.delegate = self
        nickNameTextField.delegate = self

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        //return 버튼 누르면 키보드 내려갈수있게 설정.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            birthDayTextField.becomeFirstResponder() // id입력시에는 enter가 화살표 표시로 다음 텍스트 입력으로 이동
        } else if textField == birthDayTextField{
            idTextField.becomeFirstResponder()    //pass입력시에는 enter가 return으로 표시
        }
        else if textField == idTextField{
            pwTextField.becomeFirstResponder()    //pass입력시에는 enter가 return으로 표시
        }
        else if textField == pwTextField{
            pwCheckTextField.becomeFirstResponder()    //pass입력시에는 enter가 return으로 표시
        }
        else if textField == pwCheckTextField{
            nickNameTextField.resignFirstResponder()    //pass입력시에는 enter가 return으로 표시
        }
        return true
    }

}
