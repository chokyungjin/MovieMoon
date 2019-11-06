/**
 * Copyright 2016 Kakao Corp.
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

class DestinationViewController: UIViewController, MTMapViewDelegate, UISearchBarDelegate {
    
    let API_KEY = "DAUM_MAP_KAKAO_NAVI_IOS_DEMO_APIKEY"
    
    var isNeedName: Bool! = false
    var selectedLocation: KNVLocation?
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MTMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.daumMapApiKey = API_KEY
        self.mapView.delegate = self
        self.mapView.baseMapType = MTMapType.standard
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != nil {
            let center = self.mapView.mapCenterPoint.mapPointGeo()
            let searchApiUrlString = "https://apis.daum.net/local/v1/search/keyword.json?query=\(searchBar.text!)&location=\(center.longitude),\(center.latitude)&radius=\(10000)&page=\(1)&apikey=\(API_KEY)"
            print(searchApiUrlString)
            let searchApiUrl = URL.init(string: searchApiUrlString)
            print(searchApiUrl ?? "nil")
            if searchApiUrl != nil {
                URLSession.shared.dataTask(with: searchApiUrl!, completionHandler: { (data, response, error) in
                    print("\n\(error)\n\(response)\n\(data)")
                }).resume()
            }
        }
    }
    
    func mapView(_ mapView: MTMapView!, longPressOn mapPoint: MTMapPoint!) {
        self.selectedLocation = KNVLocation.init(name: "", x: mapPoint.mapPointGeo().longitude as NSNumber, y: mapPoint.mapPointGeo().latitude as NSNumber)
        
        let alertController = UIAlertController.init(title: "장소 검색", message: "다음 위치를 선택하셨습니다.\n\n경도(x): \((self.selectedLocation?.x)!)\n위도(y): \((self.selectedLocation?.y)!)", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction.init(title: "확인", style: UIAlertActionStyle.default) { (action) in
            if self.isNeedName == true {
                if let name = alertController.textFields?.first?.text {
                    if name.characters.count > 0 {
                        self.selectedLocation?.name = name
                        self.performSegue(withIdentifier: "unwindSearch", sender: self)
                    } else {
                        let alertController = UIAlertController.init(title: "장소 검색", message: "목적지명을 입력해주세요.", preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction.init(title: "확인", style: UIAlertActionStyle.cancel, handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            } else {
                let formatter = NumberFormatter()
                formatter.maximumFractionDigits = 6
                self.selectedLocation?.name = "경도(x): \(formatter.string(from: (self.selectedLocation?.x)!)!), 위도(y): \(formatter.string(from: (self.selectedLocation?.y)!)!)"
                self.performSegue(withIdentifier: "unwindSearch", sender: self)
            }
        })
        alertController.addAction(UIAlertAction.init(title: "취소", style: UIAlertActionStyle.cancel) { (action) in
            self.selectedLocation = nil
        })
        if self.isNeedName == true {
            alertController.message! += "\n\n목적지명을 입력해주세요."
            alertController.addTextField(configurationHandler: nil)
        }
        self.present(alertController, animated: true, completion: nil)
    }

}
