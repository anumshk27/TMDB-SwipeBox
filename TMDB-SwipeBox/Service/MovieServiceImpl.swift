//
//  MovieServiceImpl.swift
//  TMDB-SwipeBox
//
//  Created by Haider Shahzad on 10/11/2024.
//

import Foundation
import Combine

class MovieServiceImpl: MovieService {
    
    private let baseURL = "https://api.themoviedb.org/3"
    private let apiKey = "015b6cc31fb5f4a10746df69eb2e27cb"
    private let session = URLSession.shared
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchPopular(page: Int) -> AnyPublisher<[Movie], Error> {
        let url = URL(string: "\(baseURL)/movie/popular?api_key=\(apiKey)&page=\(page)")!
        
        return session.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: MoviesResponse.self, decoder: JSONDecoder())
            .mapError { error in
                if error is DecodingError {
                    return MovieError.serializationError
                }
                return MovieError.apiError
            }
            .map { $0.results ?? [] }
            .eraseToAnyPublisher()
    }
    
    func fetchMovie(id: Int) -> AnyPublisher<Movie, Error> {
        let url = URL(string: "\(baseURL)/movie/\(id)?api_key=\(apiKey)")!
        
        return session.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: Movie.self, decoder: JSONDecoder())
            .mapError { error in
                if error is DecodingError {
                    return MovieError.serializationError
                }
                return MovieError.apiError
            }
            .eraseToAnyPublisher()
    }
    
    
}
