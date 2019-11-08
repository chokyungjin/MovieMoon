//
//  StretchyHeaderController.swift
//  StretchyHeaderLBTA
//
//  Created by Brian Voong on 12/22/18.
//  Copyright © 2018 Brian Voong. All rights reserved.
//

import UIKit

class StretchyHeaderController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    //vars..
    fileprivate let cellId = "cellId"
    fileprivate let headerId = "headerId"
    fileprivate let padding: CGFloat = 8
    var thumbView: UIImageView!
    var headerView: HeaderView?

    //init..
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViewLayout()
        setupCollectionView()
        
        thumbView = UIImageView(image: ImageManager.imageManager.getImage())
        thumbView?.contentMode = .scaleAspectFit
        thumbView?.clipsToBounds = true
        thumbView?.frame = CGRect(x: 0, y: view.frame.height / 4, width: 180, height: 200)
        collectionView.addSubview(thumbView)
    }
    
     fileprivate func setupCollectionViewLayout() {
           if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
               layout.sectionInset = .init(top: padding, left: padding, bottom: padding, right: padding)
           }
       }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        print(contentOffsetY)
        
        if contentOffsetY > 0 {
         //   headerView?.animator.fractionComplete = 0
            return
        }
        
       // headerView?.animator.fractionComplete = abs(contentOffsetY) / 100
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as? HeaderView
        return headerView!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        print("!!")
        print(collectionView.frame)
        print("!!")

        return .init(width: view.frame.width, height: 340)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .black
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 2 * padding, height: 50)
    }

}
