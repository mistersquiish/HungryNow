//
//  SearchViewController.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/11/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import UIKit
import SwiftUI

/// Embeds the Search View inside the hosting view controller
class SearchViewController: UIViewController {
    
    var notifications: Notifications!

    @IBSegueAction func addSwiftUIView(_ coder: NSCoder) -> UIViewController? {
        let rootView = SearchView(notifications: notifications, vcDelegate: self)
        let hostController = UIHostingController(coder: coder, rootView: rootView)
                            
        return hostController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
