//
//  AppHelper.swift
//  MovieTime
//
//  Created by Suraj on 26/02/25.
//

import Foundation
import UIKit

final class AppHelper {
    
    private init() {}
    static let moviesEndpoint = "https://www.omdbapi.com/"
    static let apiKey = "b0abbf7f"
    
    static func loadImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = ImageCacheManager.shared.getImage(forKey: urlString) {
            completion(cachedImage)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(defaultMovieImage())
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data), error == nil else {
                completion(defaultMovieImage())
                return
            }
            
            ImageCacheManager.shared.setImage(image, forKey: urlString)
            completion(image)
        }.resume()
    }
    
    private static func defaultMovieImage() -> UIImage? {
        return UIImage(systemName: "film")
    }
    
}
