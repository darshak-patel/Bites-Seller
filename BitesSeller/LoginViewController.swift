//
//  LoginViewController.swift
//  BitesSeller
//
//  Created by Prajval Raval on 01/06/1940 Saka.
//  Copyright © 1940 Prajval Raval. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    
    //FUNCTION HANDLER FOR LOGIN
    
    func handleSignIn(){
        guard let emailLI = EmailTXTField.text else {
            print("Please Enter Correct Email")
            return
        }
        guard  let passwordLI = PassWordTXTField.text else {
            print("Please Enter Correct Password")
            return
        }
        
        Auth.auth().signIn(withEmail: emailLI, password: passwordLI) { (user, errorLI) in
            
            if errorLI != nil {
                
                
                let alertactioncontroller4 = UIAlertController(title: "Invalid Login", message: "Please Review Your Login Details", preferredStyle: .alert)
                
                let okaction = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alertactioncontroller4.addAction(okaction)
                
                self.present(alertactioncontroller4, animated: true, completion: nil)
                
                print(errorLI ?? "No Error")
                return
            }
                
            
            else{
                
                let presentview = self.storyboard?.instantiateViewController(withIdentifier: "home")
                
                self.present(presentview!, animated: true, completion: nil)
            }

        }
    }
    
    //LOGIN BTN
    
    @IBOutlet weak var LoginBTN: UIButton!
    
  
    @IBAction func LoginBTN_ACT(_ sender: UIButton) {
        
        handleSignIn()
        
    }
    
    // TEXT FIELDs
    
    
    @IBOutlet weak var EmailTXTField: UITextField!
    
    
    @IBOutlet weak var PassWordTXTField: UITextField!
    
    //TO DISMISS KEYBOARD ON PRESSING RETURN AND ON TAPPING.
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // TAP GESTURE RECOGNIZER
    
    @IBOutlet var TapGestureRecognizerOutlet: UITapGestureRecognizer!
    
    //FORGOT PASSWORD BTN
    
    
    @IBOutlet weak var ForgotPasswordBTN: UIButton!
    
    
    @IBAction func ForgotPasswordBTN_ACT(_ sender: UIButton) {
    }
    
    //SIGN UP BTN
    
    
    @IBOutlet weak var SignUpBTN: UIButton!
    
    @IBAction func SignUpBTN_ACT(_ sender: UIButton) {
        
    }
    
    
    ////VIEW_DID_LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        // TO CHANGE THE CORNER RADIUS OF THE UI OBJECTS.
        
        EmailTXTField.layer.cornerRadius = 15.00
        
        EmailTXTField.clipsToBounds = true
        
        PassWordTXTField.layer.cornerRadius = 15.00
        
        PassWordTXTField.clipsToBounds = true
        
        LoginBTN.layer.cornerRadius = 15.00
        
    LoginBTN.clipsToBounds = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
