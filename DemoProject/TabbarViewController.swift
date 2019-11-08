//
//  MainViewController.swift
//  DemoProject
//
//  Created by 조경진 on 07/09/2019.
//  Copyright © 2019 조경진. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController ,MenuViewDelegate{
    
    //IBOutlet..
    @IBOutlet weak var hamburgerMenu: UIBarButtonItem!
 

    //init..
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationColor()
        delegate = self
        hamburgerMenu.tintColor = .lightGray
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 255/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        //네비게이션 바 오랜지색 만들기.
        //햄버거 메뉴 흰색으로 만들기
        self.navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "roundArrowBackIosBlack48Pt1X")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "roundArrowBackIosBlack48Pt1X")
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: nil, action: nil)
        
        self.navigationItem.backBarButtonItem?.tintColor = .white
      
        if let revealVC = revealViewController(), let menuVC = revealVC.rearViewController as? MenuTableViewController {
            menuVC.delegate = self
        }
        
    
        //뒤로가기 흰색으로 만들기
        self.navigationController?.navigationBar.topItem?.title = "Home"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.init(red: 0/255.0, green: 127.0/255.0, blue: 255.0/255.0, alpha: 1.0)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
       
        UITabBar.appearance().tintColor = UIColor.init(red: 0/255.0, green: 127.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        UITabBar.appearance().barTintColor = UIColor.init(red: 188/255.0, green: 224.0/255.0, blue: 253.0/255.0, alpha: 1.0)

        self.tabBar.itemSpacing = UIScreen.main.bounds.width / 4
        
    }
    
    
   
    
    
    func revealViewSetup(){
        if let menuVc = revealViewController() {
            menuVc.rearViewRevealWidth = 275
            menuVc.rightViewRevealWidth = 160
          //  view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

    }
    
    func navigationColor() { //네비게이션 투명색만들기
        //투명하게 만드는 공식처럼 기억하기
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        //네비게이션바의 백그라운드색 지정. UIImage와 동일
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //shadowImage는 UIImage와 동일. 구분선 없애줌.
        self.navigationController?.navigationBar.isTranslucent = true
        //false면 반투명이다.
        self.navigationController?.view.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        //뷰의 배경색 지정
    }

    let dataManager = DataManager.sharedManager

    //IBActions...
    @IBAction func menuAction(sender: AnyObject) {
        if let revealVc = revealViewController() {
            revealVc.revealToggle(sender)
            
        }
    }
    var menuTableViewController: MenuTableViewController!
    
    func menuViewController(_ viewController: UIViewController, didSelect indexPath: IndexPath) {
           if indexPath.row == 0 {
            self.showProfileVC()
           
           }
           if indexPath.row == 1 {
               self.showSettingVC()
           }
           
           if indexPath.row == 2{
               self.showLogoutVC()
           }
        if indexPath.row == 3{
            self.showWishVC()
        }
       }
        
        func showProfileVC(){
        
        let storyboard = UIStoryboard(name: "HamburgerMenuScreen", bundle: nil)
                      let uv = storyboard.instantiateViewController(withIdentifier: "ProfileVC")
                      
                    //  uv!.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency

                   self.present(uv, animated: true) {
                          self.revealViewController().revealToggle(animated: true)
                      }
        }
       func showSettingVC(){
           
           if let revealVc = revealViewController(){
               revealVc.revealToggle(animated: true)
            let storyboard = UIStoryboard(name: "HamburgerMenuScreen", bundle: nil)
               guard let vc = storyboard.instantiateViewController(withIdentifier: "SettingVC") as? SettingViewController else{
                   return
               }
               if let navigationController = revealVc.frontViewController as? UINavigationController{
                   navigationController.pushViewController(vc, animated: true)
                   
               }
               
           }
       }
       func showLogoutVC(){
           
        guard let revealVc = revealViewController() else {return}
               revealVc.revealToggle(animated: true)
                       
        let alert = UIAlertController(title: "로그아웃",
                                         message: "로그아웃 하시겠습니까?",
                                         preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                  let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
                      vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
                      self.present(vc, animated: true, completion: nil)   
        }))
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
           
       }
       
    func showWishVC(){
        
        if let revealVc = revealViewController(){
            revealVc.revealToggle(animated: true)
         let storyboard = UIStoryboard(name: "HamburgerMenuScreen", bundle: nil)
            guard let vc = storyboard.instantiateViewController(withIdentifier: "WishVC") as? WishListViewController else{
                return
            }
            if let navigationController = revealVc.frontViewController as? UINavigationController{
                navigationController.pushViewController(vc, animated: true)
                
            }
            
        }
    }
    
}

extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print( self.selectedIndex)
               if self.selectedIndex == 1 {
                   self.navigationController?.navigationBar.topItem?.title = "Box Office"
                
                
                     }
               else if self.selectedIndex == 2{
                   self.navigationController?.navigationBar.topItem?.title = "My Diary"
               }
               else if self.selectedIndex == 3{
                   self.navigationController?.navigationBar.topItem?.title = "Recommend"
               }
               else {
                   self.navigationController?.navigationBar.topItem?.title = "Home"
               }
               
    }
}
