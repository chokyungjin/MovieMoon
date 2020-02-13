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
    @IBOutlet weak var plusBut: UIBarButtonItem!
    
    //Vars, lets ..
    var menuTableViewController: MenuTableViewController!
    let dataManager = DataManager.sharedManager
    
    //init..
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationSetup()
        delegate = self
        hamburgerMenu.tintColor = .textGray
        
        
        if let revealVC = revealViewController(), let menuVC = revealVC.rearViewController as? MenuTableViewController {
            menuVC.delegate = self
        }
        UITabBar.appearance().barTintColor = .blurGray
        self.tabBar.itemSpacing = UIScreen.main.bounds.width / 4
        
        revealViewSetup()
    }
    
    
    func revealViewSetup(){
        if let menuVc = revealViewController() {
            menuVc.rearViewRevealWidth = 275
            //335 로 사이드 바의 크기를 넓혀서 다른 이벤트를 발생 못하게 막아버릴순 있다
            menuVc.rightViewRevealWidth = 160
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }
    
    func navigationSetup() { //네비게이션 투명색만들기
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 255/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "roundArrowBackIosBlack48Pt1X")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "roundArrowBackIosBlack48Pt1X")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .white
        //투명하게 만드는 공식처럼 기억하기
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        //네비게이션바의 백그라운드색 지정. UIImage와 동일
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //shadowImage는 UIImage와 동일. 구분선 없애줌.
        self.navigationController?.navigationBar.isTranslucent = true
        //false면 반투명이다.
        self.navigationController?.view.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        //뷰의 배경색 지정
        self.navigationController?.navigationBar.topItem?.title = "Home"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.init(red: 211/255.0, green: 211.0/255.0, blue: 211.0/255.0, alpha: 1.0)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
    }
    
    //IBActions...
    @IBAction func menuAction(sender: AnyObject) {
        
        if let revealVc = revealViewController() {
            revealVc.revealToggle(sender)
            //Event 등록 = Post
           // NotificationCenter.default.post(name: Notification.Name(rawValue: "PostButton"), object: nil)
        }
    }
    
    //HamburgerMenu didSelect Handling..
    func menuViewController(_ viewController: UIViewController, didSelect indexPath: IndexPath) {
        if indexPath.row == 0{
            self.showWishVC()
        }
        
        if indexPath.row == 1 {
            self.showLogoutVC()
        }
        
    }
    
    func showLogoutVC(){
        
        guard let revealVc = revealViewController() else {return}
        revealVc.revealToggle(animated: true)
        
        //logout connection..
        let alert = UIAlertController(title: "로그아웃",
                                      message: "로그아웃 하시겠습니까?",
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            
            let urlString: String = APIConstants.LogoutURL
            guard let requestURL = URL(string: urlString) else { return }
            var request = URLRequest(url: requestURL)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (responseData, response, responseError) in
                print(responseData)
                guard responseError == nil else { return }
            }
            task.resume()
            
            UserDefaults.standard.set(nil , forKey: "Nickname")
            UserDefaults.standard.set(nil , forKey: "Id")
            UserDefaults.standard.set(nil , forKey: "userId")
            UserDefaults.standard.set(nil , forKey: "src")
            UserDefaults.standard.set(nil , forKey: "createdAt")
            UserDefaults.standard.set(nil , forKey: "updatedAt")
            
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
            guard let vc = storyboard.instantiateViewController(withIdentifier: "WishVC") as? WishListCollectionViewController else{
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
        
        if self.selectedIndex == 1 {
            self.navigationController?.navigationBar.topItem?.title = "Box Office"
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
            
        }
        else if self.selectedIndex == 2 {
            self.navigationController?.navigationBar.topItem?.title = "My Diary"
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plusBut"), style: .plain, target: self, action: #selector(addMovie(_:)))
            self.navigationItem.rightBarButtonItem?.tintColor = .textGray
            
        }
        else if self.selectedIndex == 3 {
            self.navigationController?.navigationBar.topItem?.title = "Recommend"
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "baseline_settings_white_24dp"), style: .plain, target: self, action: #selector(changeType(_ :)))
            self.navigationItem.rightBarButtonItem?.tintColor = .textGray
            
        }
        else {
            self.navigationController?.navigationBar.topItem?.title = "Home"
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
            
        }
        
    }
    
    @objc func addMovie(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "DiaryScreen", bundle: nil)
        let uv = storyboard.instantiateViewController(withIdentifier: "DiarySearchVC")
        uv.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "roundArrowBackIosBlack48Pt1X")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "roundArrowBackIosBlack48Pt1X")
        self.navigationController?.navigationBar.tintColor = .textGray
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Diary", style: .done, target: nil, action: nil)
                
        self.navigationController?.pushViewController(uv, animated: true)
        
    }
    
    @objc func changeType(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message: "영화를 어떤 순서로 추천할까요?", preferredStyle: .actionSheet)
        
        let subview = (alert.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        subview.backgroundColor = UIColor(red: (104/255.0), green: (104/255.0), blue: (104/255.0), alpha: 1.0)
        
        let latestAction: UIAlertAction = UIAlertAction(title: "최신순", style: .default)
        latestAction.setValue(UIColor.init(red: 211.0/255.0, green: 211.0/255.0, blue: 211.0/255.0, alpha: 1), forKey:
            "titleTextColor")
        
        let popularAction: UIAlertAction = UIAlertAction(title: "인기순", style: .default)
        popularAction.setValue(UIColor.init(red: 211.0/255.0, green: 211.0/255.0, blue: 211.0/255.0, alpha: 1), forKey: "titleTextColor")
        
        let interestAction: UIAlertAction = UIAlertAction(title: "흥미순", style: .default)
        interestAction.setValue(UIColor.init(red: 211.0/255.0, green: 211.0/255.0, blue: 211.0/255.0, alpha: 1), forKey: "titleTextColor")
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
        cancelAction.setValue(UIColor.init(red: 104.0/255.0, green: 104.0/255.0, blue: 104.0/255.0, alpha: 1), forKey:
            "titleTextColor")
        
        alert.addAction(latestAction)
        alert.addAction(popularAction)
        alert.addAction(interestAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}





