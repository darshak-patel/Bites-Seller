//
//  OrdersTableViewCell.swift
//  BitesSeller
//
//  Created by Prajval Raval on 26/07/1940 Saka.
//  Copyright © 1940 Prajval Raval. All rights reserved.
//

import UIKit

class OrdersTableViewCell: UITableViewCell {

    @IBOutlet weak var Orderidlbl: UILabel!
    
    @IBOutlet weak var OrdernameLbl: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
