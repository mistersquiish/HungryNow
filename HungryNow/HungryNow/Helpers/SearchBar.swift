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
        
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            searchBar.setShowsCancelButton(true, animated: true)
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            control.onSearchButtonClicked?(text)
            searchBar.endEditing(true)
            searchBar.setShowsCancelButton(false, animated: true)
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.endEditing(true)
            searchBar.setShowsCancelButton(false, animated: true)
        }
    }

    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text, self)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        // UI changes to search bar
        searchBar.tintColor = UIColor(named: "accent")
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor(named: "font")
        textFieldInsideSearchBar?.tintColor = UIColor(named: "accent")
        
        // glass icon color
        let glassIconView = textFieldInsideSearchBar?.leftView as? UIImageView
        glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
        glassIconView?.tintColor = UIColor(named: "accent")
        
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search for Restaurants"
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}


enum SearchError: Error {
    case NoBusinesses
    case LocationNotEnabled
    case NoInternet
}

extension SearchError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .NoBusinesses:
            return NSLocalizedString("No restaurants found. Try searching again. (Hint: Type only alpha or numerical characters)", comment: "")
        case .LocationNotEnabled:
            return NSLocalizedString("Cannot detect location. Please enable location.", comment: "")
        case .NoInternet:
            return NSLocalizedString("No internet connection. Please connect to Wifi", comment: "")
        }
        
    }
}
