//
//  ViewController.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/9/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import SwiftUI

class SavedVC: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBSegueAction func addSwiftUIView(_ coder: NSCoder) -> UIViewController? {
        let rootView = SavedView().environment(\.managedObjectContext, context)
        return UIHostingController(coder: coder, rootView: rootView)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // delegates
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
    }

    
}
