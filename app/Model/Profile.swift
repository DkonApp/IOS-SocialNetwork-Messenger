//
//  Profile.swift
//
//  Created by Demyanchuk Dmitry on 02.01.1715
//  Copyright © 2017 qascript@mail.ru All rights reserved.
//s

import UIKit

class Profile {
    
    public var photoLoading = false
    
    private var id: Int = 0
    private var state: Int = 0
    private var type: Int = 0
    
    private var friendsCount: Int = 0
    private var followersCount: Int = 0
    private var postsCount: Int = 0
    private var galleryItemsCount: Int = 0
    private var likesCount: Int = 0
    private var giftsCount: Int = 0
    
    private var sex: Int = 0
    
    private var distance: Double = 0.0
    
    private var username: String?
    private var fullname: String?
    private var photoUrl: String?
    private var coverUrl: String?
    
    private var location: String?
    private var facebookPage: String?
    private var instagramPage: String?
    
    private var verified: Int = 0
    
    private var allowMessages: Int = 0
    private var allowGalleryComments: Int = 0
    
    private var allowShowMyGifts: Int = 0;
    private var allowShowMyFriends: Int = 0;
    private var allowShowMyVideos: Int = 0;
    private var allowShowMyInfo: Int = 0;
    private var allowShowMyGallery: Int = 0;
    
    private var blocked: Bool = false;
    private var myLike: Bool = false;
    private var follow: Bool = false;
    private var inBlackList: Bool = false;
    private var follower: Bool = false;
    private var friend: Bool = false;
    
    private var authorizeTimeAgo: String?
    
    private var online: Bool = false;
    
