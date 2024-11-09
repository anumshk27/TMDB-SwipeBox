//
//  MoviesCollectionViewHandler.swift
//  TMDB-SwipeBox
//
//  Created by Haider Shahzad on 10/11/2024.
//

import UIKit
import Combine

class MoviesCollectionViewHandler: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDataSourcePrefetching {
    
    private let viewModel: MoviesViewModel
    private let collectionView: UICollectionView
    
    init(viewModel: MoviesViewModel, collectionView: UICollectionView) {
        self.viewModel = viewModel
        self.collectionView = collectionView
        super.init()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseIdentifier)
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseIdentifier, for: indexPath) as? MovieCell else {
            return UICollectionViewCell()
        }
        let movie = viewModel.movies[indexPath.item]
        cell.configure(with: movie)
        return cell
    }
    
    // MARK: - UICollectionViewDataSourcePrefetching
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: { $0.item >= self.viewModel.movies.count - 1 }) {
            viewModel.fetchPopularMovies()
        }
    }
}