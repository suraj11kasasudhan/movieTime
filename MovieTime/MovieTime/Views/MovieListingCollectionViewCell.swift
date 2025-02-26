//
//  MovieListingCollectionViewCell.swift
//  MovieTime
//
//  Created by Suraj on 25/02/25.
//

import UIKit
import Foundation

class MovieListingCollectionViewCell: UICollectionViewCell{
    private let cardView = UIView()
    private let poster = UIImageView()
    private let titleLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = ""
        self.poster.image = nil
    }
    
    private func createViews(){
        self.contentView.addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.layer.cornerRadius = 6
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            cardView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            cardView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            cardView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
        ])
        
        cardView.addSubview(poster)
        poster.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            poster.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            poster.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            poster.topAnchor.constraint(equalTo: cardView.topAnchor),
        ])
        
        cardView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .white
        titleLabel.text = "hey suraj"
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: poster.bottomAnchor,constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 10)
        ])
    }
    
    func set(title:String,image:String){
        titleLabel.text = title
        AppHelper.loadImage(urlString: image) { image in
            DispatchQueue.main.async {
                self.poster.image = image
            }
        }
    }
}
