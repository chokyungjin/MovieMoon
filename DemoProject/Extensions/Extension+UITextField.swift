//
//  Extension+UITextField.swift
//  DemoProject
//
//  Created by 조경진 on 2019/11/16.
//  Copyright © 2019 조경진. All rights reserved.
//

import UIKit

extension UITextField {
    
    func setBottomBorder() {
        
      self.borderStyle = .none
      self.layer.backgroundColor = UIColor.clear.cgColor

      self.layer.masksToBounds = false
      self.layer.shadowColor = UIColor.black.cgColor
      self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
      self.layer.shadowOpacity = 1.0
      self.layer.shadowRadius = 0.0
        
    }
    
}



