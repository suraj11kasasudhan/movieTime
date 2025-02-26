//
//  MovieDetailVC.swift
//  MovieTime
//
//  Created by Suraj on 25/02/25.
//

import UIKit

class MovieDetailVC: UIViewController{
    
    private var movieId:String = ""
    private var movieService:MovieService?
    private let loader  = UIActivityIndicatorView()
    private let poster = UIImageView()
    private let movieTitleLabel = UILabel()
    private let movieTitle = UILabel()
    private let releseDateLabel = UILabel()
    private let releaseDate = UILabel()
    private let directorLabel = UILabel()
    private let director = UILabel()
    private let plotLabel = UILabel()
    private let plot = UILabel()
    
    
    init(movieId:String,movieService:MovieService = MovieService()){
        self.movieService = movieService
        self.movieId = movieId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createViews()
        fetchMovieDetail()
    }
    
    private func showLoader(){
        DispatchQueue.main.async {
            self.loader.isHidden = false
            self.loader.startAnimating()
        }
    }
    
    private func hideLoader() {
        DispatchQueue.main.async {
            self.loader.isHidden = true
            self.loader.stopAnimating()
        }
    }
    
    private func setData(){
        loadImage(url: self.movieService?.movieDetail?.poster ?? "")
        movieTitleLabel.text = "Movie Title:"
        releseDateLabel.text = "Release Data:"
        directorLabel.text = "Director:"
        plotLabel.text = "Plot:"
        
        movieTitle.text = self.movieService?.movieDetail?.title ?? ""
        releaseDate.text = self.movieService?.movieDetail?.released ?? ""
        director.text = self.movieService?.movieDetail?.director ?? ""
        plot.text = self.movieService?.movieDetail?.plot ?? ""
    }
    
    private func loadImage(url:String){
        AppHelper.loadImage(urlString: url) { image in
            DispatchQueue.main.async {
                self.poster.image = image
            }
        }
    }
    
    func showAlert(title:String,message:String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func fetchMovieDetail(){
        showLoader()
        var params:[String:String] = [:]
        params = ["apikey":AppHelper.apiKey,"i":self.movieId]
        
        movieService?.getMovieDetail(params: params){[weak self] (status,data) in
            guard let self = self else {return}
            switch status {
            case .succes:
                DispatchQueue.main.async {
                    self.hideLoader()
                    self.setData()
                }
                
            case .failure:
                showAlert(title: "Failed", message: "failed to load data")
                hideLoader()
                
                
            case .noInternet:
                showAlert(title: "No Internet", message: "Please turn on the internet")
                hideLoader()
                
                
            case .notAuthorised:
                showAlert(title: "Not Authorised", message: "failed to load data")
                hideLoader()
                
            case .noData:
                showAlert(title: "No Results", message: "Movie Detail not found..")
                hideLoader()
            }
            
        }
    }
    
    private func createViews(){
        self.view.backgroundColor = .black
        self.view.addSubview(poster)
        poster.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            poster.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            poster.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            poster.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            poster.heightAnchor.constraint(equalToConstant: 260)
        ])
        
        self.view.addSubview(movieTitleLabel)
        movieTitleLabel.font.withSize(20)
        movieTitleLabel.textColor = .white
        movieTitleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        movieTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieTitleLabel.topAnchor.constraint(equalTo: self.poster.bottomAnchor, constant: 20),
            movieTitleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
        ])
        movieTitleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        self.view.addSubview(movieTitle)
        movieTitle.font.withSize(16)
        movieTitle.textColor = .lightGray
        movieTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieTitle.topAnchor.constraint(equalTo: self.movieTitleLabel.bottomAnchor, constant: 10),
            movieTitle.leadingAnchor.constraint(equalTo: self.movieTitleLabel.leadingAnchor),
            movieTitle.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
        ])
        movieTitle.numberOfLines = 0
        
        self.view.addSubview(releseDateLabel)
        releseDateLabel.textColor = .white
        releseDateLabel.font = UIFont.boldSystemFont(ofSize: 20)
        releseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            releseDateLabel.topAnchor.constraint(equalTo: self.movieTitle.bottomAnchor, constant: 10),
            releseDateLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
        ])
        releseDateLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        self.view.addSubview(releaseDate)
        releaseDate.font.withSize(16)
        releaseDate.textColor = .lightGray
        releaseDate.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            releaseDate.topAnchor.constraint(equalTo: self.releseDateLabel.topAnchor),
            releaseDate.leadingAnchor.constraint(equalTo: self.releseDateLabel.trailingAnchor, constant: 10),
            releaseDate.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            releaseDate.bottomAnchor.constraint(equalTo: self.releseDateLabel.bottomAnchor)
        ])
        
        self.view.addSubview(directorLabel)
        directorLabel.font = UIFont.boldSystemFont(ofSize: 20)
        directorLabel.textColor = .white
        directorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            directorLabel.topAnchor.constraint(equalTo: self.releaseDate.bottomAnchor, constant: 10),
            directorLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
        ])
        directorLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        self.view.addSubview(director)
        director.font.withSize(16)
        director.textColor = .lightGray
        director.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            director.topAnchor.constraint(equalTo: self.directorLabel.topAnchor),
            director.leadingAnchor.constraint(equalTo: self.directorLabel.trailingAnchor, constant: 10),
            director.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            director.bottomAnchor.constraint(equalTo: self.directorLabel.bottomAnchor)
        ])
        
        self.view.addSubview(plotLabel)
        plotLabel.font = UIFont.boldSystemFont(ofSize: 20)
        plotLabel.font.withSize(20)
        plotLabel.textColor = .white
        plotLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            plotLabel.topAnchor.constraint(equalTo: self.director.bottomAnchor, constant: 10),
            plotLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
        ])
        
        self.view.addSubview(plot)
        plot.font.withSize(16)
        plot.textColor = .lightGray
        plot.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            plot.topAnchor.constraint(equalTo: self.plotLabel.bottomAnchor, constant: 10),
            plot.leadingAnchor.constraint(equalTo: self.plotLabel.leadingAnchor),
            plot.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
        ])
        plot.numberOfLines = 0
        
        self.view.addSubview(loader)
        loader.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            loader.heightAnchor.constraint(equalToConstant: 100),
            loader.widthAnchor.constraint(equalToConstant: 100)
            
        ])
        loader.isHidden = true
        loader.stopAnimating()
        loader.color = UIColor.red
    }
}
