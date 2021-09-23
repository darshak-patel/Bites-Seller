//
//  ItemListTableViewCell.swift
//  BitesSeller
//
//  Created by Prajval Raval on 25/06/1940 Saka.
//  Copyright © 1940 Prajval Raval. All rights reserved.
//

import UIKit

protocol cellbuttonfunctiondelegate{
    
    func buttontapped(at index:IndexPath, cell: ItemListTableViewCell)

}


class ItemListTableViewCell: UITableViewCell {

    @IBOutlet weak var ItemsNameLbl: UILabel!
    
    @IBOutlet weak var ItemsPriceLbl: UILabel!
    
    @IBOutlet weak var AddButton: UIButton!
    
    @IBOutlet weak var itemcategorykeylbl: UILabel!
    
   
    
    
    
    
    @IBOutlet weak var itemkeylbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var delegate:cellbuttonfunctiondelegate?
    var indexPath:IndexPath!
    
    @IBAction func BtnTapped(_ sender: UIButton) {
       
        delegate?.buttontapped(at: indexPath, cell: self)
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
            
        
        
        // Configure the view for the selected state
    }

}
