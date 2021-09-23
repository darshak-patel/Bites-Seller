//
//  TestCellVCViewController.swift
//  BitesSeller
//
//  Created by Prajval Raval on 10/06/1940 Saka.
//  Copyright © 1940 Prajval Raval. All rights reserved.
//

import UIKit
import Firebase

class TestCellVCViewController: UIViewController {
    
    
    var usersArray = [model]()
    
    var uidkey:String?
    
    
    
    @IBOutlet weak var TestCellVCkeylbl: UILabel!
    
    
    @IBOutlet weak var TestCellVCnamelbl: UILabel!
    
    
    @IBAction func Dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func observingdata() {
        
        let dbref = Database.database().reference()
        let key = uidkey
        
        dbref.child("sellers").child("\(key ?? "KEY")").observe(.value) { (snap) in
            if let dictionary = snap.value as? [String:AnyObject]{
                
                print(dictionary)
                self.TestCellVCkeylbl.text = dictionary["key"] as? String
                self.TestCellVCnamelbl.text = dictionary["name"] as? String
            }
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(uidkey as Any)
       observingdata()
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
