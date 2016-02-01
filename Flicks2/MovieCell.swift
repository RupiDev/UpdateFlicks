//
//  MovieCell.swift
//  Flicks2
//
//  Created by Rupin Bhalla on 1/24/16.
//  Copyright © 2016 Rupin Bhalla. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell
{
    
    @IBOutlet weak var moviePic: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var overview: UILabel!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
