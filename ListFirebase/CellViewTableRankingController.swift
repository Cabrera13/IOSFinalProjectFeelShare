//
//  CellViewTableRankingController.swift
//  ListFirebase
//
//  Created by ios on 24/05/18.
//  Copyright © 2018 ios. All rights reserved.
//

import UIKit

class CellViewTableRankingController: UITableViewCell {
    

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var score: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
