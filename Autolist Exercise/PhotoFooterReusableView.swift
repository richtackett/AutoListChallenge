//
//  PhotoFooterReusableView.swift
//  Autolist Exercise
//
//  Created by RICHARD TACKETT on 9/6/17.
//  Copyright © 2017 RICHARD TACKETT. All rights reserved.
//

import UIKit

class PhotoFooterReusableView: UICollectionReusableView {
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
