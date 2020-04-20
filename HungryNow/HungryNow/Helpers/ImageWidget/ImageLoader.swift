//
//  ProcessedImage.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/11/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//
import SwiftUI

class ImageLoader: ObservableObject {
    @Published var data = Data()

    init(imageURL: String) {
        guard let url = URL(string: imageURL) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
    }
}
