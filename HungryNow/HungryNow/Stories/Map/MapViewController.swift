//
//  MapViewControllerSWIFT.swift
//  HungryNow
//
//  Created by Henry Vuong on 5/10/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import UIKit
import SwiftUI
import MapKit

class MapViewControllerSWIFT: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBSegueAction func addSwiftUIView(_ coder: NSCoder) -> UIViewController? {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let rootView = MainMapView(vcDelegate: self, notifications: delegate.notifications).environment(\.managedObjectContext, context)
        
        return UIHostingController(coder: coder, rootView: rootView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
