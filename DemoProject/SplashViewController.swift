//
//  SplashViewController.swift
//  DemoProject
//
//  Created by 조경진 on 2019/11/08.
//  Copyright © 2019 조경진. All rights reserved.
//

import UIKit


class SplashViewController: UIViewController {

    
    @IBOutlet weak var GifView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GifView.loadGif(name: "testGIF")
        
    }

  
}

