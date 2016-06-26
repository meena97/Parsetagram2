//
//  TabBarController.swift
//  Parsetagram
//
//  Created by Meena Sengottuvelu on 6/22/16.
//  Copyright © 2016 Meena Sengottuvelu. All rights reserved.
//

import UIKit
import Parse

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        UITabBar.appearance().tintColor = UIColor.blackColor()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        
        if(User.currentUser() == nil) {
            self.performSegueWithIdentifier("toLogin", sender: self);
        }
        
        childViewControllers.map { (vc: UIViewController) in
            (vc as! UINavigationController).navigationBar.barTintColor = UIColor.whiteColor();
        }
        
        //        childViewControllers.map { (vc: UIViewController) in
        //            (vc as! UINavigationController).navigationBar.barTintColor = UIColor(white: 0.95, alpha: 0.8);
        //        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        let tabBarController = appDelegate.window?.rootViewController as! TabBarController;
        if(tabBarController.selectedIndex != 2) {
            appDelegate.lastTabIndex = appDelegate.currentTabIndex;
            appDelegate.currentTabIndex = tabBarController.selectedIndex;
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "toLogin") {
            Post.postCache = [:];
            let pNc = childViewControllers.last as! UINavigationController;
            let pVc = pNc.childViewControllers.first as! ProfileTableViewController;
            pVc.user = nil;
            pNc.popToRootViewControllerAnimated(true);
        }
    }
    
}

extension UIImage {
    func makeImageWithColorAndSize(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRectMake(0, 0, size.width, size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}