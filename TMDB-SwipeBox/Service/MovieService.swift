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

public enum MovieError: Error {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
}