    init(Response: AnyObject) {
        
        self.setId(id: Int((Response["id"] as? String)!)!)
        self.setState(state: Int((Response["state"] as? String)!)!)
        self.setType(type: Int((Response["accountType"] as? String)!)!)
        
        self.setVerified(verified: Int((Response["verify"] as? String)!)!)
    
        self.setSex(sex: Int((Response["sex"] as? String)!)!)
        
        self.setAllowMessages(allowMessages: Int((Response["allowMessages"] as? String)!)!)
        
        self.setAllowShowMyGallery(allowShowMyGallery: Int((Response["allowShowMyGallery"] as? String)!)!)
        self.setAllowShowMyGifts(allowShowMyGifts: Int((Response["allowShowMyGifts"] as? String)!)!)
        self.setAllowShowMyFriends(allowShowMyFriends: Int((Response["allowShowMyFriends"] as? String)!)!)
        self.setAllowShowMyVideos(allowShowMyVideos: Int((Response["allowShowMyVideos"] as? String)!)!)
        self.setAllowShowMyInfo(allowShowMyInfo: Int((Response["allowShowMyInfo"] as? String)!)!)
        
        self.setFullname(fullname: (Response["fullname"] as? String)!)
        self.setUsername(username: (Response["username"] as? String)!)
        self.setPhotoUrl(photoUrl: (Response["lowPhotoUrl"] as? String)!)
        self.setCoverUrl(coverUrl: (Response["normalCoverUrl"] as? String)!)
        
        self.setLocation(location: (Response["location"] as? String)!)
        self.setFacebookPage(facebookPage: (Response["fb_page"] as? String)!)
        self.setInstagramPage(instagramPage: (Response["instagram_page"] as? String)!)
    
        
        if ((Response["distance"] as? Double) != nil) {
            
            self.setDistance(distance: Double((Response["distance"] as? Double)!))
        }
        
        if ((Response["allowGalleryComments"] as? Int) != nil) {
            
            self.setAllowGalleryComments(allowGalleryComments: Int((Response["allowGalleryComments"] as? String)!)!)
        }
        
        if let allowGalleryComments = Response["allowGalleryComments"] as? String {
            
            self.setAllowGalleryComments(allowGalleryComments: Int((allowGalleryComments) )!)
            
        } else {
            
            self.setAllowGalleryComments(allowGalleryComments: Response["allowGalleryComments"] as! Int)
        }
        
        if ((Response["giftsCount"] as? String) != nil) {
            
            self.setGiftsCount(giftsCount: Int((Response["giftsCount"] as? String)!)!)
        }
        
        if ((Response["likesCount"] as? String) != nil) {
            
            self.setLikesCount(likesCount: Int((Response["likesCount"] as? String)!)!)
        }
        
        if ((Response["galleryItemsCount"] as? String) != nil) {
            
            self.setGalleryItemsCount(galleryItemsCount: Int((Response["galleryItemsCount"] as? String)!)!)
        }
        
        if ((Response["followersCount"] as? String) != nil) {
            
            self.setFollowersCount(followersCount: Int((Response["followersCount"] as? String)!)!)
        }
        
        if ((Response["postsCount"] as? String) != nil) {
            
            self.setPostsCount(postsCount: Int((Response["postsCount"] as? String)!)!)
        }
        
        if ((Response["friendsCount"] as? String) != nil) {
            
            self.setFriendsCount(friendsCount: Int((Response["friendsCount"] as? String)!)!)
        }
        
        
        
        if ((Response["blocked"] as? Bool) != nil) {
            
            self.setBlocked(blocked: (Response["blocked"] as? Bool)!)
        }
        
        if ((Response["myLike"] as? Bool) != nil) {
            
            self.setMyLike(myLike: (Response["myLike"] as? Bool)!)
        }
        
        if ((Response["follow"] as? Bool) != nil) {
            
            self.setFollow(follow: (Response["follow"] as? Bool)!)
        }
        
        if ((Response["follower"] as? Bool) != nil) {
            
            self.setFollower(follower: (Response["follower"] as? Bool)!)
        }
        
        if ((Response["friend"] as? Bool) != nil) {
            
            self.setFriend(friend: (Response["friend"] as? Bool)!)
        }
        
        if ((Response["inBlackList"] as? Bool) != nil) {
            
            self.setInBlackList(inBlackList: (Response["inBlackList"] as? Bool)!)
        }
        
        
        
        if ((Response["online"] as? Bool) != nil) {
            
            self.setOnline(online: (Response["online"] as? Bool)!)
        }
        
        self.setAuthorizeTimeAgo(authorizeTimeAgo: (Response["lastAuthorizeTimeAgo"] as? String)!)
        
        // for new version
        
        // self.setPhotoUrl(photoUrl: (Response["photoUrl"] as? String)!)
        // self.setCoverUrl(coverUrl: (Response["coverUrl"] as? String)!)
        // self.setVerified(verified: Int((Response["verified"] as? String)!)!)
    }
    
    init() {
    
        
    }
    
    public func setOnline(online: Bool) {
        
        self.online = online;
    }
    
    func isOnline() -> Bool {
        
        return self.online;
    }
    
    public func setAuthorizeTimeAgo(authorizeTimeAgo: String) {
        
        self.authorizeTimeAgo = authorizeTimeAgo
    }
    
    public func getAuthorizeTimeAgo()->String {
        
        return self.authorizeTimeAgo!
    }
    
    
    public func setBlocked(blocked: Bool) {
        
        self.blocked = blocked;
    }
    
    func isBlocked() -> Bool {
        
        return self.blocked;
    }

    public func setMyLike(myLike: Bool) {
        
        self.myLike = myLike;
    }
    
    func isMyLike() -> Bool {
        
        return self.myLike;
    }
    
    public func setFollow(follow: Bool) {
        
        self.follow = follow;
    }
    
    func isFollow() -> Bool {
        
        return self.follow;
    }
    
    public func setInBlackList(inBlackList: Bool) {
        
        self.inBlackList = inBlackList;
    }
    
    func isInBlackList() -> Bool {
        
        return self.inBlackList;
    }
    
    public func setFriend(friend: Bool) {
        
        self.friend = friend;
    }
    
    func isFriend() -> Bool {
        
        return self.friend;
    }
    
    public func setFollower(follower: Bool) {
        
        self.follower = follower;
    }
    
