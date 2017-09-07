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
    fileprivate lazy var searchService = SearchService()
    fileprivate let cellIdentifier = "PhotoCell"
    fileprivate let spacing: CGFloat = 20.0
    fileprivate var totalCount: Int = 0
    fileprivate var currentPage: Int = 1

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
        NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 80).isActive = true
        
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
        _setupLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        photos = []
        totalCount = 0
        collectionView.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)
        
        if let photoFooterView = footerView as? PhotoFooterReusableView {
            if totalCount == photos.count {
                photoFooterView.activityIndicator.stopAnimating()
            } else {
                photoFooterView.activityIndicator.startAnimating()
            }
        }
        
        return footerView
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let text = textField.text else { return }
        
        if (indexPath.row == photos.count - 1) && (totalCount != photos.count) {
            currentPage = currentPage + 1
            _search(text)
        }
    }
}

// MARK: - UITextFieldDelegate
extension PhotoSearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text,
            text.isEmpty == false {
            currentPage = 1
            _showProgressLabel()
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
        collectionView.register(PhotoFooterReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer")
        collectionView.backgroundColor = UIColor.white
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
            flowLayout.minimumInteritemSpacing = spacing
            flowLayout.minimumLineSpacing = spacing
            flowLayout.footerReferenceSize = CGSize(width: 300, height: 40)
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
    
    func _setupLabel() {
        label.text = "Searching ..."
        label.textAlignment = .center
    }
    
    func _search(_ text: String) {
        searchService.search(text: text, page: currentPage) {[weak self] (result) in
            DispatchQueue.main.async {
                self?._showCollectionView()
                switch result {
                case .success(let searchResponse):
                    self?._handleSuccess(searchResponse)
                case .failure(let error):
                    self?._handleFailure(error)
                }
            }
        }
    }
    
    func _showCollectionView() {
        collectionView.isHidden = false
    }
    
    func _showProgressLabel() {
        collectionView.isHidden = true
    }
    
    func _handleSuccess(_ searchResponse: SearchResponse) {
        totalCount = searchResponse.totalCount
    
        if currentPage == 1 {
            photos = searchResponse.photots
        } else {
            photos += searchResponse.photots
        }
        
        collectionView.reloadData()
    }
    
    func _handleFailure(_ error: NSError) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
