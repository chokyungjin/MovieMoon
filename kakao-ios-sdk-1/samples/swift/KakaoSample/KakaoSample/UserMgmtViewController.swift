/**
 * Copyright 2015-2018 Kakao Corp.
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

class UserMgmtViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var doneSignup:Bool = false
    fileprivate let menu = ["me", "업데이트 프로필", "Unlink", "톡 프로필 보기"]
    fileprivate let menuBeforeSignup = ["Signup"]
    fileprivate var singleTapGesture: UITapGestureRecognizer!
    
    fileprivate var me:KOUserMe? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(UserMgmtViewController.profileImageTapped(_:)))
        singleTapGesture.numberOfTapsRequired = 1
        singleTapGesture.numberOfTouchesRequired = 1
        
        tableView.delegate = self;
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        let nib = UINib(nibName: "UserMgmtTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "UserMgmtTableViewCell")
        
        requestMe()
    }
    
    fileprivate func requestMe(_ displayResult: Bool = false) {
        
        // 사용자 정보 요청
        KOSessionTask.userMeTask { [weak self] (error, me) in
            if let error = error as NSError? {
                UIAlertController.showMessage(error.description)
                
            } else if let me = me as KOUserMe? {
                if displayResult {
                    
                    
                    // 결과 보여주기
                    var message: String = ""
                    
                    message.append("아이디: ")
                    message.append(me.id ?? "없음 (signup 필요함)")
                    
                    if let account = me.account {
                        message.append("\n\n== 카카오계정 정보 ==")
                        
                        message.append("\n이메일: ")
                        if account.email != nil {
                            message.append(account.email!)
                        } else if account.emailNeedsAgreement == true {
                            message.append("있음 (사용자 동의가 필요함)")
                        } else {
                            message.append("없음")
                        }
                        
                        message.append("\n전화번호: ")
                        if account.phoneNumber != nil {
                            message.append(account.phoneNumber!)
                        } else if account.phoneNumberNeedsAgreement == true {
                            message.append("있음 (사용자 동의가 필요함)")
                        } else {
                            message.append("없음")
                        }
                        
                        message.append("\n\n연령대: ")
                        switch account.ageRange {
                        case .type15:   message.append("15세~19세")
                        case .type20:   message.append("20세~29세")
                        case .type30:   message.append("30세~39세")
                        case .type40:   message.append("40세~49세")
                        case .type50:   message.append("50세~59세")
                        case .type60:   message.append("60세~69세")
                        case .type70:   message.append("70세~79세")
                        case .type80:   message.append("80세~89세")
                        case .type90:   message.append("90세 이상")
                        case .null:
                            if account.ageRangeNeedsAgreement == true {
                                message.append("있음 (사용자 동의가 필요함)")
                            } else {
                                message.append("없음")
                            }
                        }
                        
                        message.append("\n출생 연도: ")
                        if account.birthday != nil {
                            message.append(account.birthyear!)
                        } else if account.birthyearNeedsAgreement == true {
                            message.append("있음 (사용자 동의가 필요함)")
                        } else {
                            message.append("없음")
                        }
                        
                        message.append("\n생일: ")
                        if account.birthday != nil {
                            message.append(account.birthday!)
                        } else if account.birthdayNeedsAgreement == true {
                            message.append("있음 (사용자 동의가 필요함)")
                        } else {
                            message.append("없음")
                        }
                        
                        message.append("\n성별: ")
                        switch account.gender {
                        case .male:     message.append("남자")
                        case .female:   message.append("여자")
                        case .null:
                            if account.ageRangeNeedsAgreement == true {
                                message.append("있음 (사용자 동의가 필요함)")
                            } else {
                                message.append("없음")
                            }
                        }
                        
                        message.append("\nCI: ")
                        if account.ci != nil {
                            message.append(account.ci!)
                        } else if account.ciNeedsAgreement == true {
                            message.append("있음 (사용자 동의가 필요함)")
                        } else {
                            message.append("없음")
                        }
                    }
                    
                    if let properties = me.properties {
                        message.append("\n\n== 사용자 속성 ==\n\(properties.description)")
                    }
                    
                    
                    
                    // 사용자 동의를 받지 않은 개인정보 확인
                    // 필요한 경우에 동의를 받고 재요청하여 정보를 획득
                    // 개발자사이트 사용자관리 설정 페이지에서 획득하고자 하는 개인정보에 해당하는 동의항목을 사용하도록 설정해야 함
                    var needsAllScopes: [String]! = []
                    var actions: [UIAlertAction]! = []
                    
                    if let accout = me.account {
                        if accout.emailNeedsAgreement == true {
                            needsAllScopes.append("account_email")
                            actions.append(UIAlertAction(title: "이메일 제공 동의 받기", style: .default, handler: { [weak self] (action) in
                                self?.updateScopesAndRetry(scopes: ["account_email"])
                            }))
                        }
                        
                        if accout.phoneNumberNeedsAgreement == true {
                            needsAllScopes.append("phone_number")
                            actions.append(UIAlertAction(title: "전화번호 제공 동의 받기", style: .default, handler: { [weak self] (action) in
                                self?.updateScopesAndRetry(scopes: ["phone_number"])
                            }))
                        }
                        
                        if accout.ageRangeNeedsAgreement == true {
                            needsAllScopes.append("age_range")
                            actions.append(UIAlertAction(title: "연령대 제공 동의 받기", style: .default, handler: { [weak self] (action) in
                                self?.updateScopesAndRetry(scopes: ["age_range"])
                            }))
                        }
                        
                        if accout.birthyearNeedsAgreement == true {
                            needsAllScopes.append("birthyear")
                            actions.append(UIAlertAction(title: "출생 연도 제공 동의 받기", style: .default, handler: { [weak self] (action) in
                                self?.updateScopesAndRetry(scopes: ["birthyear"])
                            }))
                        }
                        
                        if accout.birthdayNeedsAgreement == true {
                            needsAllScopes.append("birthday")
                            actions.append(UIAlertAction(title: "생일 제공 동의 받기", style: .default, handler: { [weak self] (action) in
                                self?.updateScopesAndRetry(scopes: ["birthday"])
                            }))
                        }
                        
                        if accout.genderNeedsAgreement == true {
                            needsAllScopes.append("gender")
                            actions.append(UIAlertAction(title: "성별 제공 동의 받기", style: .default, handler: { [weak self] (action) in
                                self?.updateScopesAndRetry(scopes: ["gender"])
                            }))
                        }
                        
                        if accout.ciNeedsAgreement == true {
                            needsAllScopes.append("ci")
                            actions.append(UIAlertAction(title: "CI 제공 동의 받기", style: .default, handler: { [weak self] (action) in
                                self?.updateScopesAndRetry(scopes: ["ci"])
                            }))
                        }
                        
                        if needsAllScopes.count >= 2 {
                            // 필요한 동의항목 한번에 요청
                            actions.append(UIAlertAction(title: "모두 동의 받기", style: .default, handler: { [weak self] (action) in
                                self?.updateScopesAndRetry(scopes: needsAllScopes)
                            }))
                        }
                    }
                    
                    actions.append(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                    UIAlertController.showAlert(title: "", message: message, actions: actions)
                }
                
                self?.doneSignup = me.hasSignedUp != .false
                
                self?.me = me
                self?.tableView.reloadData()
            }
        }
    }
    
    fileprivate func updateScopesAndRetry(scopes: [String]!) -> Void {
        KOSession.shared()?.updateScopes(scopes) { [weak self] (error) in
            if let error = error as NSError? {
                UIAlertController.showMessage(error.description)
            } else {
                self?.requestMe(true)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            if self.doneSignup {
                return menu.count
            } else {
                return menuBeforeSignup.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).section == 0 {
            let cell:UserMgmtTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UserMgmtTableViewCell") as! UserMgmtTableViewCell
            cell.setMe(me: self.me)

            var addGesture = true
            if let gestures: [AnyObject] = cell.thumbnail.gestureRecognizers {
                addGesture = gestures.filter {$0 as? UIGestureRecognizer == self.singleTapGesture}.isEmpty
            }

            if addGesture {
                cell.thumbnail.addGestureRecognizer(singleTapGesture)
                cell.thumbnail.isUserInteractionEnabled = true
            }

            return cell
        }
        
        var normalCell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if normalCell == nil {
            normalCell = IconTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        }

        normalCell?.imageView?.image = UIImage(named: "UserMenuIcon\((indexPath as NSIndexPath).row)")
        if self.doneSignup {
            normalCell?.textLabel?.text = menu[(indexPath as NSIndexPath).row]
        } else {
            normalCell?.textLabel?.text = menuBeforeSignup[(indexPath as NSIndexPath).row]
        }
    
        return normalCell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).row == 0 {
            return 397
        }
        return 48
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if  (indexPath as NSIndexPath).section == 0 {
            return;
        }
        
        if self.doneSignup == false {
            switch (indexPath as NSIndexPath).row {
            case 0:
                KOSessionTask.signupTask(withProperties: nil, completionHandler: { [weak self] (success, error) -> Void in
                    if let error = error as NSError? {
                        UIAlertController.showMessage(error.description)
                    } else {
                        self?.requestMe()
                    }
                })
            default:
                fatalError("no menu item!!")
            }
        } else {
            switch (indexPath as NSIndexPath).row {
            case 0:
                requestMe(true)
            case 1:
                KOSessionTask.profileUpdate(withProperties: getFormData(), completionHandler: { (success, error) -> Void in
                    if let error = error as NSError? {
                        UIAlertController.showMessage(error.description)
                    } else {
                        UIAlertController.showMessage("프로필 업데이트에 성공하셨습니다.")
                    }
                })
            case 2:
                KOSessionTask.unlinkTask(completionHandler: { [weak self] (success, error) -> Void in
                    if let error = error as NSError? {
                        UIAlertController.showMessage(error.description)
                    } else {
                        print("User unlink is successfully completed!")
                        _ = self?.navigationController?.popViewController(animated: true)
                    }
                })
            case 3:
                performSegue(withIdentifier: "TalkProfile", sender: self)
            default:
                fatalError("no menu item!!")
            }
        }
    }
    
    fileprivate func getFormData() -> [String: String] {
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = self.tableView.cellForRow(at: indexPath) as! UserMgmtTableViewCell
        
        return cell.getProperties()
    }
    
    @objc func profileImageTapped(_ recognizer: UITapGestureRecognizer) {
        if me == nil || me?.properties == nil || me?.properties?["profile_image"] == nil {
            return
        }
        
        if let imageUrl = me?.properties?["profile_image"] , imageUrl.isEmpty {
            return
        }
        
        self.performSegue(withIdentifier: "ProfileImage", sender: me?.properties?["profile_image"])
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileImage" {
            let viewController: ProfileImageViewController = (segue.destination as? ProfileImageViewController)!
            viewController.profileImageUrlString = sender as? String
            
        }
    }
}
