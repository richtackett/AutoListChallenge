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
    fileprivate var photo: Photo?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.white
        
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func populate(_ photo: Photo) {
        self.photo = photo
        imageView.kf.setImage(with: photo.imageURL)
    }
    
    func buttonTapped(_ sender : UIButton) {
        guard var photo = photo else {
            return
        }
        
        photo.isSelected = !photo.isSelected
        self.photo = photo
        
        if photo.isSelected {
            contentView.backgroundColor = UIColor.red
            favoriteButton.setImage(UIImage(named: "solidHeart"), for: .normal)
        } else {
            contentView.backgroundColor = UIColor.white
            favoriteButton.setImage(UIImage(named: "heart"), for: .normal)
        }
        
        //call repo here to store in cache
    }
}
