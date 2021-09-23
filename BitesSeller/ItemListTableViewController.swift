//
//  ItemListTableViewController.swift
//  BitesSeller
//
//  Created by Prajval Raval on 25/06/1940 Saka.
//  Copyright © 1940 Prajval Raval. All rights reserved.
//

import UIKit
import Firebase

class ItemListTableViewController: UITableViewController,cellbuttonfunctiondelegate {
    
   // FUNC FOR UIBUTTON IN CELL
    
    @IBAction func CancelBTn(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    @objc func buttontapped(at index: IndexPath, cell: ItemListTableViewCell) {
        
        
        print(cell.AddButton.tag)
        
         let alertviewcont = UIAlertController.init(title: "ADDED", message: "", preferredStyle: .actionSheet)
        present(alertviewcont, animated: true) {
            self.dismiss(animated: true, completion: nil)
        }
        
        
        let uid = Auth.auth().currentUser?.uid
        
        print(uid!)
        
        let itemid = cell.itemkeylbl.text
        print(itemid!)
        
        let reffinal = Database.database().reference().child("storedata").child(uid!).child("items").child(itemid!)
       
        
        print("This Is Index \(index)")
        
        let itemname = cell.ItemsNameLbl.text
        print(itemname!)
        reffinal.child("itemname").setValue(itemname!)
        
        let itemkey = cell.itemkeylbl.text
        print(itemkey!)
        reffinal.child("itemkey").setValue(itemkey!)
        
        let categorykey = cell.itemcategorykeylbl.text
        print(categorykey!)
        reffinal.child("categorykey").setValue(categorykey!)
        
        let itemprice = cell.ItemsPriceLbl.text
        print(itemprice!)
        reffinal.child("itemprice").setValue(itemprice!)
        
    }
    
    
    var itemarr = [modelforitemslist]()
    var finalarr = [finalarraymodel]()
    var cat001 = [modelforitemslist]()
    var cat002 = [modelforitemslist]()
    var cat003 = [modelforitemslist]()
    var cat004 = [modelforitemslist]()
    var cat005 = [modelforitemslist]()
    
    
    func fetchItemsCategory(){
        Database.database().reference().child("items").observe(.childAdded, with: { (snapshot) in
            
            print("EXAMPLE DICTIONARY \(snapshot)")
            
            if let dictionary = snapshot.value as? [String : AnyObject] {
                
                let items = modelforitemslist()
                
                
                items.categorykey = dictionary["categorykey"] as? String
                items.itemkey = dictionary["itemkey"] as? String
                items.itemname = dictionary["itemname"] as? String
                items.itemprice = dictionary["itemprice"] as? Int
                
                
                if items.categorykey == "0001" {
                    self.cat001.append(items)
                }
                if items.categorykey == "0002" {
                    self.cat002.append(items)
                }
                if items.categorykey == "0003" {
                    self.cat003.append(items)
                }
                if items.categorykey == "0004" {
                    self.cat004.append(items)
                }
                if items.categorykey == "0005" {
                    self.cat005.append(items)
                }
                
                else{
                self.itemarr.append(items)
                }
                
                
            }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    

                }//dispatchqueue
                
                
//            }//letdictionary
            
        }, withCancel: nil)//Database
    }//fetchuser()
    
   
    
   
override func viewDidLoad() {
        super.viewDidLoad()

            fetchItemsCategory()
        
        //NAVIGATION BAR
        
        navigationItem.title = "Add Items"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = UIColor.green
        
        navigationController?.navigationBar.tintColor = UIColor.white
    
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel()
        
        if section == 0 {
            label.text = "Main Course"
            label.backgroundColor  = UIColor.green
            label.textColor = UIColor.white
            label.font = UIFont.boldSystemFont(ofSize: 20)
        }
        if section == 1 {
            label.text = "Snacks"
            label.backgroundColor  = UIColor.green
            label.textColor = UIColor.white
            label.font = UIFont.boldSystemFont(ofSize: 20)
        }
        if section == 2 {
            label.text = "Ice-Creams"
            label.backgroundColor  = UIColor.green
            label.textColor = UIColor.white
            label.font = UIFont.boldSystemFont(ofSize: 20)
        }
        if section == 3 {
            label.text = "Sandwiches"
            label.backgroundColor  = UIColor.green
            label.textColor = UIColor.white
            label.font = UIFont.boldSystemFont(ofSize: 20)
        }
        if section == 4 {
            label.text = "Refreshments"
            label.backgroundColor  = UIColor.green
            label.textColor = UIColor.white
            label.font = UIFont.boldSystemFont(ofSize: 20)
        }
        
        
        
        return label
    }
    
    
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return itemarr.count
        if section == 0 {
        return cat001.count
        }
        if section == 1{
            return cat002.count
        }
        if section == 2 {
            return cat003.count
        }
        if section == 3 {
            return cat004.count
        }
        if section == 4 {
            return cat005.count
        }
        
        
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemsCell") as! ItemListTableViewCell
        
        if indexPath.section == 0 {
    
        
        let item = cat001[indexPath.row]
        
        cell.ItemsNameLbl.text = item.itemname
        cell.ItemsPriceLbl.text = "\(String(describing: item.itemprice!))"
        cell.itemcategorykeylbl.text
            = item.categorykey
        cell.itemkeylbl.text = item.itemkey
            
        
            
        }
        if indexPath.section == 1{
            
            let item = cat002[indexPath.row]
            
            cell.ItemsNameLbl.text = item.itemname
            cell.ItemsPriceLbl.text = "\(String(describing: item.itemprice!))"
            cell.itemcategorykeylbl.text
                = item.categorykey
            cell.itemkeylbl.text = item.itemkey
        }
        if indexPath.section == 2 {
            
            
            let item = cat003[indexPath.row]
            
            cell.ItemsNameLbl.text = item.itemname
            cell.ItemsPriceLbl.text = "\(String(describing: item.itemprice!))"
            cell.itemcategorykeylbl.text
                = item.categorykey
            cell.itemkeylbl.text = item.itemkey
        }
        if indexPath.section == 3{
            
            let item = cat004[indexPath.row]
            
            cell.ItemsNameLbl.text = item.itemname
            cell.ItemsPriceLbl.text = "\(String(describing: item.itemprice!))"
            cell.itemcategorykeylbl.text
                = item.categorykey
            cell.itemkeylbl.text = item.itemkey
        }
        if indexPath.section == 4 {
            
            
            let item = cat005[indexPath.row]
            
            cell.ItemsNameLbl.text = item.itemname
            cell.ItemsPriceLbl.text = "\(String(describing: item.itemprice!))"
            cell.itemcategorykeylbl.text
                = item.categorykey
            cell.itemkeylbl.text = item.itemkey
            
        }
        
        
        cell.delegate = self
        cell.indexPath = indexPath
        cell.AddButton.tag = Int(arc4random())
        
        
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
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
