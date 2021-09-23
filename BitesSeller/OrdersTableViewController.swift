//
//  OrdersTableViewController.swift
//  BitesSeller
//
//  Created by Prajval Raval on 26/07/1940 Saka.
//  Copyright © 1940 Prajval Raval. All rights reserved.
//

import UIKit
import Firebase

class OrdersTableViewController: UITableViewController {
    
    var orderarr = [ordermodel]()
    
    func tbbiewdata() {
        
        let uid = Auth.auth().currentUser?.uid
        
        let dbref = Database.database().reference().child("storedata").child(uid!).child("orders")
        
        
        
        
        
        dbref.observe(.childAdded) { (snap) in
            print(snap)
            
            if let cartdict = snap.value as? [String:AnyObject]{
                
                
                let item = ordermodel()
                
                
                item.orderuserid = cartdict["userid"] as? String
                item.username = cartdict["username"] as? String
                
                
                
                self.orderarr.append(item)
                
                
            }
            
            
            DispatchQueue.main.async
                {
                    self.tableView.reloadData()
            }
            
            
            
        }
        
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tbbiewdata()
        
        
        navigationItem.title = "Orders"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = UIColor.green
        
        navigationController?.navigationBar.tintColor = UIColor.white

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orderarr.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell") as? OrdersTableViewCell
        
        let itemor = orderarr[indexPath.row]
        
        cell?.Orderidlbl.text = itemor.orderuserid
        cell?.OrdernameLbl.text = itemor.username
        

        // Configure the cell...

        return cell!
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        
        
        
        let itemor = orderarr[indexPath.row]
        
        let uidop = itemor.orderuserid
        
        
        let dbrefmisc = Database.database().reference().child("misc")
        
        
        dbrefmisc.child("orderid").setValue(uidop!)
        
        
        let ordervc = self.storyboard?.instantiateViewController(withIdentifier: "ordervc") as? ordervcViewController
        
        present(ordervc!, animated: true, completion: nil)
        
        
        
        
        
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
