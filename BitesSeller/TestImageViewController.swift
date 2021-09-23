//
//  TestImageViewController.swift
//  BitesSeller
//
//  Created by Prajval Raval on 04/06/1940 Saka.
//  Copyright © 1940 Prajval Raval. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


class TestImageViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
//Shake Test
    
    @IBAction func ShakeBTN(_ sender: UIButton) {
        
        self.passwordtxtfield.shake()
    }
    
    
//OUTLETS
    
    
    @IBOutlet weak var logout: UIButton!
    
    @IBOutlet weak var imageviewpicker: UIImageView!
    
    
    @IBOutlet weak var phonelabel: UILabel!
    
    @IBOutlet weak var emailtxtfield: UITextField!
    
    
    @IBOutlet weak var passwordtxtfield: UITextField!
    
    //SAVE_BTN
    
    @IBAction func savebtn(_ sender: UIButton) {
        handleSignUp()
    }
    
    
    //LOGOUT BUTTON
    @IBAction func logoutact(_ sender: UIButton) {
        
        try! Auth.auth().signOut()
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "login") as! LoginViewController
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    //IMAGE PICKER OUTLET
    var imagepickerobj = UIImagePickerController()
    
    
    @IBAction func SelectImagePicker(_ sender: UITapGestureRecognizer) {
        
        imagepickerobj = UIImagePickerController()
        imagepickerobj.delegate = self
        imagepickerobj.allowsEditing = true
        
        imagepickerobj.sourceType = .savedPhotosAlbum
        
        
        self.present(imagepickerobj, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let img = info[UIImagePickerControllerEditedImage] as! UIImage
        imageviewpicker.image = img
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    //////////////////////TEST REGISTER///////////////////////////////////////
    
    func handleSignUp(){
        
        let email = emailtxtfield.text
        
        let password = passwordtxtfield.text
        
        
        Auth.auth().createUser(withEmail: email!, password: password!) { (user, error) in
            if error != nil{
                
                print(error ?? "No Error")
                return
                
            }
            
            
            //SUCCESSFULLY ENTERED USER
            
            let imageName = NSUUID().uuidString //TO GENERATE A UNIQUE ID
            let storeageref = Storage.storage().reference().child("profile_images_sellers").child("\(imageName).png") //REFERENCE TO OUR STORAGE
            
            if let uploaddata = UIImagePNGRepresentation(self.imageviewpicker.image!){
                
                
                //UPLOADS DATA TO OUR STORAGE
                storeageref.putData(uploaddata, metadata: nil, completion: { (metadata, err) in
                    if error != nil{
                        print(error as Any)
                        return
                    }
                    //GENERATES A DOWNLOAD URL OF THE FILE
                    storeageref.downloadURL(completion: { (url1, err) in
                        if err != nil{
                            print(err!.localizedDescription)
                            return
                        }
                        //SET PROFILEIMAGEURL TO THE DOWNLOAD URL AND SENDS IT AS A KEY TO OUR DATABASE(NOT STORAGE) USING REGISTERTODATABSE() FUNCTION.
                        if let profileImageurl = url1?.absoluteString{
                            let values = ["email": email, "profileimageurl":profileImageurl]
                            
                            self.registertodatabase(values: values as [String : AnyObject])
                            
                            
                            print(metadata as Any)
                        }
                    })
                    
                    
                })

                
            }
            
            
        }
    }
    //SENDS THE DATA TO OUR DATABASE
    private func registertodatabase(values: [String:AnyObject]){
    
        
        let ref = Database.database().reference(fromURL: "https://bites-sellers.firebaseio.com/")
        
        let uid = Auth.auth().currentUser?.uid
        
        let userReferences = ref.child("sellers").child("\(uid ?? "UID")")
        
        
        
        userReferences.updateChildValues(values as Any as! [AnyHashable : Any], withCompletionBlock: { (err, ref) in
            if err != nil {
                
                print(err ?? "No Error in Saving Data")
                return
                
            }
            
            print("Saved User Successfully!")
            
            self.fetchuserandsetname()
        })
        
    }
    
    
    
/////////////////////////////////////////////////////////////////////////////////////////
    
    
//////////////////////TEST PROFILE VIEW//////////////////////////////////////////////////
    
    
    var usersArray = [model]()
    
    func fetchuser(){
        Database.database().reference().child("sellers").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String : AnyObject] {
                let user = model()
                
                //user.setValuesForKeys(dictionary)
                
                user.name = dictionary["name"] as? String
                user.email = dictionary["email"] as? String
                user.profileimageurl = dictionary["profileimageurl"] as? String
                
                self.usersArray.append(user)
                
                
                self.profileImageView.image = UIImage(named: "SignUpImage")
                
                if let profileimageurl = user.profileimageurl{
                    
                    
                    self.profileImageView.loadimagecache(urlstring: profileimageurl)
                    }
               }
            }, withCancel: nil)
    }
    
