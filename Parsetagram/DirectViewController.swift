//
//  DirectViewController.swift
//  Parsetagram
//
//  Created by Meena Sengottuvelu on 6/23/16.
//  Copyright © 2016 Meena Sengottuvelu. All rights reserved.
//

import UIKit

class DirectViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var turnOnView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        turnOnView.layer.cornerRadius = 5.0;
    }
    
    func revertSelectedIndex() {
        let tVc = tabBarController as! TabBarController;
        let newTabIndex = (appDelegate.currentTabIndex == 2 ? appDelegate.lastTabIndex : appDelegate.currentTabIndex)
        tVc.selectedIndex = newTabIndex;
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        revertSelectedIndex();
        delay(0.1) { () -> () in
            self.revertSelectedIndex();
        }
        
        let actionSheet: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet);
        
        let takePhoto: UIAlertAction = UIAlertAction(title: "Send Photo or Video", style: .Default)
        { action -> Void in
            let vc = UIImagePickerController();
            vc.allowsEditing = true;
            vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            
            self.presentViewController(vc, animated: true, completion: nil);
        }
        actionSheet.addAction(takePhoto)
        
        let fromLibrary: UIAlertAction = UIAlertAction(title: "Send Message", style: .Default) { action -> Void in
            let vc = UIImagePickerController();
            vc.allowsEditing = true;
            vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            self.presentViewController(vc, animated: true, completion: nil);
        }
        actionSheet.addAction(fromLibrary)
        
        let cancelButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel)
        { action -> Void in
            self.dismissViewControllerAnimated(true, completion: nil);
        }
        actionSheet.addAction(cancelButton)
        
        self.presentViewController(actionSheet, animated: true, completion: nil);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
