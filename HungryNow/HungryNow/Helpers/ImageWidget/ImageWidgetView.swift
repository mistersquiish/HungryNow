//
//  ImageWidgetView.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/12/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import Foundation
import SwiftUI

struct ImageViewWidget: View {
    @ObservedObject var imageLoader: ImageLoader
    
    init(imageURL: String) {
        imageLoader = ImageLoader(imageURL: imageURL)
    }
    
    var body: some View {
        VStack {
            Image(uiImage: (UIImage(data: imageLoader.data) ?? UIImage(named: "missing-restaurant")!))
                .resizable()
                .aspectRatio(1, contentMode: .fit)
        }
        .frame(width: 125, height: 125)
    }
}
