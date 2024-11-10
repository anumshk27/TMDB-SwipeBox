//
//  MovieDetails.swift
//  TMDB-SwipeBox
//
//  Created by Haider Shahzad on 10/11/2024.
//

import UIKit
import Combine
import SDWebImage

class MovieDetailsController: UIViewController {
    
    @IBOutlet var backDropImg: UIImageView!
    @IBOutlet var posterImg: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var overviewLabel: UILabel!
    @IBOutlet var releaseDateLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    
    var movie: Movie!
    var viewModel: MovieDetailViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = MovieDetailViewModel()
        bindViewModel()
        
        viewModel.fetchMovieDetails(movieId: movie.id!)
        
    }
    
    
    private let gradientOverlay: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.6).cgColor]
        gradient.locations = [0.5, 1.0]
        return gradient
    }()
    
    
    private func updateUI(with movie: Movie?) {
        guard let movie = movie else { return }
        
        
        let title = movie.title ?? "No Title"
        let releaseDate = movie.releaseDate ?? "N/A"
        
        let attributedText = NSAttributedString()
            .highlightTitleAndReleaseDate(
                title: title,
                releaseDate: releaseDate,
                titleColor: .black, // Title color
                titleFont: UIFont.boldSystemFont(ofSize: 18), // Title font
                releaseDateColor: .gray, // Release date color
                releaseDateFont: UIFont.systemFont(ofSize: 14) // Release date font
            )
        
        titleLabel.attributedText = attributedText
        overviewLabel.text = movie.overview
        ratingLabel.text = "⭐️ \(String(format: "%.1f", movie.voteAverage ?? 0.0))"
        posterImg.sd_setImage(with: movie.posterURL, placeholderImage: UIImage(named: "placeholder"))
        backDropImg.sd_setImage(with: movie.backdropURL, placeholderImage: UIImage(named: "placeholder"))
        
    }
    
    private func bindViewModel() {
        viewModel.$movie
            .sink { [weak self] movie in
                self?.updateUI(with: movie)
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .sink { [weak self] errorMessage in
                if let error = errorMessage {
                    self?.showError(error)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.showLoadingIndicator()
                } else {
                    self?.hideLoadingIndicator()
                }
            }
            .store(in: &cancellables)
    }
}
