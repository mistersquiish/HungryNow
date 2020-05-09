//
//  PopSheet.swift
//  HungryNow
//
//  Created by Henry Vuong on 5/9/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import Foundation
import SwiftUI

///// Replacement for Action Sheet for iPad as SwiftUI ActionSheet doesn't work with iPad
//struct PopSheet {
//    let title: Text
//    let message: Text?
//    let buttons: [PopSheet.Button]
//
//    public init(title: Text, message: Text? = nil, buttons: [PopSheet.Button] = [.cancel()]) {
//        self.title = title
//        self.message = message
//        self.buttons = buttons
//    }
// 
// 
//    func actionSheet() -> ActionSheet {
//        ActionSheet(title: title, message: message, buttons: buttons.map({ popButton in
//            switch popButton.kind {
//            case .default: return .default(popButton.label, action: popButton.action)
//            case .cancel: return .cancel(popButton.label, action: popButton.action)
//            case .destructive: return .destructive(popButton.label, action: popButton.action)
//            }
//        }))
//    }
// 
//    func popover(isPresented: Binding<Bool>) -> some View {
//        VStack {
//            self.title.padding(.top)
//                .customFont(name: "Chivo-Regular", style: .headline)
//            Divider()
//            ForEach(Array(self.buttons.enumerated()), id: \.offset) { (offset, button) in
//                VStack {
//                    SwiftUI.Button(action: {
//                        isPresented.wrappedValue = false
//                        DispatchQueue.main.async {
//                            button.action?()
//                        }
//                    }) {
//                        self.ButtonView(button: button)
//                    }
//                }.padding()
//            }
//        }
//        .frame(maxWidth: .infinity)
//    }
//    
//    func ButtonView(button: Button) -> AnyView {
//        switch button.kind {
//        case .default:
//            return AnyView(button.label
//                .customFont(name: "Chivo-Regular", style: .body)
//                .frame(width: 250, height: 50)
//                .foregroundColor(Color("font"))
//                .background(Color("background2"))
//                .cornerRadius(20))
//        case .cancel:
//            return AnyView(button.label
//                .customFont(name: "Chivo-Regular", style: .body)
//                .frame(width: 250, height: 50)
//                .foregroundColor(Color("subheading"))
//                .background(Color("background2"))
//                .cornerRadius(20))
//        case .destructive:
//            return AnyView(button.label
//                .customFont(name: "Chivo-Regular", style: .body)
//                .frame(width: 250, height: 50)
//                .foregroundColor(Color("font"))
//                .background(Color.red)
//                .cornerRadius(20))
//        }
//    }
// 
// public struct Button {
//  let kind: Kind
//  let label: Text
//  let action: (() -> Void)?
//  enum Kind { case `default`, cancel, destructive }
//  
//  /// Creates a `Button` with the default style.
//  public static func `default`(_ label: Text, action: (() -> Void)? = {}) -> Self {
//   Self(kind: .default, label: label, action: action)
//  }
//  
//  /// Creates a `Button` that indicates cancellation of some operation.
//  public static func cancel(_ label: Text, action: (() -> Void)? = {}) -> Self {
//   Self(kind: .cancel, label: label, action: action)
//  }
//  
//  /// Creates an `Alert.Button` that indicates cancellation of some operation.
//  public static func cancel(_ action: (() -> Void)? = {}) -> Self {
//   Self(kind: .cancel, label: Text("Cancel"), action: action)
//  }
//  
//  /// Creates an `Alert.Button` with a style indicating destruction of some data.
//  public static func destructive(_ label: Text, action: (() -> Void)? = {}) -> Self {
//   Self(kind: .destructive, label: label, action: action)
//  }
// }
//}
//
//extension View {
// func popSheet(isPresented: Binding<Bool>, arrowEdge: Edge = .top, content: @escaping () -> PopSheet) -> some View {
//  Group {
//   if UIDevice.current.userInterfaceIdiom == .pad {
//    popover(isPresented: isPresented, attachmentAnchor: .point(.topTrailing), arrowEdge: arrowEdge, content: { content().popover(isPresented: isPresented) })
//   } else {
//    actionSheet(isPresented: isPresented, content: { content().actionSheet() })
//   }
//  }
// }
//}
