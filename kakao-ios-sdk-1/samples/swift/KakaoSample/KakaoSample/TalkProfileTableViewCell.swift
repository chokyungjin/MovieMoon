/**
* Copyright 2015 Kakao Corp.
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

class TalkProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var countryISO: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTalkProfile(_ profile: KOTalkProfile!) {
        self.thumbnail.image = UIImage(named: "PlaceHolder")
        
        if profile == nil {
            return
        }
        
        if profile.thumbnailURL != nil && profile.thumbnailURL.isEmpty == false {
            if let thumbnailURL = URL(string: profile.thumbnailURL!) {
                self.thumbnail.setImage(withUrl: thumbnailURL)
            }
        }
        
        if profile.nickName != nil {
            self.nickName.text = profile.nickName
        }
        
        if profile.countryISO != nil {
            self.countryISO.text = profile.countryISO
        }
    }    
}
