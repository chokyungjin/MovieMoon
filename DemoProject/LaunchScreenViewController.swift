//
//  LaunchScreenController.swift
//  DemoProject
//
//  Created by 조경진 on 2019/11/09.
//  Copyright © 2019 조경진. All rights reserved.
//

import UIKit
import SwiftyGif
import Lottie

class LaunchScreenViewController : UIViewController {
    
    //IBO...
    @IBOutlet weak var loadingImage: UIImageView!
    
    
    //vars..
    var gifName : String = "SplashFix"
    let gifManager = SwiftyGifManager(memoryLimit: 60)
    var mTimer:  Timer? = nil
    var number: Double = 0.0
    
    
    //init..
    override func viewDidLoad() {
        super.viewDidLoad()
        //startAnimation()

        if let image = try? UIImage(imageName: gifName) {
            self.loadingImage.setImage(image, manager: gifManager)
        } else { self.loadingImage.clear() }

        self.loadingImage.startAnimatingGif()
        
        ticktok()
    }
    
//    func startAnimation() {
//        let animationView = Lottie.AnimationView(name:"moviemoonsplash")
//
//        animationView.frame = CGRect(x:0, y:0, width:375, height:812)
//        animationView.center = self.view.center
//        animationView.contentMode = .scaleToFill
//
//        loadingImage.addSubview(animationView)
//        animationView.play()
//    }
    
    
    func ticktok(){
        if let timer = mTimer {
            //timer 객체가 nil 이 아닌경우에는 invalid 상태에만 시작한다
            if !timer.isValid {
                /** 1초마다 timerCallback함수를 호출하는 타이머 */
                mTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
            }
        }else{
            //timer 객체가 nil 인 경우에 객체를 생성하고 타이머를 시작한다
            /** 1초마다 timerCallback함수를 호출하는 타이머 */
            mTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
        }
    }
    
    //for GIF...
    
    @objc func timerCallback(){
        number += 1
        if number == 3 {
            //Thread.sleep(forTimeInterval: 1) //1초만 재우기
            loadingImage.stopAnimatingGif()

            loadingImage.removeFromSuperview()

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)

        }
    }
    
    //for Lottie...
//     @objc func timerCallback(){
//            number += 1
//        if number == 3{
//                //Thread.sleep(forTimeInterval: 1) //1초만 재우기
//                
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
////                vc.modalTransitionStyle = .crossDissolve
//                vc.modalPresentationStyle = .fullScreen
//                self.present(vc, animated: true, completion: nil)
//                
//            }
//        }
    
}
