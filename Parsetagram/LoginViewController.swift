//
//  LoginViewController.swift
//  Parsetagram
//
//  Created by Meena Sengottuvelu on 6/22/16.
//  Copyright © 2016 Meena Sengottuvelu. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var usernameFieldBackgroundView: UIView!
    @IBOutlet var passwordFieldBackgroundView: UIView!
    @IBOutlet var loginButtonSuperview: UIView!
    @IBOutlet var signupButtonSuperview: UIView!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet weak var otherInfoBackgroundView: UIView!
    
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    
    var canLogin = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        usernameField.delegate = self;
        passwordField.delegate = self;
        
        usernameField.attributedPlaceholder = NSAttributedString(string:"Username",
                                                                 attributes:[NSForegroundColorAttributeName: UIColor(white: 1, alpha: 0.7)]);
        passwordField.attributedPlaceholder = NSAttributedString(string:"Password",
                                                                 attributes:[NSForegroundColorAttributeName: UIColor(white: 1, alpha: 0.7)]);
        
        usernameFieldBackgroundView.layer.cornerRadius = 5.0;
        passwordFieldBackgroundView.layer.cornerRadius = 5.0;
        loginButtonSuperview.layer.cornerRadius = 5.0;
        loginButtonSuperview.layer.borderWidth = 2;
        loginButtonSuperview.layer.borderColor = UIColor(white: 1, alpha: 0.15).CGColor;
        
        usernameField.addTarget(self, action: #selector(LoginViewController.textFieldDidChange), forControlEvents: UIControlEvents.EditingChanged);
        passwordField.addTarget(self, action: #selector(LoginViewController.textFieldDidChange), forControlEvents: UIControlEvents.EditingChanged);
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        
        let tabBarController = appDelegate.window?.rootViewController as! TabBarController;
        tabBarController.view.alpha = 1.0;
        
        self.usernameFieldBackgroundView.alpha = 1;
        self.passwordFieldBackgroundView.alpha = 1;
        self.loginButtonSuperview.alpha = 1;
        self.signupButtonSuperview.alpha = 1;
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignIn(sender: AnyObject) {
        if(canLogin != true) {
            return;
        }
        login();
        loginButton.setTitle("", forState: .Normal);
        
        User.logInWithUsernameInBackground(usernameField.text!, password: passwordField.text!) { (user: PFUser?, error: NSError?) -> Void in
            if(error != nil) {
                self.doNotLogin();
                
            } else {
                self.dismissViewControllerAnimated(true, completion: nil);
            }
        }
    }
    
    @IBAction func onSignUp(sender: AnyObject) {
        
        self.usernameFieldBackgroundView.alpha = 0;
        self.passwordFieldBackgroundView.alpha = 0;
        self.loginButtonSuperview.alpha = 0;
        self.signupButtonSuperview.alpha = 0;
        
        self.performSegueWithIdentifier("toSignup", sender: self);
        
    }
    
    func doNotLogin() {
        allowLogin();
        activityIndicatorView.alpha = 0;
        activityIndicatorView.stopAnimating();
        loginButton.setTitle("Login", forState: .Normal);
    }
    
    func login() {
        disallowLogin();
        loginButton.setTitle("", forState: .Normal);
        activityIndicatorView.startAnimating();
        activityIndicatorView.alpha = 1;
        
    }
    
    func allowLogin() {
        canLogin = true;
        loginButton.setTitleColor(UIColor(white: 1, alpha: 1), forState: .Normal);
        loginButton.userInteractionEnabled = true;
    }
    
    func disallowLogin() {
        canLogin = false;
        loginButton.setTitleColor(UIColor(white: 1, alpha: 0.4), forState: .Normal);
        loginButton.userInteractionEnabled = false;
    }
    
    func textFieldDidChange() {
        if(usernameField.text?.characters.count > 0) {
            if(passwordField.text?.characters.count > 0) {
                allowLogin();
                return;
            }
        }
        disallowLogin();
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true);
        return false;
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
