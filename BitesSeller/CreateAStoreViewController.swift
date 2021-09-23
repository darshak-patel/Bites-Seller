//
//  CreateAStoreViewController.swift
//  BitesSeller
//
//  Created by Prajval Raval on 07/06/1940 Saka.
//  Copyright © 1940 Prajval Raval. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class CreateAStoreViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
//UIIMAGEVIEW AND PICKER
    
    
    @IBOutlet weak var StoreImage: UIImageView!
    
    var CSFimagepicker = UIImagePickerController()
    
    
    

    @IBAction func TapGestForUploadImage(_ sender: UITapGestureRecognizer) {
    
        CSFimagepicker = UIImagePickerController()
        CSFimagepicker.delegate = self
        CSFimagepicker.allowsEditing = true
        CSFimagepicker.sourceType = .photoLibrary
        
        self.present(CSFimagepicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let csfimage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        StoreImage.image = csfimage
        
        self.dismiss(animated: true, completion: nil)
    }
    
//TextFieldOutlets
    
    @IBOutlet weak var CSFstorename: UITextField!
    
    @IBOutlet weak var CSFaddress: UITextField!
    
    @IBOutlet weak var CSFarea: UITextField!
    
    @IBOutlet weak var CSFcity: UITextField!
    
    @IBOutlet weak var CSFpincode: UITextField!
 
    @IBOutlet weak var CSFsubmit: UIButton!
    
    @IBOutlet weak var CSFcancel: UIButton!
    
    @IBOutlet weak var CSFstate: UITextField!
    
    @IBOutlet weak var CSFcategories: UITextField!
    
    @IBAction func SubmitStoreData(_ sender: UIButton) {
        
        SVProgressHUD.show()
        
        let storename = CSFstorename.text
        let storeaddress = CSFaddress.text
        let storearea = CSFarea.text
        let storecity = CSFcity.text
        let storepincode = CSFpincode.text
        let storestate = CSFstate.text
        let storecategories = CSFcategories.text
        let storekey = Auth.auth().currentUser?.uid
        
        let dbref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        
        let CSFimagename = NSUUID().uuidString
        let StorageREF = Storage.storage().reference().child("store_images").child("\(CSFimagename).jpg")
        if let profilepic = self.StoreImage.image, let uploadphotoforstore = UIImageJPEGRepresentation(profilepic, 0.1){
            StorageREF.putData(uploadphotoforstore, metadata: nil) { (metadata, err) in
                if err != nil{
                    print(err as Any)
                    return
                }
                
                StorageREF.downloadURL(completion: { (url, errurl) in
                    if errurl != nil{
                        print(err!.localizedDescription)
                        return
                    }
                    if let profileimageurl = url?.absoluteString{
                        dbref.child("storedata").child("\(uid ?? "UID")").setValue(["storename": storename,"storeaddress":storeaddress,"storearea":storearea,"storecity":storecity,"storepincode":storepincode,"profileimageurl":profileimageurl,"storestate":storestate,"storecategories":storecategories,"key":storekey])
                        
                        print(metadata as Any)
                        
                        SVProgressHUD.dismiss()
                        
                        let alertcont = UIAlertController(title: "Store Registered", message: "Created Store Successfully", preferredStyle: .alert)
                        
                        let okaction = UIAlertAction(title: "OK", style: .default, handler: { (dismiss) in
                            self.dismiss(animated: true, completion: nil
                            )
                        })
                        
                        alertcont.addAction(okaction)
                        
                        self.present(alertcont, animated: true, completion: nil)
                        
                    }
                })
                
            }
        }
        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func CancelBTN(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //TextFieldProp
        self.CSFstorename.layer.cornerRadius = 15.00
        self.CSFstorename.clipsToBounds = true
        self.CSFaddress.layer.cornerRadius = 15.00
        self.CSFaddress.clipsToBounds = true
        self.CSFarea.layer.cornerRadius = 15.0
        self.CSFarea.clipsToBounds = true
        self.CSFcity.layer.cornerRadius = 15.00
        self.CSFcity.clipsToBounds = true
        self.CSFpincode.layer.cornerRadius = 15.00
        self.CSFpincode.clipsToBounds = true
        self.CSFstate.layer.cornerRadius = 15.0
        self.CSFstate.clipsToBounds = true
        self.CSFcategories.layer.cornerRadius = 15.0
        self.CSFcategories.clipsToBounds = true
        //Buttons
        
        self.CSFsubmit.layer.cornerRadius = 15.0
        self.CSFsubmit.clipsToBounds = true
        self.CSFcancel.layer.cornerRadius = 15.0
        self.CSFcancel.clipsToBounds = true
        
        //IMAGEVIEWPROP..
        
        self.StoreImage.layer.borderColor = UIColor.black.cgColor
        self.StoreImage.layer.borderWidth = 2

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