    func isFollower() -> Bool {
        
        return self.follower;
    }
    
    public func setGiftsCount(giftsCount: Int) {
        
        self.giftsCount = giftsCount;
    }
    
    func getGiftsCount() -> Int {
        
        return self.giftsCount;
    }
    
    public func setLikesCount(likesCount: Int) {
        
        self.likesCount = likesCount;
    }
    
    func getLikesCount() -> Int {
        
        return self.likesCount;
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
    
    public func setGalleryItemsCount(galleryItemsCount: Int) {
        
        self.galleryItemsCount = galleryItemsCount;
    }
    
    func getGalleryItemsCount() -> Int {
        
        return self.galleryItemsCount;
    }
    
    public func setFriendsCount(friendsCount: Int) {
        
        self.friendsCount = friendsCount;
    }
    
    func getFriendsCount() -> Int {
        
        return self.friendsCount;
    }
    
    
    
    
    //
    
    public func setDistance(distance: Double) {
        
        self.distance = distance;
    }
    
    func getDistance() -> Double {
        
        return self.distance;
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
    
    public func setType(type: Int) {
        
        self.type = type;
    }
    
    func getType() -> Int {
        
        return self.type;
    }
    
    public func setVerified(verified: Int) {
        
        self.verified = verified;
    }
    
    func getVerified() -> Int {
        
        return self.verified;
    }
    
    public func setSex(sex: Int) {
        
        self.sex = sex;
    }
    
    func getSex() -> Int {
        
        return self.sex;
    }
    
    public func setAllowShowMyGallery(allowShowMyGallery: Int) {
        
        self.allowShowMyGallery = allowShowMyGallery;
    }
    
    func getAllowShowMyGallery() -> Int {
        
        return self.allowShowMyGallery;
    }
    
    public func setAllowShowMyGifts(allowShowMyGifts: Int) {
        
        self.allowShowMyGifts = allowShowMyGifts;
    }
    
    func getAllowShowMyGifts() -> Int {
        
        return self.allowShowMyGifts;
    }
    
    public func setAllowShowMyFriends(allowShowMyFriends: Int) {
        
        self.allowShowMyFriends = allowShowMyFriends;
    }
    
    func getAllowShowMyFriends() -> Int {
        
        return self.allowShowMyFriends;
    }
    
    public func setAllowShowMyVideos(allowShowMyVideos: Int) {
        
        self.allowShowMyVideos = allowShowMyVideos;
    }
    
    func getAllowShowMyVideos() -> Int {
        
        return self.allowShowMyVideos;
    }
    
    public func setAllowShowMyInfo(allowShowMyInfo: Int) {
        
        self.allowShowMyInfo = allowShowMyInfo;
    }
    
    func getAllowShowMyInfo() -> Int {
        
        return self.allowShowMyInfo;
    }
    
    public func setAllowMessages(allowMessages: Int) {
        
        self.allowMessages = allowMessages;
    }
    
    func getAllowMessages() -> Int {
        
        return self.allowMessages;
    }
    
    public func setAllowGalleryComments(allowGalleryComments: Int) {
        
        self.allowGalleryComments = allowGalleryComments;
    }
    
    func getAllowGalleryComments() -> Int {
        
        return self.allowGalleryComments;
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
    
    public func setCoverUrl(coverUrl: String) {
        
        self.coverUrl = coverUrl.replacingOccurrences(of: "/../", with: "/")
    }
    
    public func getCoverUrl()->String {
        
        return self.coverUrl!
    }
    
    public func setLocation(location: String) {
        
        self.location = location
    }
    
    public func getLocation()->String {
        
        return self.location!
    }
    
    public func setFacebookPage(facebookPage: String) {
        
        self.facebookPage = facebookPage
    }
    
    public func getFacebookPage()->String {
        
        return self.facebookPage!
    }
    
    public func setInstagramPage(instagramPage: String) {
        
        self.instagramPage = instagramPage
    }
    
    public func getInstagramPage()->String {
        
        return self.instagramPage!
    }
}
