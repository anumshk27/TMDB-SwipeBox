//
//  MoviesViewController.swift
//  TMDB-SwipeBox
//
//  Created by Haider Shahzad on 10/11/2024.
//

import UIKit
import Combine

class MoviesViewController: UIViewController {
    
    private var viewModel = MoviesViewModel()
    private var collectionViewHandler: MoviesCollectionViewHandler?
    private var cancellables = Set<AnyCancellable>()
    
    /*private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 150)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()*/
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let padding: CGFloat = 10
        let numberOfItemsPerRow: CGFloat = 3
        let totalPadding = padding * (numberOfItemsPerRow + 1)
        let itemWidth = (view.frame.width - totalPadding) / numberOfItemsPerRow
        
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5)
        layout.minimumInteritemSpacing = padding
        layout.minimumLineSpacing = padding
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupCollectionViewHandler()
        bindViewModel()
        viewModel.fetchPopularMovies()
    }
    
    private func setupViews() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupCollectionViewHandler() {
        collectionViewHandler = MoviesCollectionViewHandler(viewModel: viewModel, collectionView: collectionView)
    }
    
    private func bindViewModel() {
        viewModel.$movies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)
    }
}
