//
//  MoviesListViewModel.swift
//  TMDB-SwipeBox
//
//  Created by Haider Shahzad on 10/11/2024.
//

import Foundation
import Combine

class MoviesListViewModel {
    @Published var movies: [Movie] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading = false
    
    private var currentPage = 1
    
    private var cancellables = Set<AnyCancellable>()
    
    private let movieService: MovieService
    
    init(movieService: MovieService = MovieServiceImpl()) {
        self.movieService = movieService
    }
    
    func fetchPopular() {
        guard !isLoading else { return }
        isLoading = true
        
        movieService.fetchPopular(page: currentPage)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false // Reset loading state on completion
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    print("Failed to fetch popular movies:", error)
                case .finished:
                    print("Successfully fetched popular movies.")
                }
            }, receiveValue: { [weak self] newMovies in
                self?.movies.append(contentsOf: newMovies)
                self?.currentPage += 1
            })
            .store(in: &cancellables)
    }
}
