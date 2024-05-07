//
//  Photo.swift
//
//  Created by Demyanchuk Dmitry on 24.01.17.
//  Copyright © 2017 qascript@mail.ru All rights reserved.
//

import UIKit

class Photo {
    
    public var photoLoading = false
    public var imgLoading = false
    
    private var id: Int = 0
    
    private var itemType: Int = 0
    
    private var fromUserId: Int = 0
    
    private var commentsCount: Int = 0
    private var likesCount: Int = 0
    
    private var comment: String?
    private var imgUrl: String?
    private var videoUrl: String?
    private var previewVideoImgUrl: String?
    private var previewImgUrl: String?
    
    private var date: String?
    private var timeAgo: String?
    
    private var myLike: Bool = false;
    
    private var owner = Profile();
    
    init(Response: AnyObject, owner: Bool) {
        
        self.setId(id: Int((Response["id"] as? String)!)!)
        
        self.setFromUserId(fromUserId: Int((Response["fromUserId"] as? String)!)!)
        self.setItemType(itemType: Int((Response["itemType"] as? String)!)!)
        
        self.setComment(comment: (Response["comment"] as? String)!)
        self.setVideoUrl(videoUrl: (Response["videoUrl"] as? String)!)
        self.setImgUrl(imgUrl: (Response["imgUrl"] as? String)!)
        self.setPreviewVideoImgUrl(previewVideoImgUrl: (Response["previewVideoImgUrl"] as? String)!)
        self.setPreviewImgUrl(previewImgUrl: (Response["previewImgUrl"] as? String)!)
        
        self.setCommentsCount(commentsCount: Int((Response["commentsCount"] as? String)!)!)
        self.setLikesCount(likesCount: Int((Response["likesCount"] as? String)!)!)
        
        self.setDate(date: (Response["date"] as? String)!)
        self.setTimeAgo(timeAgo: (Response["timeAgo"] as? String)!)
        
        if ((Response["myLike"] as? Bool) != nil) {
            
            self.setMyLike(myLike: (Response["myLike"] as? Bool)!)
        }
        
        if (owner) {
            
            self.setOwner(owner: Profile(Response: Response["owner"] as AnyObject))
        }
        
    }
    
    init() {
        
    }
    
    public func setId(id: Int) {
        
        self.id = id;
    }
    
    func getId() -> Int {
        
        return self.id;
    }
    
    public func setItemType(itemType: Int) {
        
        self.itemType = itemType;
    }
    
    func getItemType() -> Int {
        
        return self.itemType;
    }
    
    public func setCommentsCount(commentsCount: Int) {
        
        self.commentsCount = commentsCount;
    }
    
    func getCommentsCount() -> Int {
        
        return self.commentsCount;
    }
    
    public func setLikesCount(likesCount: Int) {
        
        self.likesCount = likesCount;
    }
    
    func getLikesCount() -> Int {
        
        return self.likesCount;
    }
    
    public func setFromUserId(fromUserId: Int) {
        
        self.fromUserId = fromUserId;
    }
    
    func getFromUserId() -> Int {
        
        return self.fromUserId;
    }
    
    public func setComment(comment: String) {
        
        self.comment = comment
    }
    
    public func getComment()->String {
        
        return self.comment!
    }
    
    public func setVideoUrl(videoUrl: String) {
        
        self.videoUrl = videoUrl.replacingOccurrences(of: "/../", with: "/")
    }
    
    public func getVideoUrl()->String {
        
        return self.videoUrl!
    }
    
    public func setImgUrl(imgUrl: String) {
        
        self.imgUrl = imgUrl.replacingOccurrences(of: "/../", with: "/")
    }
    
    public func getImgUrl()->String {
        
        return self.imgUrl!
    }
    
    public func setPreviewVideoImgUrl(previewVideoImgUrl: String) {
        
        self.previewVideoImgUrl = previewVideoImgUrl.replacingOccurrences(of: "/../", with: "/")
    }
    
    public func getPreviewVideoImgUrl()->String {
        
        return self.previewVideoImgUrl!
    }
    
    public func setPreviewImgUrl(previewImgUrl: String) {
        
        self.previewImgUrl = previewImgUrl.replacingOccurrences(of: "/../", with: "/")
    }
    
    public func getPreviewImgUrl()->String {
        
        return self.previewImgUrl!
    }
    
    public func setDate(date: String) {
        
        self.date = date
    }
    
    public func getDate()->String {
        
        return self.date!
    }
    
    public func setTimeAgo(timeAgo: String) {
        
        self.timeAgo = timeAgo
    }
    
    public func getTimeAgo()->String {
        
        return self.timeAgo!
    }
    
    public func setMyLike(myLike: Bool) {
        
        self.myLike = myLike;
    }
    
    func isMyLike() -> Bool {
        
        return self.myLike;
    }
    
    public func setOwner(owner: Profile) {
        
        self.owner = owner
    }
    
    public func getOwner()->Profile {
        
        return self.owner
    }
}
