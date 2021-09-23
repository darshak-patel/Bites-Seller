//
//  ordervcViewController.swift
//  BitesSeller
//
//  Created by Prajval Raval on 30/07/1940 Saka.
//  Copyright © 1940 Prajval Raval. All rights reserved.
//

import UIKit
import Firebase

class ordervcViewController: UIViewController {
    
    
    @IBAction func BackBtnOrd(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
   
    
    @IBOutlet weak var orderusernamelbl: UILabel!
    
    
    @IBOutlet weak var orderaddlbl: UILabel!
    
    @IBOutlet weak var orderphonelbl: UILabel!
    
    
    
    var orderarr = [ordermodel]()
    
    func tbbdiewdata() {
        
        let uid = Auth.auth().currentUser?.uid
        
        let dbref = Database.database().reference().child("storedata").child(uid!).child("orders")
        
        
        
        
        
        dbref.observe(.childAdded) { (snap) in
            print(snap)
            
            if let cartdict = snap.value as? [String:AnyObject]{
                
                
                let item = ordermodel()
                
                
                item.orderuserid = cartdict["userid"] as? String
                item.username = cartdict["username"] as? String
                item.userphone = cartdict["userphone"] as? String
                
                item.address = cartdict["address"] as? String
                
                
                self.orderusernamelbl.text = cartdict["username"] as? String
                
                self.orderaddlbl.text = cartdict["address"] as? String
                
                self.orderphonelbl.text = cartdict["userphone"] as? String
                
                
                
                self.orderarr.append(item)
                
                
                
                
                
            }
            
            
            
            
            
            
        }
        
        
    }

    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tbbdiewdata()
        
        navigationItem.title = "Orders"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = UIColor.green
        
        navigationController?.navigationBar.tintColor = UIColor.white

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
