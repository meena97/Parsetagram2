//
//  User.swift
//  Parsetagram
//
//  Created by Meena Sengottuvelu on 6/22/16.
//  Copyright © 2016 Meena Sengottuvelu. All rights reserved.
//

import UIKit
import Parse

public class User: PFUser {
    
    private var profilePicURLVar: NSURL?;
    var profilePicURL: NSURL? {
        get {
            if(profilePicURLVar == nil) {
                let file = objectForKey("profilePicture") as? PFFile;
                
                let url = Post.getURLFromFile(file!);
                profilePicURLVar = NSURL(string: url);
            }
            return profilePicURLVar;
        }
        set {
            profilePicURLVar = profilePicURL;
        }
    }
    
    var postsCount: Int? {
        let query = PFQuery(className: "Post");
        query.whereKey("author", equalTo: self);
        return query.countObjects(nil);
    }
    
    public func posts(offset: Int = 0, limit: Int = 20, completion: PFQueryArrayResultBlock) -> [Post]? {
        return Post.fetchPosts(offset, limit: limit, authorConstraint: self, completion: completion);
    }
    
    public class func getUserByUsername(username: String) -> User {
        let query = PFUser.query();
        query?.whereKey("username", equalTo: username);
        var result: PFObject?;
        
        do {
            result = try query!.getFirstObject();
        } catch(_) {
            
        }
        
        return result as! User;
    }
    
}
