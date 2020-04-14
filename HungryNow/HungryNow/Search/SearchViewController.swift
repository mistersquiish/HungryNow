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

    @IBSegueAction func addSwiftUIView(_ coder: NSCoder) -> UIViewController? {
        let hostController = UIHostingController(coder: coder, rootView: SearchView(vcDelegate: self))
        return hostController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
