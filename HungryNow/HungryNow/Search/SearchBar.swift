//
//  SearchBar.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/11/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//


// From https://medium.com/@axelhodler/creating-a-search-bar-for-swiftui-e216fe8c8c7f
import Foundation
import SwiftUI
import CoreLocation

struct SearchBar: UIViewRepresentable {

    @Binding var text: String
    var onSearchButtonClicked: ((String) -> Void)? = nil

    class Coordinator: NSObject, UISearchBarDelegate {

        @Binding var text: String
        let control: SearchBar

        init(text: Binding<String>, _ control: SearchBar) {
            _text = text
            self.control = control
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            control.onSearchButtonClicked?(text)
        }
    }

    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text, self)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search for Restaurants"
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}
