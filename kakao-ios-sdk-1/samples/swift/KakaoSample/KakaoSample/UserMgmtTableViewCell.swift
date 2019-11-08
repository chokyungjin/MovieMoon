/**
* Copyright 2015-2018 Kakao Corp.
*
* Redistribution and modification in source or binary forms are not permitted without specific prior written permission.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*    http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import UIKit

class UserMgmtTableViewCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var name: InsetableTextField!
    @IBOutlet weak var nickName: InsetableTextField!
    @IBOutlet weak var age: InsetableTextField!
    @IBOutlet weak var gender: InsetableTextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
        name.inset = 10
        nickName.inset = 10
        age.inset = 10
        gender.inset = 10
    }
    
    func setMe(me: KOUserMe?) -> Void {
        self.thumbnail.image = UIImage(named: "PlaceHolder")
        
        if let me = me {
            
            if let email = me.account?.email {
                self.email.text = email
            } else if me.account?.emailNeedsAgreement == true {
                self.email.text = "이메일 있음 (사용자 동의가 필요함)"
            } else {
                self.email.text = "이메일 없음"
            }
            
            if let phoneNumber = me.account?.phoneNumber {
                self.phoneNumber.text = phoneNumber
            } else if me.account?.phoneNumberNeedsAgreement == true {
                self.phoneNumber.text = "전화번호 있음 (사용자 동의가 필요함)"
            } else {
                self.phoneNumber.text = "전화번호 없음"
            }
            
            if UIDevice.current.userInterfaceIdiom == .phone {
                if let url = me.thumbnailImageURL {
                    self.thumbnail.setImage(withUrl: url)
                }
            } else {
                if let url = me.profileImageURL {
                    self.thumbnail.setImage(withUrl: url)
                }
            }
            
            self.nickName.text = me.nickname;
            
            if let properties = me.properties {
                self.name.text = properties["name"]
                self.age.text = properties["age"]
                self.gender.text = properties["gender"]
            }
        }
    }
    
    func getProperties() -> [String: String] {
        var formData = [String:String]()
        
        formData["name"] = self.name.text
        formData["nickname"] = self.nickName.text
        formData["age"] = self.age.text
        formData["gender"] = self.gender.text
        
        return formData
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