//OUTLETS
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    @IBOutlet weak var profilenamelbl: UILabel!
    
    
    @IBOutlet weak var profileemaillnl: UILabel!
    

    
//VIEW_DID_LOAD
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkifuserisloggedin()
        fetchuser()
        
        
        self.TestLBL.alpha = 0
        self.imageviewpicker.layer.cornerRadius = imageviewpicker.frame.size.width/2
        
        self.imageviewpicker.clipsToBounds = true
        self.imageviewpicker.layer.borderColor = UIColor.white.cgColor
        
        
        self.imageviewpicker.layer.masksToBounds = false
        
        self.imageviewpicker.contentMode = .scaleAspectFill
        
//        setvalueforphonenumbers()
        testlabel()

        
    }
  
////////////////////////////////////////////////////////////////////////////////
    
    
    
//FETCHING A SINGLE VALUE FROM DATABASE,CHECKING IF USER IS LOGGED IN AND SETTING VALUE TO LABELS.
    
    func checkifuserisloggedin(){
        if Auth.auth().currentUser?.uid == nil{
            perform(#selector(handlelogout), with: nil, afterDelay: 0)
            print("LOGGED OUT")
        }
        else{
            print("USING FETCH AND SETTING USERNAME")
            fetchuserandsetname()
        }
    }
    
    //HANDLING LOGOUT
    @objc func handlelogout() {
        do{
            try Auth.auth().signOut()
        }
        catch let logoutError{
            print(logoutError)
        }
    }
    
    //FETCHING A SINGLE VALUE AND SETTING IT TO THE USER LABELS
    func fetchuserandsetname() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        print("THIS IS UID \(uid)")
        
        Database.database().reference().child("sellers").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                
               self.profilenamelbl.text = dictionary["name"] as? String
                self.profileemaillnl.text = dictionary["email"] as? String
            }
        }
    }
    
//    func setvalueforphonenumbers(){
//
//        //FOR PHONE NUMBER
//        var dbref:DatabaseReference
//       dbref = Database.database().reference()
//       let uid = Auth.auth().currentUser?.uid
//        dbref.child("users/\(uid ?? "UID")/phonenumber").observeSingleEvent(of: .value) { (number) in
//           if let number1 = number.value as? String {
//            self.phonelabel.text = "\(number1)"
//
//            //FOR PROFILE IMAGE
//            dbref.child("storedata").child("\(uid ?? "UID")").observeSingleEvent(of: .value, with: { (snap) in
//                let userinfo = snap.value as? NSDictionary
//                print(userinfo as Any)
//                //let profileUrl = userinfo!["profileimageurl"] as! String
//                //print(profileUrl)
//                //let storageref = Storage.storage().reference(forURL: profileUrl)
//                //storageref.downloadURL(completion: { (url, err) in
//                    //do{
//                       // let data = try Data(contentsOf: url!)
//                    let image = UIImage(data: data)
//                    self.profileImageView   .image = image
//                    self.profileImageView.loadimagecache(urlstring: profileUrl)
//                    }
//                    catch{
//                        print("HEY")
//                    }
//                })
//
//            })
//           }
//
//        }
//    }
   
////////////////////////////////////////////////////////////////////
    
//////////////FUNCTION FOR CROPPED IMAGE PIKER IN CIRCLE/////////////////
    
    @IBOutlet weak var croppedimage: UIImageView!
    
    
    
    
    @IBAction func TapCroppedPicker(_ sender: UITapGestureRecognizer) {
        
//        let originalImage = UIImage(named: "image")
//
//        let imageCropViewController = RSKImageCropViewController(image: originalImage!, cropMode: .custom)
//
//        imageCropViewController.delegate = self
//        imageCropViewController.dataSource = self
//
//        self.navigationController?.pushViewController(imageCropViewController, animated: true)
    }
    
    
    
////////////////////////////////////////////////////////////////////

    
    
    @IBOutlet weak var TestLBL: UILabel!
    
    func testlabel() {
        let testdbref = Database.database().reference()
        testdbref.child("test").observeSingleEvent(of: .value) { (snap) in
            if snap.exists() {
                
                self.TestLBL.alpha = 0
                print(snap)
            }
            else{
                
                self.TestLBL.alpha = 1
                if let testdata = snap.value as? String{
                    self.TestLBL.text = "\(testdata)"
                }
            }
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  }


extension UIView {
    func shake(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        
        self.layer.add(animation, forKey: "position")
    }
}






