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

class StoryProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setStoryProfile(_ profile: KOStoryProfile!) {
        if profile == nil {
            return
        }
        
        if let url = profile.bgImageURL, let backgroundImageUrl = URL(string: url) {
            backgroundImageView.setImage(withUrl: backgroundImageUrl)
        }
        
        profileImageView.image = UIImage(named: "PlaceHolder")
        if let url = profile.profileImageURL, let profileThumbnailUrl = URL(string: url) {
            profileImageView.setImage(withUrl: profileThumbnailUrl)
        }

        nickNameLabel.text = profile.nickName!
        if let birthday = profile.birthday {
            let birthdayType = profile.birthdayType == .solar ? "SOLAR" : "LUNAR"
            birthdayLabel.text = "\(birthday) \(birthdayType)"
        }
    }

}
