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
    
    @IBOutlet weak var MovieListTableView: UITableView!
    
    // MARK: - Properties
    let yearPickerView:UIDatePicker = UIDatePicker()    //데이트피커로 객체 선언
    let monthPickerView: UIDatePicker = UIDatePicker()
    let movieListCellID: String = "MovieListCell"
    var boxOffices: [BoxOfficeModel] = []
    let dataManager = DataManager.sharedManager
    
    var selectedImage: UIImage!
    var selectedTitle: String!
    var selectedRating: Double!
    var selectedDate: String!
    
    
    struct Storyboard {
        static let photoCell = "PhotoCell"
        static let showDetailVC = "ShowMovieDetail"
        static let leftAndRightPaddings: CGFloat = 2.0
        static let numberOfItemsPerRow: CGFloat = 3.0
    }
    
    // MARK: - Init    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blackgroundBlack
        MovieListTableView.backgroundColor = .blackgroundBlack
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
        //올해 -1 까지 maximum으로 잡음
        yearPickerView.maximumDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())        
        setMovieListTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    //이쪽에서 넘어갈때 id 와 moveid가 달라서 데이터가 잘못 넘어가는데 이 부분을 수정이 필요하긴함
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let MovieDetailViewController = segue.destination as? MovieDetailViewController else {return}
        
        let cell = sender as! MovieListTableViewCell
        
        if let selectedIndex = MovieListTableView.indexPath(for: cell) {
            MovieDetailViewController.movieId = boxOffices[selectedIndex.row].id
            
            
        }
    }
    
    @objc func yearPickerValueChanged(sender:UIDatePicker) {
        //연도 바뀌면 쓰는 메소드
        //여기서 연도별 박스오피스 통신을 여기서 해야할듯
        let componenets = Calendar.current.dateComponents([.year], from: sender.date)
        if let year = componenets.year {
            yeartextField.text = "\(year)"
        }
        print(yeartextField.text)
        guard let temp = yeartextField.text else { return }
        SearchService.shared.boxOfficeSearch(Int(temp)!) {
            data in
            
            switch data {
            // 매개변수에 어떤 값을 가져올 것인지
            case .success(let data):
                
                // DataClass 에서 받은 유저 정보 반환
                self.boxOffices = data as! [BoxOfficeModel]
                self.MovieListTableView.reloadData()
                
                print(self.boxOffices)
                
            case .requestErr(let message):
                self.simpleAlert(title: "검색 실패", message: "\(message)")
                
            case .pathErr:
                print(".pathErr")
                
            case .serverErr:
                print(".serverErr")
                
            case .networkFail:
                print("네트워크 오류")
                
            case .dbErr:
                print("디비 에러")
            }
        }
        
        
    }
    @objc func monthPickerValueChanged(sender:UIDatePicker) {
        
        //달이 바뀌면 쓰는 메소드
        let componenets = Calendar.current.dateComponents([.month], from: sender.date)
        if let month = componenets.month {
            monthtextField.text = "\(month)"    //앞에 0 붙여서 두자리 수 만들어줌
        }
    }
    
    
    
}

extension BoxOfficeViewController {
    
    func setMovieListTableView() {
        MovieListTableView.delegate = self
        MovieListTableView.dataSource = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    
}

extension BoxOfficeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boxOffices.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovieListTableViewCell = tableView.dequeueReusableCell(withIdentifier: movieListCellID) as! MovieListTableViewCell
        
        
        
        if boxOffices.isEmpty {
            cell.CountLabel.text = ""
            cell.TitleLabel.text = ""
            cell.DateLabel.text = ""
            cell.ThumnailImageView.image = #imageLiteral(resourceName: "img_placeholder")
        }
            
        else {
            let movie = boxOffices[indexPath.row]
            cell.backgroundColor = .blackgroundBlack
            cell.selectionStyle = .none
            
            cell.CountLabel.text = "\(indexPath.row + 1)."
            cell.CountLabel.textColor = .textGray
            
            cell.TitleLabel.text = movie.korTitle
            cell.TitleLabel.textColor = .textGray
            cell.DateLabel.text = "개봉일 : " + movie.releaseDate
            cell.DateLabel.textColor = .textGray
            
            //       let rateString = "평점 : \(movie.userRating) 예매순위 : \(movie.reservationGrade) 예매율 : \(movie.reservationRate)"
            cell.RatingsLabel.text = String(describing: movie.ranking) + "위"
            cell.RatingsLabel.textColor = .textGray
            
            cell.ThumnailImageView.imageFromUrl(movie.poster, defaultImgPath: "img_placeholder")
        }
        return cell
    }
    
}
