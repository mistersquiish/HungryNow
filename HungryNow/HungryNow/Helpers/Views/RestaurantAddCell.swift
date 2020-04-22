//
//  RestaurantAddCell.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/9/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import UIKit

class RestaurantAddCell: UITableViewCell {
    @IBOutlet var thumbImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var ratingImageView: UIImageView!
    @IBOutlet var reviewsCountLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var categoriesLabel: UILabel!
    
    var restaurant: Restaurant! {
        didSet {
            nameLabel.text = restaurant.name
            //thumbImageView.setImageWith(business.imageURL!)
            addressLabel.text = restaurant.address
            //categoriesLabel.text = business.categories
            //reviewsCountLabel.text = "\(business.reviewCount!) Reviews"
            //distanceLabel.text = restaurant.distance
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.thumbImageView.layer.cornerRadius = 10
        self.thumbImageView.clipsToBounds = true
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
