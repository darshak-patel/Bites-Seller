//
//  ProfileViewController.swift
//  BitesSeller
//
//  Created by Prajval Raval on 11/06/1940 Saka.
//  Copyright © 1940 Prajval Raval. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    
    //CREATE A STORE BUTTON
    
    @IBAction func CreateAStore(_ sender: UIButton) {
        let storeview = self.storyboard?.instantiateViewController(withIdentifier: "CreateAStoreForm") as? CreateAStoreViewController
        
        present(storeview!, animated: true, completion: nil)
    }
    
    
    
    @IBOutlet weak var profileimage: UIImageView!
    
    @IBOutlet weak var profilename: UILabel!
    
    
    
    @IBOutlet weak var createastorebtn: UIButton!
    
    func fetchprofiledetails(){
        
        let userid = Auth.auth().currentUser?.uid
        
        
        Database.database().reference().child("sellers").child("\(userid ?? "UID")").observe(.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String : AnyObject] {
                
                
                print("profile dictionary \(dictionary)")
                
                //user.setValuesForKeys(dictionary)
                
                self.profilename.text = dictionary["name"] as? String
                
                
                
                self.profileimage.image = UIImage(named: "SignUpImage")
                
                if let profileimageurl = dictionary["profileimageurl"]{
                    
                    
                    self.profileimage.loadimagecache(urlstring: profileimageurl as! String)
                }
            }
        }, withCancel: nil)
        
    }
    
    
    @IBAction func LogoutBTN(_ sender: UIButton) {
        
        try! Auth.auth().signOut()
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "login") as! LoginViewController
            self.present(vc, animated: true, completion: nil)
        }
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchprofiledetails()
        
        self.profileimage.layer.cornerRadius = profileimage.frame.width/2
        self.profileimage.clipsToBounds = true
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
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
