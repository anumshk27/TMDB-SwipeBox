//
//  MovieDetailViewModel.swift
//  TMDB-SwipeBox
//
//  Created by Haider Shahzad on 10/11/2024.
//

import Foundation
import Combine

class MovieDetailViewModel {
    @Published var movie: Movie? = nil
    @Published var errorMessage: String? = nil
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    private let movieService: MovieService
    
    init(movieService: MovieService = MovieServiceImpl()) {
        self.movieService = movieService
    }
    
    func fetchMovieDetails(movieId: Int) {
        guard !isLoading else { return }
        isLoading = true
        
        movieService.fetchMovie(id: movieId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    print("Failed to fetch movie details:", error)
                case .finished:
                    print("Successfully fetched movie details.")
                }
            }, receiveValue: { [weak self] movie in
                self?.movie = movie
            })
            .store(in: &cancellables)
    }
}
