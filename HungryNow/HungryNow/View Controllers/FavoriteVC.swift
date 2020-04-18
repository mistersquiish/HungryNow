//
//  ViewController.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/9/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import SwiftUI

class FavoriteVC: UIViewController {
    
    @IBSegueAction func addSwiftUIView(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: FavoriteView())
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delegates
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
    }

    
}
