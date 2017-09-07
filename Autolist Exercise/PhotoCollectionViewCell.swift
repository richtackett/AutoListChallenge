//
//  PhotoCollectionViewCell.swift
//  Autolist Exercise
//
//  Created by RICHARD TACKETT on 9/6/17.
//  Copyright © 2017 RICHARD TACKETT. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoCollectionViewCell: UICollectionViewCell {
    fileprivate let imageView = UIImageView(frame: .zero)
    fileprivate let favoriteButton = UIButton(frame: .zero)
    fileprivate let favoritesStore = PhotoFavoritesStore()
    fileprivate var photo: Photo?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func populate(_ photo: Photo) {
        self.photo = photo
        self.photo?.isFavorite = favoritesStore.isFavorite(photoID: photo.id)
        imageView.kf.setImage(with: photo.imageURL)
        _setFavoriteDisplay(isFavorite: self.photo?.isFavorite ?? false)
    }
    
    func buttonTapped(_ sender : UIButton) {
        guard var photo = photo else {
            return
        }
        
        photo.isFavorite = !photo.isFavorite
        self.photo = photo
        _setFavoriteDisplay(isFavorite: photo.isFavorite)
        favoritesStore.saveAsFavorite(photoID: photo.id)
    }
}

// MARK: - Private Helper Methods
fileprivate extension PhotoCollectionViewCell {
    func _setupCell() {
        contentView.backgroundColor = UIColor.white
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.color = UIColor.lightGray
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: imageView, attribute: .trailing, multiplier: 1.0, constant: 10).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: 10).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: imageView, attribute: .bottom, multiplier: 1.0, constant: 10).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 10).isActive = true
        
        favoriteButton.setImage(UIImage(named: "heart"), for: .normal)
        favoriteButton.backgroundColor = UIColor.white.withAlphaComponent(0.60)
        favoriteButton.layer.cornerRadius = 4.0
        favoriteButton.clipsToBounds = true
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        contentView.addSubview(favoriteButton)
        NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: favoriteButton, attribute: .trailing, multiplier: 1.0, constant: 20).isActive = true
        NSLayoutConstraint(item: favoriteButton, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 20).isActive = true
        NSLayoutConstraint(item: favoriteButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40).isActive = true
        NSLayoutConstraint(item: favoriteButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40).isActive = true
    }
    
    func _setFavoriteDisplay(isFavorite: Bool) {
        if isFavorite {
            contentView.backgroundColor = UIColor.red
            favoriteButton.setImage(UIImage(named: "solidHeart"), for: .normal)
        } else {
            contentView.backgroundColor = UIColor.white
            favoriteButton.setImage(UIImage(named: "heart"), for: .normal)
        }
    }
}
