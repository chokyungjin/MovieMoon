//
//  HomeViewController.swift
//  DemoProject
//
//  Created by 조경진 on 11/09/2019.
//  Copyright © 2019 조경진. All rights reserved.
//

//이걸 4개읠 뷰 컨트롤러로 분리시켜줘야함!!!
import UIKit

class BoxOfficeViewController: UIViewController,UITextFieldDelegate {
    
    //IBOutlets..
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yeartextField: UITextField!
    @IBOutlet weak var monthtextField: UITextField!
    
    // MARK: - Properties
    let yearPickerView:UIDatePicker = UIDatePicker()    //데이트피커로 객체 선언
    let monthPickerView: UIDatePicker = UIDatePicker()
    
    
    
    // MARK: - Init    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blackgroundBlack
        yearLabel.textColor = .textGray
        monthLabel.textColor = .textGray
        yeartextField.textColor = .color130
        monthtextField.textColor = .color130
        yeartextField.textAlignment = .center
        monthtextField.textAlignment = .center
        yeartextField.makeRounded(cornerRadius: 15)
        monthtextField.makeRounded(cornerRadius: 15)
        
        self.yeartextField.delegate = self
        self.monthtextField.delegate = self
        
        yearPickerView.datePickerMode = UIDatePicker.Mode.date
        yearPickerView.addTarget(self, action: #selector(yearPickerValueChanged(sender:)), for: .valueChanged)
        yeartextField.inputView = yearPickerView
        
        monthPickerView.datePickerMode = UIDatePicker.Mode.date
        monthPickerView.addTarget(self, action: #selector(monthPickerValueChanged(sender:)), for: .valueChanged)
        monthtextField.inputView = monthPickerView
        
        //2014년 부터 시작
        yearPickerView.minimumDate = Calendar.current.date(byAdding: .year, value: -13, to: Date())
        yearPickerView.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        
    }
    
    @objc func yearPickerValueChanged(sender:UIDatePicker) {
        //날짜 바뀌면 쓰는 메소드
        let componenets = Calendar.current.dateComponents([.year], from: sender.date)
        if let year = componenets.year {
            yeartextField.text = "\(year)"
        }
    }
    @objc func monthPickerValueChanged(sender:UIDatePicker) {
        //날짜 바뀌면 쓰는 메소드
        let componenets = Calendar.current.dateComponents([.month], from: sender.date)
        if let month = componenets.month {
                monthtextField.text = "\(month)"    //앞에 0 붙여서 두자리 수 만들어줌
        }
    }
    
}

extension BoxOfficeViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
}
