//
//  LoginViewController.swift
//  Eliminator
//
//  Created by Joshua Seger on 11/23/15.
//  Copyright © 2015 Creighton. All rights reserved.
//

import Parse
import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var passwordInput: UITextField!
    @IBOutlet var usernameInput: UITextField!
    
    @IBAction func loginClicked(sender: AnyObject) {
        
        PFUser.logInWithUsernameInBackground(usernameInput.text!, password:passwordInput.text!) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                self.performSegueWithIdentifier("LoggedIn", sender: nil)
                // Do stuff after successful login.
            } else {
                self.displayError("Failed to Login", error: "Invalid credentials were most likely cause")
                // The login failed. Check error to see why.
            }
        }
        
    }
    
    @IBAction func signupClicked(sender: AnyObject) {
        var error = ""
        
        if (usernameInput.text == "" || passwordInput.text == "") {
            error = "Please enter a username or password!"}
        
        else if (error != "") {
            displayError("Error in Form", error: error)
        }
            
        else
        {
            let user = PFUser()
            user.username = usernameInput.text
            user.password = passwordInput.text
            
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                if let error = error {
                    _ = error.userInfo["error"] as? NSString
                    // Show the errorString somewhere and let the user try again.
                    self.displayError("Signup Failed", error: "User already exists or bad connection")
                } else {
                    self.displayError("Signup Successful!", error: "Try logging in now!")
                    // Hooray! Let them use the app now.
                }
            }
        
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func displayError(title:String,error:String)
    {
        let alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {action in
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
