//
//  LoadingView.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/30/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import Foundation
import SwiftUI

/// Loading View with indicator. Made by Kavsoft
struct Loading: View {
    var body: some View {
        ZStack {
            BlurView()
            
            VStack {
                Indicator()
                Text("Loading").foregroundColor(.white).padding(.top, 8)
            }
        }.frame(width: 250, height: 250)
    }
}

struct BlurView: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<BlurView>) -> UIVisualEffectView {
        let effect = UIBlurEffect(style: .systemMaterialDark)
        let view = UIVisualEffectView(effect: effect)
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<BlurView>) {
    }
}

struct Indicator: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<Indicator>) -> UIActivityIndicatorView {
        let indi = UIActivityIndicatorView(style: .large)
        indi.color = UIColor.white
        indi.startAnimating()
        return indi
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Indicator>) {
    }
}
