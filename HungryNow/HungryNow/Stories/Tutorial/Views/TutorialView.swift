//
//  TutorialView.swift
//  HungryNow
//
//  Created by Henry Vuong on 5/14/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import Foundation
import SwiftUI
import ConcentricOnboarding

struct TutorialView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        let pages = (0...3).map { i in
            AnyView(PageView(title: TutorialData.title, imageName: TutorialData.imageNames[i], header: TutorialData.headers[i], content: TutorialData.contentStrings[i], textColor: TutorialData.textColors[i]))
        }
        var onboardingView = ConcentricOnboardingView(pages: pages, bgColors: TutorialData.colors)
        onboardingView.insteadOfCyclingToFirstPage = {
            // if first time seeing tutorial screen present new VC, if not dismiss modal sheet
            if UserDefaults.standard.bool(forKey: "didSeeTutorial") {
                self.presentationMode.wrappedValue.dismiss()
            } else {
                // update user defaults
                UserDefaults.standard.set(true, forKey: "didSeeTutorial")
                // present main view home
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let savedVC = storyboard.instantiateViewController(withIdentifier: "Home")
                UIApplication.shared.delegate?.window?!.rootViewController = savedVC
                UIApplication.shared.delegate?.window?!.setRootViewController(savedVC, options: TransitionOptions(direction: .toRight))
            }
        }
        return onboardingView
            
    }
}
