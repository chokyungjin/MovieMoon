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

class IconTableViewCell: UITableViewCell {

    let margin: CGFloat = 10
    let imageSize: CGFloat = 32
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let cellFrame = self.contentView.frame
        let imageViewOrigin = self.imageView?.frame.origin
        
        self.imageView?.frame = CGRect(x: (imageViewOrigin?.x)!, y: (cellFrame.size.height - imageSize) / 2, width: imageSize, height: imageSize)
        self.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        self.imageView?.autoresizingMask = UIViewAutoresizing()
        
        let imageViewFrame = self.imageView?.frame
        let labelOriginX = (imageViewFrame?.origin.x)! + (imageViewFrame?.size.width)! + margin
        
        self.textLabel?.frame = CGRect(x: labelOriginX, y: (self.textLabel?.frame.origin.y)!, width: cellFrame.size.width - labelOriginX - margin , height: (self.textLabel?.frame.size.height)!)
        self.detailTextLabel?.frame = CGRect(x: labelOriginX, y: (self.detailTextLabel?.frame.origin.y)!, width: cellFrame.size.width - labelOriginX - margin , height: (self.detailTextLabel?.frame.size.height)!)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
