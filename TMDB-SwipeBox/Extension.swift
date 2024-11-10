//
//  Extension.swift
//  TMDB-SwipeBox
//
//  Created by Haider Shahzad on 10/11/2024.
//

import UIKit

private var loadingIndicatorKey: UInt8 = 0

extension UIViewController {
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showLoadingIndicator() {
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.center = view.center
        loadingIndicator.startAnimating()
        view.addSubview(loadingIndicator)
        
        objc_setAssociatedObject(self, &loadingIndicatorKey, loadingIndicator, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func hideLoadingIndicator() {
        if let loadingIndicator = objc_getAssociatedObject(self, &loadingIndicatorKey) as? UIActivityIndicatorView {
            loadingIndicator.stopAnimating()
            loadingIndicator.removeFromSuperview()
        }
    }
}

extension NSAttributedString {
    func highlighting(_ substring: String, using color: UIColor, andFont font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: self)
        attributedString.addAttribute(.font, value: font, range: (self.string as NSString).range(of: substring))
        attributedString.addAttribute(.foregroundColor, value: color, range: (self.string as NSString).range(of: substring))
        return attributedString
    }
    
    func highlightTitleAndReleaseDate(title: String, releaseDate: String, titleColor: UIColor, titleFont: UIFont, releaseDateColor: UIColor, releaseDateFont: UIFont) -> NSAttributedString {
        let combinedString = "\(title)\n\(releaseDate)"
        
        let attributedString = NSMutableAttributedString(string: combinedString)
        
        // Apply attributes to title
        attributedString.addAttribute(.foregroundColor, value: titleColor, range: (combinedString as NSString).range(of: title))
        attributedString.addAttribute(.font, value: titleFont, range: (combinedString as NSString).range(of: title))
        
        // Apply attributes to release date
        attributedString.addAttribute(.foregroundColor, value: releaseDateColor, range: (combinedString as NSString).range(of: releaseDate))
        attributedString.addAttribute(.font, value: releaseDateFont, range: (combinedString as NSString).range(of: releaseDate))
        
        return attributedString
    }
}
