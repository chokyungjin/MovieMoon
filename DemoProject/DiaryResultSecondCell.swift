//
//  DiaryContentSecond.swift
//  DemoProject
//
//  Created by 조경진 on 2019/11/17.
//  Copyright © 2019 조경진. All rights reserved.
//

import Foundation

protocol PlusActionDelegate {
    
    func didClickedPlus()
    
    func didClickedOk()
    
    func didClickedCancel()
    
}

class DiaryResultSecondCell : UITableViewCell , UITextViewDelegate {
    
    var delegate : PlusActionDelegate?
    
    var plusBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.init(red: 104/255, green: 104/255, blue: 104/255, alpha: 1)
        button.setImage(#imageLiteral(resourceName: "plusBut"), for: .normal)
        button.frame = CGRect(x: 15, y: 0, width: 30, height: 30)
        return button
    }()
    
    var addLabel: UILabel = {
        let label = UILabel()
        label.text = "Add Photo : (3장 다 넣으세요)" 
        label.textColor = .textGray
        label.frame = CGRect(x: 70, y: 5, width: 250, height: 20)
        return label
    }()
    
    
    var plotField: UITextView = {
        let label = UITextView()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.frame = CGRect(x: 39, y: 240, width: 298, height: 250)
        return label
    }()
    var stillcutImage: UIImageView = {
        let ImageView = UIImageView()
        let defaultImage = UIImage(named: "img_placeholder")
        ImageView.image = defaultImage
        ImageView.frame = CGRect(x: 20, y: 50, width: 100, height: 150)
        
        return ImageView
    }()
    var stillcutImage2: UIImageView = {
        let ImageView = UIImageView()
        let defaultImage = UIImage(named: "img_placeholder")
        ImageView.image = defaultImage
        ImageView.frame = CGRect(x: 140, y: 50, width: 100, height: 150)
        
        return ImageView
    }()
    var stillcutImage3: UIImageView = {
        let ImageView = UIImageView()
        let defaultImage = UIImage(named: "img_placeholder")
        ImageView.image = defaultImage
        ImageView.frame = CGRect(x: 260, y: 50, width: 100, height: 150)
        
        return ImageView
    }()
    
    var OkButton : UIButton = {
        let button = UIButton()
        button.setTitle("Ok", for: .normal)
        button.setTitleColor(.textGray, for: UIControl.State.normal)
        button.frame = CGRect(x: 0 , y: 600, width: 375 / 2, height: 69.5)
        return button
    }()
    
    var CancelButton : UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.textGray, for: UIControl.State.normal)
        button.frame = CGRect(x: 375 / 2, y: 600, width: 375 / 2, height: 69.5)
        return button
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(plotField)
        self.addSubview(stillcutImage)
        self.addSubview(stillcutImage2)
        self.addSubview(stillcutImage3)
        self.addSubview(OkButton)
        self.addSubview(addLabel)
        self.addSubview(CancelButton)
        plusBtn.makeRounded(cornerRadius: nil)
        OkButton.layer.addBorder([.top , .right , .bottom], color: .color130, width: 1)
        CancelButton.layer.addBorder([.top , .bottom], color: .color130, width: 1)

        self.addSubview(plusBtn)
        plusBtn.addTarget(self, action: #selector(didClick(_:)), for: .touchUpInside)
        OkButton.addTarget(self, action: #selector(didOk(_:)), for: .touchUpInside)
        CancelButton.addTarget(self, action: #selector(didCancel(_:)), for: .touchUpInside)

        self.plotField.delegate = self
        textViewDidChange(plotField)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func didClick(_ sender: Any) {
        self.delegate?.didClickedPlus()
    }
    
    @objc func didOk(_ sender: Any) {
           self.delegate?.didClickedOk()
       }
    
    @objc func didCancel(_ sender: Any) {
           self.delegate?.didClickedCancel()
       }
    
    // MARK: UITextViewDelegate methods
       func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
           print(textView.text!) //the textView parameter is the textView where text was changed
           UserDefaults.standard.set(plotField.text, forKey: "memo")

       }
}
