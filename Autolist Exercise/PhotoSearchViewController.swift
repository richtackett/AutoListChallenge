//
//  PhotoSearchViewController.swift
//  Autolist Exercise
//
//  Created by RICHARD TACKETT on 9/6/17.
//  Copyright © 2017 RICHARD TACKETT. All rights reserved.
//

import UIKit

class PhotoSearchViewController: UIViewController {
    fileprivate let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    fileprivate let textField = UITextField(frame: .zero)
    fileprivate let label = UILabel(frame: .zero)
    fileprivate var photos = [Photo]()
    fileprivate lazy var networkService = NetworkService()
    fileprivate let cellIdentifier = "PhotoCell"
    fileprivate let spacing: CGFloat = 20.0

    override func loadView() {
        view = UIView(frame: .zero)
        
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: textField, attribute: .trailing, multiplier: 1.0, constant: 20).isActive = true
        NSLayoutConstraint(item: textField, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 20).isActive = true
        NSLayoutConstraint(item: textField, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 20).isActive = true
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: label, attribute: .trailing, multiplier: 1.0, constant: 20).isActive = true
        NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 20).isActive = true
        NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 60).isActive = true
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: collectionView, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: collectionView, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: textField, attribute: .bottom, multiplier: 1.0, constant: 10).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.title = "Photo Search"
        _setupCollectionView()
        _setupTextField()
        label.text = "Searching ..."
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        photos = []
        collectionView.reloadData()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension PhotoSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        
        if let photoCell = cell as? PhotoCollectionViewCell {
            photoCell.populate(photos[indexPath.row])
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PhotoSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let newSize: CGFloat
        if case .phone = traitCollection.userInterfaceIdiom {
            let rightAndLeftSpace = spacing * 2
            newSize = collectionView.frame.size.width - rightAndLeftSpace
        } else {
            let rightMiddleAndLeftSpace = spacing * 3
            newSize = (collectionView.frame.size.width - rightMiddleAndLeftSpace) / 2
        }
        
        return CGSize(width: newSize, height: newSize)
    }
}

// MARK: - UICollectionViewDelegate
extension PhotoSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoViewController = PhotoViewController()
        photoViewController.photo = photos[indexPath.row]
        navigationController?.pushViewController(photoViewController, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension PhotoSearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text,
            text.isEmpty == false {
            _search(text)
        }
        
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Private Helper Methods
fileprivate extension PhotoSearchViewController {
    func _setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.backgroundColor = UIColor.white
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
            flowLayout.minimumInteritemSpacing = spacing
            flowLayout.minimumLineSpacing = spacing
        }
    }
    
    func _setupTextField() {
        textField.backgroundColor = UIColor.lightGray
        textField.placeholder = "Enter text here"
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.keyboardType = .default
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing;
        textField.contentVerticalAlignment = .center
        textField.delegate = self
        textField.becomeFirstResponder()
    }
    
    func _search(_ text: String) {
        _becomeIdle()
        networkService.search(text: text, page: 1) {[weak self] (result) in
            DispatchQueue.main.async {
                self?._becomeActive()
                switch result {
                case .success(let searchResponse):
                    self?._handleSuccess(searchResponse)
                case .failure(let error):
                    self?._handleFailure(error)
                }
            }
        }
    }
    
    func _becomeActive() {
        collectionView.isHidden = false
    }
    
    func _becomeIdle() {
        collectionView.isHidden = true
    }
    
    func _handleSuccess(_ searchResponse: SearchResponse) {
        photos = searchResponse.photots
        collectionView.reloadData()
    }
    
    func _handleFailure(_ error: NSError) {
        //show error from ns error in alert
    }
}
