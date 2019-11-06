/**
 * Copyright 2016-2017 Kakao Corp.
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

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let reuseIdentifier: String = "KakaoNaviSampleCell"
    let headers = ["목적지 공유", "목적지 길안내"]
    let titles = [[["카카오판교오피스", ""],
                   ["카카오판교오피스", "WGS84"],],
                  [["카카오판교오피스", "WGS84"],
                   ["카카오판교오피스", "전체 경로정보 보기"],],]
    
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var naviButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "카카오내비샘플"
        
        self.naviButton.layer.cornerRadius = 5
        self.naviButton.layer.borderWidth = 1
        self.naviButton.layer.borderColor = UIColor(white: 0.85, alpha: 1).cgColor
        self.naviButton.backgroundColor = UIColor(red: (254 / 255.0), green: (238 / 255.0), blue: (53 / 255.0), alpha: 1)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section];
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.value2, reuseIdentifier: reuseIdentifier)
        }
        cell?.textLabel?.text = titles[indexPath.section][indexPath.row][0]
        cell?.detailTextLabel?.text = titles[indexPath.section][indexPath.row][1]
        return cell!
    }
    
    @IBAction func execute(_ sender: Any) {
        var error: NSError?
        
        if let selected = self.menuTableView.indexPathForSelectedRow {
            switch selected.section {
            case 0:
                switch selected.row {
                case 0:
                    shareDestination()
                case 1:
                    shareDestinationWGS84()
                default:
                    error = NSError(domain: "KakaoNaviSampleErrorDomain", code: 1, userInfo: [NSLocalizedFailureReasonErrorKey:"존재하지 않는 메뉴입니다."])
                }
            case 1:
                switch selected.row {
                case 0:
                    navigagteWGS84()
                case 1:
                    navigateRouteInfo()
                default:
                    error = NSError(domain: "KakaoNaviSampleErrorDomain", code: 1, userInfo: [NSLocalizedFailureReasonErrorKey:"존재하지 않는 메뉴입니다."])
                }
            default:
                error = NSError(domain: "KakaoNaviSampleErrorDomain", code: 1, userInfo: [NSLocalizedFailureReasonErrorKey:"존재하지 않는 메뉴입니다."])
            }
        } else {
            error = NSError(domain: "KakaoNaviSampleErrorDomain", code: 2, userInfo: [NSLocalizedFailureReasonErrorKey:"메뉴를 선택해 주세요."])
        }
        
        handleError(error: error)
    }
    
    func shareDestination() -> Void {
        
        // 목적지 공유 - 카카오판교오피스
        let destination = KNVLocation(name: "카카오판교오피스", x: 321286, y: 533707)
        let params = KNVParams(destination: destination)
        KNVNaviLauncher.shared().shareDestination(with: params) { (error) in
            self.handleError(error: error)
        }
    }
    
    func shareDestinationWGS84() -> Void {
        
        // 목적지 공유 - 카카오판교오피스 - WGS84
        let destination = KNVLocation(name: "카카오판교오피스", x: 127.1087, y: 37.40206)
        let options = KNVOptions()
        options.coordType = KNVCoordType.WGS84
        let params = KNVParams(destination: destination, options: options)
        KNVNaviLauncher.shared().shareDestination(with: params) { (error) in
            self.handleError(error: error)
        }
    }
    
    func navigagteWGS84() -> Void {
        
        // 목적지 길안내 - 카카오판교오피스 - WGS84
        let destination = KNVLocation(name: "카카오판교오피스", x: 127.1087, y: 37.40206)
        let options = KNVOptions()
        options.coordType = KNVCoordType.WGS84
        let params = KNVParams(destination: destination, options: options)
        KNVNaviLauncher.shared().navigate(with: params) { (error) in
            self.handleError(error: error)
        }
    }
    
    func navigateRouteInfo() -> Void {
        
        // 목적지 길안내 - 카카오판교오피스 - 전체 경로정보 보기
        let destination = KNVLocation(name: "카카오판교오피스", x: 321286, y: 533707)
        let options = KNVOptions()
        options.routeInfo = true
        let params = KNVParams(destination: destination, options: options)
        KNVNaviLauncher.shared().navigate(with: params) { (error) in
            self.handleError(error: error)
        }
    }
    
    func handleError(error: Error?) -> Void {
        if let error = error as NSError? {
            print(error)
            let alert = UIAlertController(title: self.title!, message: error.localizedFailureReason, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
