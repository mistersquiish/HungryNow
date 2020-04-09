//
//  AddVC.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/9/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import UIKit

class AddVC: UIViewController {

    @IBOutlet weak var popUpContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchController = UISearchController(searchResultsController: nil)
        popUpContainer.addSubview(searchController.searchBar)

    }
    

}
