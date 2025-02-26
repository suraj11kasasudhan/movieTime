//
//  MovieListingVC.swift
//  MovieTime
//
//  Created by Suraj on 25/02/25.
//

import UIKit

class MovieListingVC: UIViewController{
    
    private var collectionView: UICollectionView?
    private let collectionViewLayout = UICollectionViewFlowLayout()
    private var movies:[Movie] = []
    private let searchBar = UITextField()
    private let loader  = UIActivityIndicatorView()
    private var movieService:MovieService?
    
    init(movieService:MovieService = MovieService()){
        self.movieService = movieService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        createViews()
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
    
    private func setUpSearchBar() {
        self.view.addSubview(searchBar)
        searchBar.attributedPlaceholder = NSAttributedString(
            string: "Type to search movie",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        searchBar.textColor = .white
        searchBar.backgroundColor = .black
        searchBar.layer.cornerRadius = 20
        searchBar.layer.borderColor = UIColor.gray.cgColor
        searchBar.layer.borderWidth = 1
        searchBar.returnKeyType = .search
        searchBar.delegate = self
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            searchBar.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 50))
        searchBar.leftView = paddingView
        searchBar.leftViewMode = .always
        searchBar.clearButtonMode = .always
        
    }
    
    func showAlert(title:String,message:String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
            self.collectionView?.reloadData()
        }
    }
    
    private func fetchMovieList(searchedText:String){
        showLoader()
        var params:[String:String] = [:]
        params = ["apikey":AppHelper.apiKey,"s":searchedText,"page":"\(movieService?.pageNumber ?? 0)"]
        movieService?.getMovieList(params:params) { [weak self] status,data in
            guard let self = self else { return }
            switch status {
            case .succes:
                DispatchQueue.main.async {
                    self.hideLoader()
                    self.collectionView?.reloadData()
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
                showAlert(title: "No Results", message: "Movie not found. Try searching for something else.")
                hideLoader()
            }
        }
        
    }
    
    private func createViews(){
        setUpSearchBar()
        self.view.backgroundColor = .black
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        if let collectionView = collectionView {
            self.view.addSubview(collectionView)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor, constant: 20),
                collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50),
                collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            ])
            collectionViewLayout.minimumLineSpacing = 10
            collectionViewLayout.minimumInteritemSpacing = 0
            collectionViewLayout.scrollDirection = .vertical
            collectionView.showsVerticalScrollIndicator = true
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.delegate = self
            collectionView.backgroundColor = .black
            collectionView.dataSource = self
            collectionView.register(MovieListingCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCell")
        }
        
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

extension MovieListingVC: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieService?.movies.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:MovieListingCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier:"MovieCell" , for: indexPath) as! MovieListingCollectionViewCell
        let movie = movieService?.movies[indexPath.item]
        cell.set(title: movie?.title ?? "", image: movie?.poster ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.collectionView?.bounds.width ?? 0) / 2, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            let vc = MovieDetailVC(movieId: self.movieService?.movies[indexPath.item].imdbID ?? "")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == (movieService?.movies.count ?? 0) - 3  && !(movieService?.endPagination ?? false){
            movieService?.pageNumber = (movieService?.pageNumber ?? 0) + 1
            fetchMovieList(searchedText: searchBar.text ?? "")
        }
    }
    
}

extension MovieListingVC: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.text?.count ?? 0) > 0 {
            searchBar.resignFirstResponder()
            movieService?.resetData()
            fetchMovieList(searchedText: searchBar.text ?? "")
            return true
        }
        return false
    }
}


