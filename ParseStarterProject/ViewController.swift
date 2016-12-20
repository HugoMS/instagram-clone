/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {
    //MARK: Properties
    var signupMode = true
    var activityIndicator = UIActivityIndicatorView()
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var signupOrLogin: UIButton!
    @IBOutlet weak var changeSignupModeButton: UIButton!
    @IBOutlet weak var messagesLabel: UILabel!
    
    func createAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message , preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Actions
    @IBAction func singupOrLogin(_ sender: AnyObject) {
        
        if emailTextField.text == "" || passTextField.text == "" {
            
            createAlert(title: "Error in form", message: "Please enter an email and password")
           
        } else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            self.activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            if signupMode{
            
                //Sign Up
                let user  = PFUser()
                
                user.username = emailTextField.text
                user.email = emailTextField.text
                user.password = passTextField.text
                
                user.signUpInBackground(block: { (success, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if error != nil {
                       var displayErrorMessages = "Please try again later"
                        
                        if  let errorMessages = (error! as NSError).userInfo["error"] as?  String{
                        
                            displayErrorMessages = errorMessages
                            
                        }
                        
                         self.createAlert(title: "Error in form", message: displayErrorMessages)
                    
                    }else {
                    
                        print("User Sign Up")
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                    }
                })
                
                
            } else {
            
            //Log In Mode
                
                PFUser.logInWithUsername(inBackground: emailTextField.text!, password: passTextField.text!, block: { (user, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if error != nil {
                        
                        var displayErrorMessages = "Please try again later"
                        
                        if  let errorMessages = (error! as NSError).userInfo["error"] as?  String{
                            
                            displayErrorMessages = errorMessages
                            
                        }
                        
                        self.createAlert(title: "Login Error", message: displayErrorMessages)
                        
                    
                    } else {
                    
                        print("Log In")
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                    }
                })
            }
            
            
            
        
        }
        
    }
    @IBAction func changeSingupMode(_ sender: AnyObject) {
        
        if signupMode {
        
            //Change  to log in mode
            signupOrLogin.setTitle("Log In", for: [])
            
            changeSignupModeButton.setTitle("Sign Up", for: [])
            
            messagesLabel.text = "Don't have an account?"
            
            signupMode =  false
        } else {
            // Change to sign up mode
            
            signupOrLogin.setTitle("Sign Up", for: [])
            
            changeSignupModeButton.setTitle("Log In", for: [])
            
            
            messagesLabel.text = "Already have an account?"
            
            signupMode = true

        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        if PFUser.current() != nil {
            
            performSegue(withIdentifier: "showUserTable", sender: self)
        }
        
        self.navigationController?.navigationBar.isHidden =  true
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
