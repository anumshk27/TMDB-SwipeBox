//
//  MoviesViewModel.swift
//  TMDB-SwipeBox
//
//  Created by Haider Shahzad on 10/11/2024.
//

import Foundation
import Combine

class MoviesViewModel {
    @Published var movies: [Movie] = []
    @Published var errorMessage: String? = nil
    private var currentPage = 1
    private var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchPopularMovies() {
        guard !isLoading else { return }
        isLoading = true
        
        NetworkManager.shared.fetchPopularMovies(page: currentPage)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] newMovies in
                self?.movies.append(contentsOf: newMovies)
                self?.currentPage += 1
            })
            .store(in: &cancellables)
    }
}

