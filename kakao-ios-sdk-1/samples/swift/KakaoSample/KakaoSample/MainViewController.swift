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

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    let apiMenus = ["User API", "Story API", "Message API", "Message API"]
    let menuSubTitles = ["", "", "(Friend)", "(Chat)"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiMenus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell")
        if(cell == nil) {
            cell = IconTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        }
        
        cell?.imageView?.image = UIImage(named: "MainMenuIcon\((indexPath as NSIndexPath).row)")
        cell?.textLabel?.text = apiMenus[(indexPath as NSIndexPath).row]
        cell?.detailTextLabel?.text = menuSubTitles[(indexPath as NSIndexPath).row]
        
        return cell!
    }
    
    // Called after the user changes the selection.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "\(apiMenus[(indexPath as NSIndexPath).row])\(menuSubTitles[(indexPath as NSIndexPath).row])", sender: apiMenus[(indexPath as NSIndexPath).row])
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let viewController = segue.destination as UIViewController
        viewController.title = sender as? String
    }

    @IBAction func logoutClicked(_ sender: AnyObject) {
        KOSession.shared()?.logoutAndClose { [weak self] (success, error) -> Void in
            _ = self?.navigationController?.popViewController(animated: true)
        }
    }

}
