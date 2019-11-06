/**
 * Copyright 2015-2016 Kakao Corp.
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

// more information : http://www.kakao.com/services/api/story_link

enum ScrapType: String {
    case Website = "website"
    case Video = "video"
    case Music = "music"
    case Book = "book"
    case Article = "article"
    case Profile = "profile"
}

struct ScrapInfo {
    var title: String!
    var desc: String!
    var imageUrls: [String]!
    var type: ScrapType!
    
    func toJsonString() -> String! {
        var dictionary = [String: AnyObject]()
        
        if title != nil {
            dictionary["title"] = title as AnyObject?
        }
        
        if desc != nil {
            dictionary["desc"] = desc as AnyObject?
        }
        
        if let imageUrls = imageUrls , imageUrls.count > 0 {
            dictionary["imageurl"] = imageUrls as AnyObject?
        }
        
        if type != nil {
            dictionary["type"] = type.rawValue as AnyObject?
        }
        
        if dictionary.count == 0 {
            return nil;
        }
        
        return StoryLinkHelper.convertJsonString(dictionary as AnyObject)
    }
}

class StoryLinkHelper: NSObject {
    
    static fileprivate let StoryLinkApiVersion = "1.0"
    static fileprivate let StoryLinkURLBaseString = "storylink://posting"
    
    class func convertJsonString(_ object: AnyObject) -> String! {
        if let jsonData: Data = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions(rawValue: 0)) {
            if let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
                return String(jsonString)
            }
        }
        
        return nil
    }
    
    class func encodedURLString(_ string: String) -> String {
        let customAllowedSet =  CharacterSet(charactersIn: ":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`\n").inverted
        return string.addingPercentEncoding(withAllowedCharacters: customAllowedSet)!
    }
    
    class func HTTPArgumentsStringForParameters(_ parameters: [String: String]) -> String! {
        let arguments: NSMutableArray = NSMutableArray(capacity: parameters.count)
        
        for (k, v) in parameters {
            arguments.add("\(k)=\(encodedURLString(v))")
        }
        
        return arguments.componentsJoined(by: "&")
    }
    
    class func canOpenStoryLink() -> Bool {
        if let url = URL(string: StoryLinkURLBaseString) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
    
    class func makeStoryLink(_ postingText: String, appBundleId: String, appVersion: String, appName: String, scrapInfo: ScrapInfo!) -> String! {
        var parameters: [String: String] = [String: String]()
        parameters["post"] = postingText
        parameters["apiver"] = StoryLinkApiVersion
        parameters["appid"] = appBundleId
        parameters["appver"] = appVersion
        parameters["appname"] = appName
        
        if let scrapInfo = scrapInfo, let infoString = scrapInfo.toJsonString() {
            parameters["urlinfo"] = infoString
        }
        
        let parameterString = self.HTTPArgumentsStringForParameters(parameters)
        return "\(StoryLinkURLBaseString)?\(parameterString ?? "")"
    }
    
    class func openStoryLink(_ postingText: String, appBundleId: String, appVersion: String, appName: String, scrapInfo: ScrapInfo!) -> Bool {
        if let urlString = makeStoryLink(postingText, appBundleId: appBundleId, appVersion: appVersion, appName: appName, scrapInfo: scrapInfo) {
            return openStoryLink(urlString)
        }
        
        return false
    }
    
    class func openStoryLink(_ urlString: String) -> Bool {
        if urlString.isEmpty {
            print("Story Link URL is empty.");
            return false
        }
        
        if let url = URL(string: urlString) {
            return UIApplication.shared.openURL(url)
        }
        
        return false
    }
}
