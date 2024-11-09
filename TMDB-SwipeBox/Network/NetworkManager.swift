//
//  NetworkManager.swift
//  TMDB-SwipeBox
//
//  Created by Haider Shahzad on 10/11/2024.
//

import Foundation
import Combine

class NetworkManager {
    static let shared = NetworkManager()
    private let apiKey = "015b6cc31fb5f4a10746df69eb2e27cb"
    private let baseURL = "https://api.themoviedb.org/3/movie/popular"
    
    private init() {}
    
    func fetchPopularMovies(page: Int) -> AnyPublisher<[Movie], Error> {
        guard let url = URL(string: "\(baseURL)?api_key=\(apiKey)&page=\(page)") else {
            print("Invalid URL")
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        print("Fetching movies from URL: \(url)")
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { data, response in
                print("Received data: \(data)")
                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP Status Code: \(httpResponse.statusCode)")
                }
                return data
            }
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .map { response in
                print("Decoded response: \(response)")
                return response.results
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

}
