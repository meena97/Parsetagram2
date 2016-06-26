//
//  ProfileHeaderTableViewCell.swift
//  Parsetagram
//
//  Created by Meena Sengottuvelu on 6/22/16.
//  Copyright © 2016 Meena Sengottuvelu. All rights reserved.
//

import UIKit
import Parse
import AFNetworking

class ProfileHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var profileNameLabel: UILabel!
    @IBOutlet var postsCountLabel: UILabel!
    @IBOutlet var followersCountLabel: UILabel!
    @IBOutlet var followingCountLabel: UILabel!
    @IBOutlet weak var followersTitleLabel: UILabel!
    @IBOutlet weak var followingTitleLabel: UILabel!
    
    @IBOutlet var dividerShadow: UIView!
    
    @IBOutlet var editButton: UIButton!
    
    weak var profileTableViewController: ProfileTableViewController!;
    
    var user: User! {
        didSet {
            profileNameLabel.text = "@\(user.username!)";
            
            if(profileImageView.image == nil) {
                profileImageView.clipsToBounds = true;
                profileImageView.alpha = 0;
                delay(1.0) { () -> () in
                    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        self.profileImageView.alpha = 1;
                    });
                }
                
                profileImageView.setImageWithURL(user.profilePicURL!);
            }
            
            postsCountLabel.text = String(user.postsCount!);
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        editButton.layer.cornerRadius = 5;
        editButton.backgroundColor = UIColor(white: 0.7, alpha: 0.2);
        
        let gradientLayer = CAGradientLayer();
        gradientLayer.frame = dividerShadow.bounds;
        let topColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).CGColor as CGColorRef;
        let bottomColor = UIColor(white: 0, alpha: 0.0).CGColor as CGColorRef;
        gradientLayer.colors = [topColor, bottomColor];
        gradientLayer.locations = [0.0, 1.0];
        self.dividerShadow.layer.addSublayer(gradientLayer);
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ProfileHeaderTableViewCell.onTappedProfilePic));
        profileImageView.userInteractionEnabled = true;
        profileImageView.addGestureRecognizer(tap);
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func onTappedProfilePic() {
        if(user.username == User.currentUser()?.username) {
            profileTableViewController.performSegueWithIdentifier("toProfilePicEditor", sender: self);
        }
    }
    
    
}
