//
//  SignUpViewController.swift
//  BitesSeller
//
//  Created by Prajval Raval on 01/06/1940 Saka.
//  Copyright © 1940 Prajval Raval. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import CropViewController
import SVProgressHUD


class SignUpViewController: UIViewController,UITextFieldDelegate,CropViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
//CROP
    
    
    @IBOutlet weak var profilepic: UIImageView!
    private var image: UIImage?
    private var croppingStyle = CropViewCroppingStyle.circular
     var croppedRect = CGRect.zero
    private var croppedAngle = 0
    
    
    @IBAction func profilepickertap(_ sender: UITapGestureRecognizer) {
        
        self.croppingStyle = .circular
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
     
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = (info[UIImagePickerControllerOriginalImage] as? UIImage) else { return }
        let cropController = CropViewController(croppingStyle: croppingStyle, image: image)
        cropController.delegate = self
        self.image = image
        if croppingStyle == .circular {
            if picker.sourceType == .camera {
                picker.dismiss(animated: true, completion: {
                    self.present(cropController, animated: true, completion: nil)
                })
            } else {
                picker.pushViewController(cropController, animated: true)
            }
        }
        else { //otherwise dismiss, and then present from the main controller
            picker.dismiss(animated: true, completion: {
                self.present(cropController, animated: true, completion: nil)
                //self.navigationController!.pushViewController(cropController, animated: true)
            })
        }
    }
    
    
    
    
    
    func presentCropViewController() {
        let image: UIImage = profilepic.image!  //Load an image
        
        let cropViewController = CropViewController.init(croppingStyle: .circular, image: image)
        
        cropViewController.delegate = self
        present(cropViewController, animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        // 'image' is the newly cropped version of the original image
        
        self.croppedRect = CGRect.zero
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
        
        //self.profilepic.image = image
        //dismiss(animated: true, completion: nil)
    }
    public func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
        self.profilepic.image = image
        //layoutImageView()
        self.profilepic.isHidden = false
        cropViewController.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    
    
    //TEXTFIELDs
    
    
    @IBOutlet weak var NameTXTField: UITextField!
    
    
    @IBOutlet weak var EmailTXTField2: UITextField!
    
    
    @IBOutlet weak var PhoneTXTField: UITextField!
    
    
    @IBOutlet weak var PassWordTXTField2: UITextField!
    
    
    @IBOutlet weak var ConfirmPassWordTXTField: UITextField!
    
    //DISMISSING TEXTFIELDS
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //SIGN UP BTN
    
    
    @IBOutlet weak var SignUpBTN2: UIButton!
    
    //REGISTERING USER INTO OUR DATABASE
    func handleSignUp(){
        
        guard let name = NameTXTField.text else {
            print("ENTER NAME CORRECTLY")
            return
        }
        
        guard let email = EmailTXTField2.text else {
            print("ENTER EMAIL CORRECTLY")
            return
        }
        
        guard let phone = PhoneTXTField.text else {
            print("ENTER PHONE NUMBER")
            return
        }
        
        guard let password = PassWordTXTField2.text else {
            print("ENTER PASSWORD CORRECTLY")
            return
        }
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            let myUserID = Auth.auth().currentUser?.uid
            
            print("THIS IS MYUSERID \(String(describing: myUserID))")

            if error != nil{
                
                print(error ?? "No Error")
                
                
                return
                
            }
            
            
            
            
            
            
            //SUCCESSFULLY ENTERED USER
           

            let userid = Auth.auth().currentUser?.uid
            
            let imagename = NSUUID().uuidString
            let storeageref = Storage.storage().reference().child("profile_images_sellers").child("\(imagename).jpg")
            
            if let profileimage = self.profilepic.image, let uploaddata = UIImageJPEGRepresentation(profileimage, 0.4){
            
//            if let uploaddata = UIImagePNGRepresentation(self.profilepic.image!){
                
                storeageref.putData(uploaddata, metadata: nil, completion: { (metadata, err) in
                    if error != nil{
                        print(error as Any)
                        return
                    }
                    storeageref.downloadURL(completion: { (url1, err) in
                        if err != nil{
                            print(err!.localizedDescription)
                            return
                        }
                        if let profileImageurl = url1?.absoluteString{
                            let values = ["name": name, "email": email, "phonenumber": phone,"key":userid!,"profileimageurl":profileImageurl]
                            
                            self.registertodatabase(values: values as [String : AnyObject])
                            
                            
                            print(metadata as Any)
                        
                        }//profileimageurl
                    
                    })//downloadurl
                
            })//putdata
            
            
            } //uploaddata
            
            
            
            
            
            
           
        }
    }
    
    
    private func registertodatabase(values: [String:AnyObject]){
        
        let ref = Database.database().reference(fromURL: "https://bites-sellers.firebaseio.com/")
        
        let userid = Auth.auth().currentUser?.uid
        
        let userReferences = ref.child("sellers").child(userid!)
        
        userReferences.updateChildValues(values as Any as! [AnyHashable : Any], withCompletionBlock: { (err, ref) in
            if err != nil {
                
                print(err ?? "No Error in Saving Data")
                return
                
            }
            
//PROGRESSHUB
            SVProgressHUD.dismiss()
            
            let mainvc = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            
            let alertcontroller = UIAlertController(title: "Registration Success", message: "User Created Successfully", preferredStyle: .alert)
            
            let okaction = UIAlertAction(title: "OK", style: .default, handler: { (presenting) in
                
                self.present(mainvc!, animated: true, completion: nil)
            })
            alertcontroller.addAction(okaction)
            
            self.present(alertcontroller, animated: true, completion: nil)
            
            print("Saved User Successfully!")
            
        })
        
    }
    
    
    @IBAction func SignUpBTN_ACT2(_ sender: UIButton) {
        
        
    
        
        
        
        if (PassWordTXTField2.text?.count)! < 6{
            let alertactioncontroller1 = UIAlertController(title: "Password Invalid", message: "Please Enter A Minimum 6 Character Password", preferredStyle: .alert)
            
            let okaction1 = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertactioncontroller1.addAction(okaction1)
            
            self.present(alertactioncontroller1, animated: true, completion: nil)
        }
        
        
        if ConfirmPassWordTXTField.text != PassWordTXTField2.text{
            
            let alertcontroller2 = UIAlertController(title: "Passwords Do Not Match", message: "Please Re-Enter Password", preferredStyle: .alert)
            
            let okaction2 = UIAlertAction(title: "OK", style: .default)
            
            alertcontroller2.addAction(okaction2)
            
            self.present(alertcontroller2, animated: true, completion: nil)
            
            
            
        }
        
        else{
            SVProgressHUD.show()
            handleSignUp()
        }
    
    }
    
    
    //LOG IN BTN
    
    
    @IBOutlet weak var LoginBTN2: UIButton!
    
    
    @IBAction func LoginBTN_ACT2(_ sender: UIButton) {
      
        if (self.presentingViewController != nil){
            dismiss(animated: true, completion: nil)
       }
        
    }
    
    ///VIEW_DID_LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TO CHANGE THE CORNER RADIUS OF THE UI ELEMENTS
        
        NameTXTField.layer.cornerRadius = 15.00
        
        NameTXTField.clipsToBounds = true
        
        EmailTXTField2.layer.cornerRadius = 15.00
        
        EmailTXTField2.clipsToBounds = true
        
        PhoneTXTField.layer.cornerRadius = 15.00
        
        PhoneTXTField.clipsToBounds = true
        
        PassWordTXTField2.layer.cornerRadius = 15.00
        
        PassWordTXTField2.clipsToBounds = true
        
        ConfirmPassWordTXTField.layer.cornerRadius = 15.00
        
        ConfirmPassWordTXTField.clipsToBounds = true
        
        SignUpBTN2.layer.cornerRadius = 15.00
        
        SignUpBTN2.clipsToBounds = true
        
    
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
