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
    var movies: [Movie] = []
    let dataManager = DataManager.sharedManager
    
    let baseURL: String = {
        return ServerURLs.base.rawValue
    }()
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
        yearPickerView.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        
        setDefaultMovieOrderType()
        setMovieListTableView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        if dataManager.getDidOrderTypeChangedAndDownloaded() {
            reloadMovieLists()
        }
        else {reloadMovieLists()
            let orderType: String = dataManager.getMovieOrderType()
            getMovieList(orderType: orderType)
        }
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
    
    func setMovieListTableView() {
        MovieListTableView.delegate = self
        MovieListTableView.dataSource = self
    }
    
    func setDefaultMovieOrderType() {
        let orderType: String = "0"
        dataManager.setMovieOrderType(orderType: orderType)
    }
    func reloadMovieLists() {
        self.movies = dataManager.getMovieList()
        DispatchQueue.main.async {
            self.MovieListTableView.reloadData()
        }
    }
    func getMovieList(orderType: String) {
        
        let url: String = baseURL + ServerURLs.movieList.rawValue + orderType
        
        guard let finalURL = URL(string: url) else {
            return
        }
        
        let session = URLSession(configuration: .default)
        let request = URLRequest(url: finalURL)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let resultData = data else {
                return
            }
            
            do {
                print("Success")
                let movieLists: ListResponse  = try JSONDecoder().decode(ListResponse.self, from: resultData)
                
                self.dataManager.setMovieList(list: movieLists.results)
                self.dataManager.setDidOrderTypeChangedAndDownloaded(true)
                self.reloadMovieLists()
            }
            catch let error {
                print(error.localizedDescription)
            }
            
        }
        
        task.resume()
    }
    
    func getThumnailImage(withURL thumnailURL: String) -> UIImage? {
        guard let imageURL = URL(string: thumnailURL) else {
            return UIImage(named: "img_placeholder")
        }
        
        guard let imageData: Data = try? Data(contentsOf: imageURL) else {
            return UIImage(named: "img_placeholder")
        }
        
        return UIImage(data: imageData)
    }
    
    func getGradeImage(grade: Int) -> UIImage? {
        switch grade {
        case 0:
            return UIImage(named: "ic_allages")
        case 12:
            return UIImage(named: "ic_12")
        case 15:
            return UIImage(named: "ic_15")
        case 19:
            return UIImage(named: "ic_19")
        default:
            return nil
        }
    }
    func getTitle(title: String) -> String? {
        return title
    }
    func getRating(rating: Double) -> Double? {
        return rating
    }
    func getDate(date: String) -> String? {
        return date
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    
}

extension BoxOfficeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(movies.count)
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height / 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovieListTableViewCell = tableView.dequeueReusableCell(withIdentifier: movieListCellID) as! MovieListTableViewCell
        
        
        let movie = movies[indexPath.row]
        
        cell.backgroundColor = .blackgroundBlack
        cell.selectionStyle = .none
        
        cell.CountLabel.text = "\(indexPath.row + 1)."
        cell.CountLabel.textColor = .textGray
        
        cell.TitleLabel.text = movie.title
        cell.TitleLabel.textColor = .textGray
        cell.DateLabel.text = "개봉일 : " + movie.date
        cell.DateLabel.textColor = .textGray
        
        let rateString = "평점 : \(movie.userRating) 예매순위 : \(movie.reservationGrade) 예매율 : \(movie.reservationRate)"
        cell.RatingsLabel.text = rateString
        cell.RatingsLabel.textColor = .textGray
        
        let gradeIamge = getGradeImage(grade: movie.grade)
        cell.GradeImageView.image = gradeIamge
        
        cell.ThumnailImageView.imageFromUrl(movie.thumnailImageURL, defaultImgPath: "img_placeholder")
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let movie = movies[indexPath.row]
        let thumnailImage = self.getThumnailImage(withURL: movie.thumnailImageURL)
        self.selectedImage = thumnailImage
        dataManager.setImage(haveImage: self.selectedImage)
        
        let movietitle = self.getTitle(title: movie.title)
        self.selectedTitle = movietitle
        dataManager.setTitle(haveTitle: self.selectedTitle)
        
        let movieRating = self.getRating(rating: movie.userRating)
        self.selectedRating = movieRating
        dataManager.setRating(haveRating: self.selectedRating)
        
        let movieDate = self.getDate(date: movie.date)
        self.selectedDate = movieDate
        dataManager.setDate(haveDate: self.selectedDate)
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "HomeScreen", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "MovieDetailVC") as! MovieDetailViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
