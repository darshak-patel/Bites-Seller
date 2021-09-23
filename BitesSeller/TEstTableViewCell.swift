//
//  TEstTableViewCell.swift
//  BitesSeller
//
//  Created by Prajval Raval on 03/06/1940 Saka.
//  Copyright © 1940 Prajval Raval. All rights reserved.
//

import UIKit

class TEstTableViewCell: UITableViewCell {
    
    //OUTLETS

    @IBOutlet weak var TestNameLbl: UILabel!
    
    
    @IBOutlet weak var TestCellKey: UILabel!
    @IBOutlet weak var TestCellImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
