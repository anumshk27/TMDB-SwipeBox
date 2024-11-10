//
//  MoviesViewController.swift
//  TMDB-SwipeBox
//
//  Created by Haider Shahzad on 10/11/2024.
//

import UIKit
import Combine

class MoviesListViewController: UIViewController, MoviesCollectionViewHandlerDelegate {
    
    private var viewModel = MoviesListViewModel()
    private var collectionViewHandler: MoviesCollectionViewHandler?
    private var cancellables = Set<AnyCancellable>()
    
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
        viewModel.fetchPopular()
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
        collectionViewHandler?.delegate = self;
    }
    
    private func bindViewModel() {
        // Binding movie data to update the collection view
        viewModel.$movies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        // Binding error message to show an alert
        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                self?.showError(errorMessage)
            }
            .store(in: &cancellables)
        
        // Binding loading state to show/hide the loading indicator
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.showLoadingIndicator()
                } else {
                    self?.hideLoadingIndicator()
                }
            }
            .store(in: &cancellables)
    }
    
    
    // MARK: - MoviesCollectionViewHandlerDelegate
    
    func didSelectMovie(_ movie: Movie) {
        
        let detailVC =  self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailsController") as! MovieDetailsController
        detailVC.movie = movie
        navigationController?.pushViewController(detailVC, animated: true)
        
        
    }
}
