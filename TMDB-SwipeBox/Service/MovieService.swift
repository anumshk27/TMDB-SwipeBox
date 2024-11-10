//
//  MovieService.swift
//  TMDB-SwipeBox
//
//  Created by Haider Shahzad on 10/11/2024.
//

import Foundation
import Combine

protocol MovieService {
    func fetchPopular(page: Int) -> AnyPublisher<[Movie], Error>
    func fetchMovie(id: Int) -> AnyPublisher<Movie, Error>
}


public enum Endpoint: String, CustomStringConvertible, CaseIterable {
    case popular
    case movie = "details"
    
    public var description: String {
        switch self {
        case .popular: return "Popular"
        case .movie: return "Movie"
        }
    }
    
    public init?(index: Int) {
        switch index {
        case 0: self = .popular
        case 1: self = .movie
        default: return nil
        }
    }
    
    public init?(description: String) {
        guard let first = Endpoint.allCases.first(where: { $0.description == description }) else {
            return nil
        }
        self = first
    }
    
}

public enum MovieError: Error {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
}
