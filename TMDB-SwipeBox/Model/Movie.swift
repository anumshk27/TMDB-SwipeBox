import Foundation

/// Response object for a paginated list of movies from TMDb API.
public struct MoviesResponse: Codable {
    public let page: Int
    public let totalResults: Int
    public let totalPages: Int
    public let results: [Movie]
}

/// Represents a movie with relevant details and computed properties for URLs and display text.
public struct Movie: Codable {
    
    public let id: Int
    public let title: String
    public let backdropPath: String?
    public let posterPath: String?
    public let overview: String
    public let releaseDate: Date?
    public let voteAverage: Double
    public let voteCount: Int
    public let tagline: String?
    public let genres: [MovieGenre]?
    public let adult: Bool
    public let runtime: Int?
    
    /// Computed property to construct the poster URL, if available.
    public var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
    
    /// Computed property to construct the backdrop URL, if available.
    public var backdropURL: URL? {
        guard let path = backdropPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/original\(path)")
    }
    
    /// Computed property to convert vote average to a percentage format.
    public var voteAveragePercentText: String {
        return "\(Int(voteAverage * 10))%"
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, backdropPath = "backdrop_path", posterPath = "poster_path"
        case overview, releaseDate = "release_date", voteAverage = "vote_average"
        case voteCount = "vote_count", tagline, genres, adult, runtime
    }
}

/// Represents a genre associated with a movie.
public struct MovieGenre: Codable {
    public let name: String
}

/// Response object for videos associated with a movie.
public struct MovieVideoResponse: Codable {
    public let results: [MovieVideo]
}

/// Represents a video resource, typically a trailer or clip, associated with a movie.
public struct MovieVideo: Codable {
    public let id: String
    public let key: String
    public let name: String
    public let site: String
    public let size: Int
    public let type: String
    
    /// Computed property to construct the YouTube URL if the video is hosted on YouTube.
    public var youtubeURL: URL? {
        guard site == "YouTube" else { return nil }
        return URL(string: "https://www.youtube.com/watch?v=\(key)")
    }
}

