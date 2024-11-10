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
    private var cancellables = Set<AnyCancellable>()
    
    func fetchPopular(page: Int) -> AnyPublisher<[Movie], Error> {
        let url = URL(string: "\(baseURL)/movie/popular?api_key=\(apiKey)&page=\(page)")!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: MovieListResponse.self, decoder: JSONDecoder())
            .map { $0.results }
            .mapError { error in
                if let decodingError = error as? DecodingError {
                    return MovieError.serializationError
                }
                return MovieError.apiError
            }
            .eraseToAnyPublisher()
    }
    
    public func fetchMovie(id: Int) -> AnyPublisher<Movie, Error> {
        guard let url = URL(string: "\(baseURL)/movie/\(id)?api_key=\(apiKey)&append_to_response=videos,credits") else {
            return Fail(error: MovieError.invalidEndpoint).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw MovieError.invalidResponse
                }
                return data
            }
            .decode(type: Movie.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    

}
