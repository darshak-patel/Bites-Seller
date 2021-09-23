//
//  TestTableViewController.swift
//  BitesSeller
//
//  Created by Prajval Raval on 03/06/1940 Saka.
//  Copyright © 1940 Prajval Raval. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class TestTableViewController: UITableViewController {
    
    //DICTIONARY_CREATED_USING_MODEL
    var usersArray = [model]()
    
    @IBAction func ButtonAlphaTB(_ sender: UIButton) {
        
        tableView.alpha = 0.0
        
    }
    
    
    
    @IBAction func presentingTest(_ sender: UIBarButtonItem) {
        
        let vctest = self.storyboard?.instantiateViewController(withIdentifier: "TestImageViewCont") as? TestImageViewController
        present(vctest!, animated: true, completion: nil)
    }
    
    //VIEW_DID_LOAD
    override func viewDidLoad() {
        
        fetchuser()
        
    }
    
    
    //FETCH DATA FROM DATABASE AND APPENT IT TO OUR DICTIONARY.
    func fetchuser(){
        Database.database().reference().child("sellers").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String : AnyObject] {
                let user = model()
                let uids = uidsforcell()
                
                
                print(snapshot)
                
                user.name = dictionary["name"] as? String
                user.email = dictionary["email"] as? String
                user.profileimageurl = dictionary["profileimageurl"] as? String
                user.key = dictionary["key"] as? String
                uids.key = dictionary["key"] as? String
                
                
                
                self.usersArray.append(user)
                self.uidarray.append(uids)
               
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }//dispatchqueue

                
            }//letdictionary
            
        }, withCancel: nil)//Database
    }//fetchuser()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "testcell") as! TEstTableViewCell
        
        let user = usersArray[indexPath.row]
    
        
        cell.TestNameLbl.text = user.name
        cell.TestCellKey.text = user.key
       
        
        return cell
    }
//FOR CELL TO NEW VC
    var uidarray = [uidsforcell]()
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get Cell Label
        
        //let indexPath = tableView.indexPathForSelectedRow!
        //let currentCell = tableView.cellForRow(at: indexPath)! as! TEstTableViewCell
       
        let selectedKey = uidarray[indexPath.row]
        print(selectedKey.key!)
     
       performSegue(withIdentifier: "presentCellVC", sender: indexPath.row)
        
        
    }
    
    
    
//Shake Test
    
    
    
    
    
//Passing The Key
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "presentCellVC"{
        let selectedRow = sender as? Int
        
        let destination = segue.destination as? TestCellVCViewController
        
        if let name = usersArray[selectedRow!].key{
            
            
            print("PRINTING NAME: \(name)")
            
        destination?.uidkey = name
        
            }
        }
    }





}
