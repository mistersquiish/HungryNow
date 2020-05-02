//
//  ProcessedImage.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/11/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//
import SwiftUI

class ImageLoader: ObservableObject {
    static var imageCache: [String: Data] = [:]
    
    @Published var data = Data()

    init(imageURL: String) {
        // check if image is already cached
        if ImageLoader.imageCache.keys.contains(imageURL) {
            self.data = ImageLoader.imageCache[imageURL]!
        } else {
            guard let url = URL(string: imageURL) else { return }
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self.data = data
                    ImageLoader.imageCache[imageURL] = data
                }
            }
            task.resume()
        }
        
    }
}
