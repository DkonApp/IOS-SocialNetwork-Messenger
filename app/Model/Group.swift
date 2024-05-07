//
//  Group.swift
//
//  Created by Demyanchuk Dmitry on 02.02.1715
//  Copyright © 2017 qascript@mail.ru All rights reserved.
//s

import UIKit

class Group {
    
    public var photoLoading = false
    
    private var id: Int = 0
    private var state: Int = 0
    private var accountAuthor: Int = 0
    
    private var followersCount: Int = 0
    private var postsCount: Int = 0
    
    private var username: String?
    private var fullname: String?
    private var photoUrl: String?
    
    private var location: String?
    private var webPage: String?
    private var bio: String?
    
    private var verified: Int = 0
    
    private var category: Int = 0
    private var year: Int = 0
    private var month: Int = 0
    private var day: Int = 0
    
    private var allowPosts: Int = 0
    private var allowComments: Int = 0

    private var follow: Bool = false;
    
    init(Response: AnyObject) {
        
        self.setId(id: Int((Response["id"] as? String)!)!)
        self.setState(state: Int((Response["state"] as? String)!)!)
        self.setAccountAuthor(accountAuthor: Int((Response["accountAuthor"] as? String)!)!)
        
        self.setVerified(verified: Int((Response["verify"] as? String)!)!)
        
        self.setCategory(category: Int((Response["accountCategory"] as? String)!)!)
        self.setYear(year: Int((Response["year"] as? String)!)!)
        self.setMonth(month: Int((Response["month"] as? String)!)!)
        self.setDay(day: Int((Response["day"] as? String)!)!)
        
        self.setFullname(fullname: (Response["fullname"] as? String)!)
        self.setUsername(username: (Response["username"] as? String)!)
        self.setPhotoUrl(photoUrl: (Response["lowPhotoUrl"] as? String)!)
        
        self.setLocation(location: (Response["location"] as? String)!)
        self.setWebPage(webPage: (Response["my_page"] as? String)!)
        self.setBio(bio: (Response["status"] as? String)!)

        
        if ((Response["allowComments"] as? String) != nil) {
            
            self.setAllowComments(allowComments: Int((Response["allowComments"] as? String)!)!)
        }
        
        if ((Response["allowPosts"] as? String) != nil) {
            
            self.setAllowPosts(allowPosts: Int((Response["allowPosts"] as? String)!)!)
        }
        
        if ((Response["followersCount"] as? String) != nil) {
            
            self.setFollowersCount(followersCount: Int((Response["followersCount"] as? String)!)!)
        }
        
        if ((Response["postsCount"] as? String) != nil) {
            
            self.setPostsCount(postsCount: Int((Response["postsCount"] as? String)!)!)
        }
        
        
        
        if ((Response["follow"] as? Bool) != nil) {
            
            self.setFollow(follow: (Response["follow"] as? Bool)!)
        }
        
        
        // for new version
        
        // self.setPhotoUrl(photoUrl: (Response["photoUrl"] as? String)!)
        // self.setCoverUrl(coverUrl: (Response["coverUrl"] as? String)!)
        // self.setVerified(verified: Int((Response["verified"] as? String)!)!)
    }
    
    init() {
        
        
    }
    
    public func setFollow(follow: Bool) {
        
        self.follow = follow;
    }
    
    func isFollow() -> Bool {
        
        return self.follow;
    }
    
    public func setPostsCount(postsCount: Int) {
        
        self.postsCount = postsCount;
    }
    
    func getPostsCount() -> Int {
        
        return self.postsCount;
    }
    
    public func setFollowersCount(followersCount: Int) {
        
        self.followersCount = followersCount;
    }
    
    func getFollowersCount() -> Int {
        
        return self.followersCount;
    }
    
    
    
    public func setId(id: Int) {
        
        self.id = id;
    }
    
    func getId() -> Int {
        
        return self.id;
    }
    
    public func setState(state: Int) {
        
        self.state = state;
    }
    
    func getState() -> Int {
        
        return self.state;
    }
    
    public func setAccountAuthor(accountAuthor: Int) {
        
        self.accountAuthor = accountAuthor;
    }
    
    func getAccountAuthor() -> Int {
        
        return self.accountAuthor;
    }
    
    public func setVerified(verified: Int) {
        
        self.verified = verified;
    }
    
    func getVerified() -> Int {
        
        return self.verified;
    }
    
    public func setAllowPosts(allowPosts: Int) {
        
        self.allowPosts = allowPosts;
    }
    
    func getAllowPosts() -> Int {
        
        return self.allowPosts;
    }
    
    public func setAllowComments(allowComments: Int) {
        
        self.allowComments = allowComments;
    }
    
    func getAllowComments() -> Int {
        
        return self.allowComments;
    }
    
    public func setUsername(username: String) {
        
        self.username = username
    }
    
    public func getUsername()->String {
        
        return self.username!
    }
    
    public func setFullname(fullname: String) {
        
        self.fullname = fullname
    }
    
    public func getFullname()->String {
        
        return self.fullname!
    }
    
    public func setPhotoUrl(photoUrl: String) {
        
        self.photoUrl = photoUrl.replacingOccurrences(of: "/../", with: "/")
    }
    
    public func getPhotoUrl()->String {
        
        return self.photoUrl!
    }
    
    public func setLocation(location: String) {
        
        self.location = location
    }
    
    public func getLocation()->String {
        
        return self.location!
    }
    
    public func setWebPage(webPage: String) {
        
        self.webPage = webPage
    }
    
    public func getWebPage()->String {
        
        return self.webPage!
    }
    
    public func setBio(bio: String) {
        
        self.bio = bio
    }
    
    public func getBio()->String {
        
        return self.bio!
    }
    
    
    public func setCategory(category: Int) {
        
        self.category = category;
    }
    
    func getCategory() -> Int {
        
        return self.category;
    }
    
    public func setYear(year: Int) {
        
        self.year = year;
    }
    
    func getYear() -> Int {
        
        return self.year;
    }
    
    public func setMonth(month: Int) {
        
        self.month = month;
    }
    
    func getMonth() -> Int {
        
        return self.month;
    }
    
    public func setDay(day: Int) {
        
        self.day = day;
    }
    
    func getDay() -> Int {
        
        return self.day;
    }
}
