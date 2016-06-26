//
//  SearchScreenViewController.swift
//  Parsetagram
//
//  Created by Meena Sengottuvelu on 6/23/16.
//  Copyright © 2016 Meena Sengottuvelu. All rights reserved.
//

import UIKit

class SearchScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let logoImage = UIImage(named: "insta")!
        let imageView = UIImageView(image: logoImage);
        imageView.frame.size.height = (navigationController?.navigationBar.frame.size.height)! - 10;
        imageView.contentMode = .ScaleAspectFit;
        navigationItem.titleView = imageView;
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
