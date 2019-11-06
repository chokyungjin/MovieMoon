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

class TalkProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var profile:KOTalkProfile?
    fileprivate var singleTapGesture: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(TalkProfileViewController.profileImageTapped(_:)))
        singleTapGesture.numberOfTapsRequired = 1
        singleTapGesture.numberOfTouchesRequired = 1
        
        tableView.delegate = self;
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        let nib = UINib(nibName: "TalkProfileTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TalkProfileTableViewCell")
        
        KOSessionTask.talkProfileTask { (talkProfile, error) -> Void in
            if error != nil {
                UIAlertController.showMessage("에러! \(error!)")
            } else {
                self.profile = (talkProfile as! KOTalkProfile)
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TalkProfileTableViewCell") as! TalkProfileTableViewCell
        cell.setTalkProfile(self.profile)
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 236
    }

    @objc func profileImageTapped(_ recognizer: UITapGestureRecognizer) {
        if profile == nil || profile?.profileImageURL == nil {
            return
        }
        
        if let imageUrl = profile?.profileImageURL! , imageUrl.isEmpty {
            return
        }
        
        self.performSegue(withIdentifier: "ProfileImage", sender: profile?.profileImageURL)
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
