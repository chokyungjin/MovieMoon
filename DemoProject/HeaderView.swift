//
//  HeaderView.swift
//  StretchyHeaderLBTA
//
//  Created by Brian Voong on 12/22/18.
//  Copyright © 2018 Brian Voong. All rights reserved.
//

import UIKit

class HeaderView: UICollectionReusableView {
    
    let imageView: UIImageView = {
        
        let iv = UIImageView(image: DataManager.sharedManager.getImage())
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .red
        print(iv.frame)
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // custom code for layout
                
        addSubview(imageView)
        imageView.fillSuperview()
        
        //blur
       // setupVisualEffectBlur()
        
        setUpGradientLayer()
    }
    
    var animator: UIViewPropertyAnimator!
    
    fileprivate func setupVisualEffectBlur() {
        animator = UIViewPropertyAnimator(duration: 3.0, curve: .linear, animations: { [weak self] in
            
            // treat this area as the end state of your animation
            let blurEffect = UIBlurEffect(style: .regular)
            let visualEffectView = UIVisualEffectView(effect: blurEffect)
            
            self?.addSubview(visualEffectView)
            visualEffectView.fillSuperview()
        })
    }
    
    fileprivate func setUpGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0,1]
        
        
        let gradientContainerView = UIView()
        addSubview(gradientContainerView)
        gradientContainerView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        gradientContainerView.layer.addSublayer(gradientLayer)
        
        
        
        //static frame
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 340)
    
        gradientLayer.frame.origin.y -= bounds.height
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
