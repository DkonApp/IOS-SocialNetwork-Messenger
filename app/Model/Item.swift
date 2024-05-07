//
//  Item.swift
//
//  Created by Demyanchuk Dmitry on 24.01.17.
//  Copyright © 2017 qascript@mail.ru All rights reserved.
//

import UIKit

class Item {
    
    public var photoLoading = false
    public var imgLoading = false
    public var linkImgLoading = false
    public var videoImgLoading = false
    public var youtubeImgLoading = false
    
    private var id: Int = 0
    
    private var rePostId: Int = 0
    private var groupId: Int = 0
    
    private var fromUserId: Int = 0
    private var fromUserVerified: Int = 0
    
    private var fromUserAllowPhotosComments: Int = 0
    
    private var commentsCount: Int = 0
    private var likesCount: Int = 0
    private var rePostsCount: Int = 0
    
    private var allowComments: Int = 0
    private var groupAllowComments: Int = 0
    
    private var username: String?
    private var fullname: String?
    private var photoUrl: String?
    
    private var content: String?
    private var imgUrl: String?
    
    private var previewVideoImgUrl: String?
    private var videoUrl: String?
    
    private var urlPreviewTitle: String?
    private var urlPreviewImage: String?
    private var urlPreviewLink: String?
    private var urlPreviewDescription: String?
    
    private var youtubeVideoImg: String?
    private var youtubeVideoCode: String?
    private var youtubeVideoUrl: String?
    
    private var date: String?
    private var timeAgo: String?
    
    private var myLike: Bool = false;
    private var myRePost: Bool = false;
    
    private var pinned: Int = 0
    
    init(Response: AnyObject) {
        
        self.setId(id: Int((Response["id"] as? String)!)!)
        
        self.setRePostId(rePostId: Int((Response["rePostId"] as? String)!)!)
        self.setGroupId(groupId: Int((Response["groupId"] as? String)!)!)
        
        self.setFromUserId(fromUserId: Int((Response["fromUserId"] as? String)!)!)
        self.setFromUserVerified(fromUserVerified: Int((Response["fromUserVerify"] as? String)!)!)
        
        self.setFullname(fullname: (Response["fromUserFullname"] as? String)!)
        self.setUsername(username: (Response["fromUserUsername"] as? String)!)
        self.setPhotoUrl(photoUrl: (Response["fromUserPhoto"] as? String)!)
        
        self.setUrlPreviewTitle(urlPreviewTitle: (Response["urlPreviewTitle"] as? String)!)
        self.setUrlPreviewImage(urlPreviewImage: (Response["urlPreviewImage"] as? String)!)
        self.setUrlPreviewLink(urlPreviewLink: (Response["urlPreviewLink"] as? String)!)
        self.setUrlPreviewDescription(urlPreviewDescription: (Response["urlPreviewDescription"] as? String)!)
        
        self.setYoutubeVideoImg(youtubeVideoImg: (Response["YouTubeVideoImg"] as? String)!)
        self.setYoutubeVideoCode(youtubeVideoCode: (Response["YouTubeVideoCode"] as? String)!)
        self.setYoutubeVideoUrl(youtubeVideoUrl: (Response["YouTubeVideoUrl"] as? String)!)
        
        self.setContent(content: (Response["post"] as? String)!)
        self.setImgUrl(imgUrl: (Response["imgUrl"] as? String)!)
        self.setPreviewVideoImgUrl(previewVideoImgUrl: (Response["previewVideoImgUrl"] as? String)!)
        self.setVideoUrl(videoUrl: (Response["videoUrl"] as? String)!)
        
        self.setCommentsCount(commentsCount: Int((Response["commentsCount"] as? String)!)!)
        self.setLikesCount(likesCount: Int((Response["likesCount"] as? String)!)!)
        self.setRePostsCount(rePostsCount: Int((Response["rePostsCount"] as? String)!)!)
        
        self.setAllowComments(allowComments: Int((Response["allowComments"] as? String)!)!)
        //self.setGroupAllowComments(groupAllowComments: Int((Response["groupAllowComments"] as? String)!)!)
        
        self.setDate(date: (Response["date"] as? String)!)
        self.setTimeAgo(timeAgo: (Response["timeAgo"] as? String)!)
        
        if ((Response["myLike"] as? Bool) != nil) {
            
            self.setMyLike(myLike: (Response["myLike"] as? Bool)!)
        }
        
        if ((Response["myRePost"] as? Bool) != nil) {
            
            self.setMyRePost(myRePost: (Response["myRePost"] as? Bool)!)
        }
        
        self.setPinned(pinned: Int((Response["pinned"] as? String)!)!)
        
    }
    
