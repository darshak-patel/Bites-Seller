//
//  HomeTabViewController.swift
//  BitesSeller
//
//  Created by Prajval Raval on 02/06/1940 Saka.
//  Copyright © 1940 Prajval Raval. All rights reserved.
//

import UIKit
import Firebase

class HomeTabViewController: UIViewController {
    


    @IBOutlet weak var StoreErrLBL: UILabel!
    
    @IBOutlet weak var StoreNameLbl: UILabel!
    @IBOutlet weak var StoreImageView: UIImageView!
    
    @IBOutlet weak var AdressLbl: UILabel!
    @IBOutlet weak var AddressTxtView: UITextView!
    
    @IBOutlet weak var OwnerNameLblStatic: UILabel!
    @IBOutlet weak var OwnerNameLbl: UILabel!
    
    
    @IBOutlet weak var OwnerLabelStatic: UILabel!
    @IBOutlet weak var OwnerNumberLabel: UILabel!
    
    
    func getstoredata() {
        
        let dbref = Database.database().reference()
        
        let uid = Auth.auth().currentUser?.uid
        
        dbref.child("storedata").child("\(uid ?? "UID NOT FOUND")").observe(.value)
        { (snapstore) in
            
            if snapstore.value != nil{
            
            if let infostore = snapstore.value as? [String : AnyObject] {
                
                self.StoreNameLbl.alpha = 1
                
                
                self.StoreNameLbl.text = infostore["storename"] as? String
                
                self.AdressLbl.alpha = 1
                self.AddressTxtView.alpha = 1
                
                self.AddressTxtView.text = infostore["storeaddress"] as? String
              
                self.StoreErrLBL.alpha = 0
                
                
                if let profileimageurl = infostore["profileimageurl"]{
         
                    self.StoreImageView.loadimagecache(urlstring: profileimageurl as! String)
                }
            }
            
            }
            else{
               
            }
        }
    }
    
    
    func getnames()  {
        
        let uid = Auth.auth().currentUser?.uid
        
        let databasenameref = Database.database().reference().child("sellers").child(uid!)
        
        databasenameref.observe(.value) { (snap) in
            
            if let infonames = snap.value as? [String : AnyObject] {
                
                self.OwnerNameLblStatic.alpha = 1
                self.OwnerNumberLabel.alpha = 1
                self.OwnerLabelStatic.alpha = 1
                self.OwnerNameLbl.alpha = 1
            
                self.OwnerNameLbl.text = infonames["name"] as? String
                self.OwnerNumberLabel.text = infonames["phonenumber"] as? String
             
                
            }
        }
        
        
        
    }
    
    
//VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getstoredata()
        getnames()
        
        
        self.StoreNameLbl.alpha = 0
        self.AddressTxtView.alpha = 0
        self.AdressLbl.alpha = 0
        self.OwnerNameLblStatic.alpha = 0
        self.OwnerNameLbl.alpha = 0
        self.OwnerNumberLabel.alpha = 0
        self.OwnerLabelStatic.alpha = 0
        self.StoreImageView.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
