//
//  Extension+Font.swift
//  DemoProject
//
//  Created by 조경진 on 2019/11/21.
//  Copyright © 2019 조경진. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {

    public enum NanumSquareType: String {
        case regular = ""
        case Bold = "-Bold"
        case ExtraBold = "-ExtraBold"
        case Light = "-Light"
        case Regular = "-Regular"
        case RoundB = "-RoundB"
        case RoundEB = "-RoundEB"
        case RoundL = "-RoundL"
        case RoundR = "-RoundR"
    }
    
    private static func getFontSize(_ size: CGFloat, isFix: Bool) -> CGFloat {
        if isFix {
            return size
        }
        
        guard let width = UIApplication.shared.keyWindow?.frame.width else {
            return size
        }
        
        return size * (width / 375)
    }
    
    static func NanumSquare(type: NanumSquareType, size: CGFloat, isFix: Bool = false) -> UIFont {
        guard let font = UIFont.init(name: type.rawValue, size: getFontSize(size, isFix: isFix)) else {
            let sFont = UIFont.systemFont(ofSize: getFontSize(size, isFix: isFix))
            return sFont
        }
        return font
    }
    
    var isBold: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }

    var isItalic: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitItalic)
    }

}
    
    
    
    
    

