//
//  fisrtTab.swift
//  DemoProject
//
//  Created by 조경진 on 11/09/2019.
//  Copyright © 2019 조경진. All rights reserved.
//
import UIKit

class firstTab: UIViewController {
    
    // MARK: - Properties
    
    var delegate: HomeControllerDelegate?
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        configureNavigationBar()
    }
    
    // MARK: - Handlers
    
    @objc func handleMenuToggle() {
        print("1")
        delegate?.handleMenuToggle(forMenuOption: nil)
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        
        navigationItem.title = "Side Menu"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white_3x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))
    }
}