    init() {
        
    }

    
    public func setId(id: Int) {
        
        self.id = id;
    }
    
    func getId() -> Int {
        
        return self.id;
    }
    
    public func setRePostId(rePostId: Int) {
        
        self.rePostId = rePostId;
    }
    
    func getRePostId() -> Int {
        
        return self.rePostId;
    }
    
    public func setGroupId(groupId: Int) {
        
        self.groupId = groupId;
    }
    
    func getGroupId() -> Int {
        
        return self.groupId;
    }
    
    public func setAllowComments(allowComments: Int) {
        
        self.allowComments = allowComments;
    }
    
    func getAllowComments() -> Int {
        
        return self.allowComments;
    }
    
    public func setGroupAllowComments(groupAllowComments: Int) {
        
        self.groupAllowComments = groupAllowComments;
    }
    
    func getGroupAllowComments() -> Int {
        
        return self.groupAllowComments;
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
    
    public func setRePostsCount(rePostsCount: Int) {
        
        self.rePostsCount = rePostsCount;
    }
    
    func getRepostsCount() -> Int {
        
        return self.rePostsCount;
    }
    
    public func setFromUserId(fromUserId: Int) {
        
        self.fromUserId = fromUserId;
    }
    
    func getFromUserId() -> Int {
        
        return self.fromUserId;
    }
    
    public func setFromUserVerified(fromUserVerified: Int) {
        
        self.fromUserVerified = fromUserVerified;
    }
    
    func getFromUserVerified() -> Int {
        
        return self.fromUserVerified;
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
    
    public func setContent(content: String) {
        
        self.content = content.replacingOccurrences(of: "<br>", with: "\n")
    }
    
    public func getContent()->String {
        
        return self.content!
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
    
    public func setVideoUrl(videoUrl: String) {
        
        self.videoUrl = videoUrl.replacingOccurrences(of: "/../", with: "/")
    }
    
    public func getVideoUrl()->String {
        
        return self.videoUrl!
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
    
    public func setMyRePost(myRePost: Bool) {
        
        self.myRePost = myRePost;
    }
    
    func isMyRePost() -> Bool {
        
        return self.myRePost;
    }
    
    public func setYoutubeVideoUrl(youtubeVideoUrl: String) {
        
        self.youtubeVideoUrl = youtubeVideoUrl
    }
    
    public func getYoutubeVideoUrl()->String {
        
        return self.youtubeVideoUrl!
    }
    
    public func setYoutubeVideoCode(youtubeVideoCode: String) {
        
        self.youtubeVideoCode = youtubeVideoCode
    }
    
    public func getYoutubeVideoCode()->String {
        
        return self.youtubeVideoCode!
    }
    
    public func setYoutubeVideoImg(youtubeVideoImg: String) {
        
        self.youtubeVideoImg = youtubeVideoImg
    }
    
    public func getYoutubeVideoImg()->String {
        
        return self.youtubeVideoImg!
    }
    
    public func setUrlPreviewDescription(urlPreviewDescription: String) {
        
        self.urlPreviewDescription = urlPreviewDescription
    }
    
    public func getUrlPreviewDescription()->String {
        
        return self.urlPreviewDescription!
    }
    
    public func setUrlPreviewLink(urlPreviewLink: String) {
        
        self.urlPreviewLink = urlPreviewLink
    }
    
    public func getUrlPreviewLink()->String {
        
        return self.urlPreviewLink!
    }
    
    public func setUrlPreviewImage(urlPreviewImage: String) {
        
        self.urlPreviewImage = urlPreviewImage
    }
    
    public func getUrlPreviewImage()->String {
        
        return self.urlPreviewImage!
    }
    
    public func setUrlPreviewTitle(urlPreviewTitle: String) {
        
        self.urlPreviewTitle = urlPreviewTitle
    }
    
    public func getUrlPreviewTitle()->String {
        
        return self.urlPreviewTitle!
    }
    
    public func setPinned(pinned: Int) {
        
        self.pinned = pinned;
    }
    
    func getPinned() -> Int {
        
        return self.pinned;
    }
}
