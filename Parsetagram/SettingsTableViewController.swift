//
//  SettingsTableViewController.swift
//  Parsetagram
//
//  Created by Meena Sengottuvelu on 6/22/16.
//  Copyright © 2016 Meena Sengottuvelu. All rights reserved.
//

import UIKit
import Parse

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var cellPrivateAccount: UITableViewCell!
    @IBOutlet weak var cellSaveOriginals: UITableViewCell!
    @IBOutlet weak var blogButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func logOut() {
        
        User.logOutInBackground();
        let tabBarController = appDelegate.window?.rootViewController as! TabBarController;
        tabBarController.performSegueWithIdentifier("toLogin", sender: self);
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(tableView.cellForRowAtIndexPath(indexPath)?.reuseIdentifier == "LogOutCell") {
            logOut();
        }
        
        if(tableView.cellForRowAtIndexPath(indexPath)?.reuseIdentifier == "HelpCenter") {
            if let url = NSURL(string: "https://help.instagram.com/"){
                UIApplication.sharedApplication().openURL(url)
            }
        }
        
        if(tableView.cellForRowAtIndexPath(indexPath)?.reuseIdentifier == "Blog") {
            if let url = NSURL(string: "http://blog.instagram.com/"){
                UIApplication.sharedApplication().openURL(url)
            }
        }
        
        if(tableView.cellForRowAtIndexPath(indexPath)?.reuseIdentifier == "PrivacyPolicy") {
            if let url = NSURL(string: "https://www.instagram.com/about/legal/privacy/"){
                UIApplication.sharedApplication().openURL(url)
            }
        }
        
        if(tableView.cellForRowAtIndexPath(indexPath)?.reuseIdentifier == "Terms") {
            if let url = NSURL(string: "https://www.instagram.com/about/legal/terms/"){
                UIApplication.sharedApplication().openURL(url)
            }
        }
        
        if(tableView.cellForRowAtIndexPath(indexPath)?.reuseIdentifier == "OpenSource") {
            if let url = NSURL(string: "https://www.instagram.com/about/legal/libraries/"){
                UIApplication.sharedApplication().openURL(url)
            }
        }
        
        if(tableView.cellForRowAtIndexPath(indexPath)?.reuseIdentifier == "ReportProblem") {
            let actionSheet: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet);
            
            let takePhoto: UIAlertAction = UIAlertAction(title: "Spam or Abuse", style: .Default)
            { action -> Void in
                let vc = UIImagePickerController();
                vc.allowsEditing = true;
                vc.sourceType = UIImagePickerControllerSourceType.Camera;
                //self.presentViewController(vc, animated: true, completion: nil);
            }
            actionSheet.addAction(takePhoto)
            
            let fromLibrary: UIAlertAction = UIAlertAction(title: "Something Isn't Working", style: .Default) { action -> Void in
                let vc = UIImagePickerController();
                vc.allowsEditing = true;
                vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                //self.presentViewController(vc, animated: true, completion: nil);
            }
            actionSheet.addAction(fromLibrary)
            
            let cancelButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel)
            { action -> Void in
                self.dismissViewControllerAnimated(true, completion: nil);
            }
            actionSheet.addAction(cancelButton)
            
            self.presentViewController(actionSheet, animated: true, completion: nil);
        }
        
        //        if(tableView.cellForRowAtIndexPath(indexPath)?.reuseIdentifier == "Ads") {
        //            let tabBarController = appDelegate.window?.rootViewController as! TabBarController;
        //            tabBarController.performSegueWithIdentifier("toAds", sender: self);
        //        }
    }
    
}
