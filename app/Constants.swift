//
//  Constants.swift
//
//  Created by Demyanchuk Dmitry on 08.08.2021
//  Copyright © 2021 raccoonsquare@gmail.com All rights reserved.
//

struct Constants {
    
    // CLENT_ID (for identify app on server) Integer value, same that in db.inc.php
    static let CLIENT_ID: Int = 1302; // Correct Example: 1567    Incorrect example: 00098
    
    // CLENT_SECRET String value, same that in db.inc.php
    static let CLIENT_SECRET: String = "U2F5YSBzdWthIGtldGlrYSBBbGV4YSBtZW5pZHVyaSBzYXlh"; // Example: "f*Hk86&_Hrfv7cjnf-I=yT"
    
    // Be careful! Not forgot slash "/" at the string end!
    
    static let API_DOMAIN: String = "https://api.dkon.app/";       // Example: http://yousite.com/
    
    // Show Facebook Login Button or not
    
    static let FACEBOOK_AUTHORIZATION: Bool = false; // true = show button
    
    // Show Google Login Button or not
    
    static let GOOGLE_AUTHORIZATION: Bool = false; // true = show button
    
    
    // Don't modify next constants!!!
    
    static let SERVER_ENGINE_VERSION: Float = 1.0;
    
    static let API_FILE_EXTENSION: String = "";
    
    static let API_VERSION: String = "v3";
    
    // Api URLs
    
    static let METHOD_PRIVACY_SETTINGS: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.privacy" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_APP_TERMS: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/app.terms" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_APP_THANKS: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/app.thanks" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_AUTHORIZE: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.authorize" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_SIGNIN: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.signIn" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_SIGNUP: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.signUp" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_RECOVERY: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.recovery" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_LOGOUT: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.logOut" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_SAVE_SETTINGS: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.saveSettings" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_SETPASSWORD: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.setPassword" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_GET_SETTINGS: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.getSettings" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_SET_DEVICE_TOKEN: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.setGcmToken" + Constants.API_FILE_EXTENSION;
    
    
    // Freinds
    
    static let METHOD_FRIENDS_SEND_REQUEST: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/profile.follow" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_FRIENDS_GET: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/friends.get" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_FRIENDS_ACCEPT: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/friends.acceptRequest" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_FRIENDS_REJECT: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/friends.rejectRequest" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_FRIENDS_REMOVE: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/friends.remove" + Constants.API_FILE_EXTENSION;
    
    
    // Groups
    
    static let METHOD_GROUP_FOLLOW: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/group.follow" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_GROUP_SEARCH: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/group.search" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_GROUP_SEARCH_PRELOAD: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/group.searchPreload" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_GROUP_GET: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/group.get" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_GROUP_GET_FOLLOWERS: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/group.getFollowers" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_GROUP_GET_WALL: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/group.getWall" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_GROUP_GET_MY_GROUPS: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/group.getMyGroups" + Constants.API_FILE_EXTENSION;
    
    // Account Privacy Settings
    
    static let METHOD_ACCOUNT_SET_ALLOW_MESSAGES: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.setAllowMessages" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_SET_ALLOW_COMMENTS: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.setAllowComments" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_SET_ALLOW_GALLERY_COMMENTS: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.setAllowGalleryComments" + Constants.API_FILE_EXTENSION;
    
    // Messages
    
    static let METHOD_DIALOGS_GET: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/dialogs_new.get" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_DIALOG_REMOVE: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/chat.remove" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_CHAT_GET: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/chat.get" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_CHAT_GET_PREVIOUS: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/chat.getPrevious" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_CHAT_UPDATE: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/chat.update" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_MESSAGE_NEW: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/msg.new" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_MESSAGE_UPLOAD_IMAGE: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/msg.uploadImg" + Constants.API_FILE_EXTENSION;
    
    // Notifications
    
    static let METHOD_NOTIFICATIONS_GET: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/notifications.get" + Constants.API_FILE_EXTENSION;
    
    // Gifts
    
    static let METHOD_GIFTS_GET: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/gifts.get" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_GIFTS_REMOVE: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/gifts.remove" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_GIFTS_SELECT: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/gifts.select" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_GIFTS_SEND: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/gifts.send" + Constants.API_FILE_EXTENSION;
    
    // Nearby
    
    static let METHOD_PEOPLE_NEARBY_GET: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/profile.getPeopleNearby" + Constants.API_FILE_EXTENSION;
    
    // Profile
    
    static let METHOD_PROFILE_UPLOAD_IMAGE: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/profile.uploadImg" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_PROFILE_GET: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/profile.get" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_PROFILE_GET_FOLLOWERS: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/profile.followers" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_PROFILE_GET_FOLLOWINGS: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/profile.followings" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_PROFILE_FOLLOW: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/profile.follow" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_PROFILE_GET_ITEMS: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/wall.get" + Constants.API_FILE_EXTENSION;
    
    
    // Stream, feed, favorites, guests
    
    static let METHOD_STREAM_GET: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/stream.get" + Constants.API_FILE_EXTENSION;
    static let METHOD_FEED_GET: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/feeds.get" + Constants.API_FILE_EXTENSION;
    static let METHOD_FAVORITES_GET: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/favorites.get" + Constants.API_FILE_EXTENSION;
    static let METHOD_GUESTS_GET: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/guests.get" + Constants.API_FILE_EXTENSION;
    
    // Item
    
    static let METHOD_ITEM_GET: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/item.get" + Constants.API_FILE_EXTENSION;
    static let METHOD_ITEM_GET_COMMENTS: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/item.getComments" + Constants.API_FILE_EXTENSION;
    static let METHOD_ITEM_EDIT: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/items.edit" + Constants.API_FILE_EXTENSION;
    static let METHOD_ITEM_REMOVE: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/items.remove" + Constants.API_FILE_EXTENSION;
    static let METHOD_ITEM_NEW: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/items.new" + Constants.API_FILE_EXTENSION;
    static let METHOD_ITEM_UPLOAD_IMG: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/items.uploadImg" + Constants.API_FILE_EXTENSION;
    static let METHOD_ITEM_PIN: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/items.pin" + Constants.API_FILE_EXTENSION;

    
    // Blacklist
    
    static let METHOD_BLACKLIST_GET: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/blacklist.get" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_BLACKLIST_ADD: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/blacklist.add" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_BLACKLIST_REMOVE: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/blacklist.remove" + Constants.API_FILE_EXTENSION;
    
    // Search
    
    static let METHOD_SEARCH_PROFILE: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/app.search" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_SEARCH_PROFILE_PRELOAD: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/app.searchPreload" + Constants.API_FILE_EXTENSION;
    
    // Search fo new server version
    
    // static let METHOD_SEARCH_PROFILE: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/search.profile" + Constants.API_FILE_EXTENSION;
    
    // static let METHOD_SEARCH_PROFILE_PRELOAD: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/search.profilePreload" + Constants.API_FILE_EXTENSION;
    
    // Stickers
    
    static let METHOD_STICKERS_GET: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/stickers.get" + Constants.API_FILE_EXTENSION;
    
    // For version 1.5
    
    static let METHOD_CHAT_NOTIFY: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/chat.notify" + Constants.API_FILE_EXTENSION;
    
    // For version 1.6
    
    static let METHOD_ACCOUNT_LOGINBYFACEBOOK: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.signInByFacebook" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_CONNECT_TO_FACEBOOK: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.connectToFacebook" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_DISCONNECT_FROM_FACEBOOK: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.disconnectFromFacebook" + Constants.API_FILE_EXTENSION;
    
    //
    
    static let METHOD_REPORT_NEW: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/reports.new" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_LIKES_LIKE: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/likes.like" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_LIKES_GET: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/likes.get" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_COMMENTS_NEW: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/comments.new" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_COMMENTS_REMOVE: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/comments.remove" + Constants.API_FILE_EXTENSION;
    
    
    // Gallery
    
    static let METHOD_GALLERY_GET: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/gallery.get" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_GALLERY_ITEM_INFO: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/gallery.info" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_GALLERY_ITEM_REMOVE: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/gallery.remove" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_GALLERY_ITEM_NEW: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/gallery.add" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_GALLERY_UPLOAD_IMAGE: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/gallery.uploadImg" + Constants.API_FILE_EXTENSION;
    //
    
    static let METHOD_ACCOUNT_UPGRADE: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.upgrade" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_PAYMENTS_NEW: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/payments.new" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_PAYMENTS_GET: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/payments.get" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_GOOGLE_AUTH: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.google" + Constants.API_FILE_EXTENSION;
    
    static let APP_TYPE_ALL = -1;
    static let APP_TYPE_MANAGER = 0;
    static let APP_TYPE_WEB = 1;
    static let APP_TYPE_ANDROID = 2;
    static let APP_TYPE_IOS = 3;
    
    static let UPLOAD_TYPE_PHOTO = 0;
    static let UPLOAD_TYPE_COVER = 1;
    
    static let GALLERY_ITEM_TYPE_IMAGE = 0;
    static let GALLERY_ITEM_TYPE_VIDEO = 1;
    
    static let REPORT_TYPE_ITEM = 0;
    static let REPORT_TYPE_PROFILE = 1;
    static let REPORT_TYPE_MESSAGE = 2;
    static let REPORT_TYPE_COMMENT = 3;
    static let REPORT_TYPE_GALLERY_ITEM = 4;
    static let REPORT_TYPE_MARKET_ITEM = 5;
    static let REPORT_TYPE_COMMUNITY = 6;
    
    static let ITEM_TYPE_IMAGE = 0;
    static let ITEM_TYPE_VIDEO = 1;
    static let ITEM_TYPE_POST = 2;
    static let ITEM_TYPE_COMMENT = 3;
    static let ITEM_TYPE_GALLERY = 4;
    
    // Constants for Interface
    
    static let GHOST_MODE_COST = 100;
    static let VERIFIED_BADGE_COST = 150;
    static let DISABLE_ADS_COST = 200;
    
    static let LIST_ITEMS = 20;
    
    static let ITEMS_PROFILE_PAGE: Int = 0;
    static let ITEMS_STREAM_PAGE: Int = 1;
    static let ITEMS_FEED_PAGE: Int = 2;
    static let ITEMS_FAVORITES_PAGE: Int = 3;
    static let ITEMS_GET_ITEM: Int = 4;
    static let ITEMS_GROUP_PAGE: Int = 5;
    
    static let INFO_URL: Int = 10999;
    
    // Api Constants
    
    static let ERROR_SUCCESS: Int = 0;
    
    static let ERROR_UNKNOWN: Int = 100;
    static let ERROR_LOGIN_TAKEN: Int = 300;
    static let ERROR_EMAIL_TAKEN: Int = 301;
    
    static let ERROR_CLIENT_ID: Int = 19100;
    static let ERROR_CLIENT_SECRET: Int = 19101;
    
    static let NOTIFY_TYPE_LIKE: Int = 0;
    static let NOTIFY_TYPE_FOLLOWER: Int = 1;
    static let NOTIFY_TYPE_MESSAGE: Int = 2;
    static let NOTIFY_TYPE_COMMENT: Int = 3;
    static let NOTIFY_TYPE_COMMENT_REPLY: Int = 4;
    static let NOTIFY_TYPE_FRIEND_REQUEST_ACCEOTED: Int = 5;
    static let NOTIFY_TYPE_GIFT: Int = 6;
    static let NOTIFY_TYPE_IMAGE_COMMENT: Int = 7;
    static let NOTIFY_TYPE_IMAGE_COMMENT_REPLY: Int = 8;
    static let NOTIFY_TYPE_IMAGE_LIKE: Int = 9;
    
    static let NOTIFY_TYPE_MEDIA_APPROVE: Int = 10;
    static let NOTIFY_TYPE_MEDIA_REJECT: Int = 11;
    
    static let NOTIFY_TYPE_PROFILE_PHOTO_APPROVE: Int = 12;
    static let NOTIFY_TYPE_PROFILE_PHOTO_REJECT: Int = 13;
    
    static let NOTIFY_TYPE_ACCOUNT_APPROVE: Int = 14;
    static let NOTIFY_TYPE_ACCOUNT_REJECT: Int = 15;
    
    static let NOTIFY_TYPE_PROFILE_COVER_APPROVE: Int = 16;
    static let NOTIFY_TYPE_PROFILE_COVER_REJECT: Int = 17;
    
    static let ACCOUNT_STATE_ENABLED: Int = 0;
    static let ACCOUNT_STATE_DISABLED: Int = 1;
    static let ACCOUNT_STATE_BLOCKED: Int = 2;
    static let ACCOUNT_STATE_DEACTIVATED: Int = 3;
    
    static let ACCOUNT_TYPE_USER: Int = 0;
    static let ACCOUNT_TYPE_GROUP: Int = 1;
    static let ACCOUNT_TYPE_PAGE: Int = 2;
    
    static let GCM_NOTIFY_CONFIG: Int = 0;
    static let GCM_NOTIFY_SYSTEM: Int = 1;
    static let GCM_NOTIFY_CUSTOM: Int = 2;
    static let GCM_NOTIFY_LIKE: Int = 3;
    static let GCM_NOTIFY_ANSWER: Int = 4;
    static let GCM_NOTIFY_QUESTION: Int = 5;
    static let GCM_NOTIFY_COMMENT: Int = 6;
    static let GCM_NOTIFY_FOLLOWER: Int = 7;
    static let GCM_NOTIFY_PERSONAL: Int = 8;
    static let GCM_NOTIFY_MESSAGE: Int = 9;
    static let GCM_NOTIFY_COMMENT_REPLY: Int = 10;
    static let GCM_NOTIFY_REQUEST_INBOX: Int = 11;
    static let GCM_NOTIFY_REQUEST_ACCEPTED: Int = 12;
    static let GCM_NOTIFY_GIFT: Int = 14;
    static let GCM_NOTIFY_SEEN: Int = 15;
    static let GCM_NOTIFY_TYPING: Int = 16;
    static let GCM_NOTIFY_URL: Int = 17;
    static let GCM_NOTIFY_IMAGE_COMMENT_REPLY: Int = 18;
    static let GCM_NOTIFY_IMAGE_COMMENT: Int = 19;
    static let GCM_NOTIFY_IMAGE_LIKE: Int = 20;
    
    static let GCM_NOTIFY_TYPING_START: Int = 27;
    static let GCM_NOTIFY_TYPING_END: Int = 28;
    
    static let GCM_NOTIFY_MEDIA_APPROVE: Int = 1001;
    static let GCM_NOTIFY_MEDIA_REJECT: Int = 1002;
    
    static let GCM_NOTIFY_PROFILE_PHOTO_APPROVE: Int = 1003;
    static let GCM_NOTIFY_PROFILE_PHOTO_REJECT: Int = 1004;
    
    static let GCM_NOTIFY_ACCOUNT_APPROVE: Int = 1005;
    static let GCM_NOTIFY_ACCOUNT_REJECT: Int = 1006;
    
    static let GCM_NOTIFY_PROFILE_COVER_APPROVE: Int = 1007;
    static let GCM_NOTIFY_PROFILE_COVER_REJECT: Int = 1008;
    
    static let SEX_UNKNOWN: Int = 0;
    static let SEX_MALE: Int = 1;
    static let SEX_FEMALE: Int = 2;
    
    static let ERROR_FACEBOOK_ID_TAKEN: Int = 302;
    
    // Payments
    
    static let PA_BUY_CREDITS: Int = 0;
    static let PA_BUY_GIFT: Int = 1;
    static let PA_BUY_VERIFIED_BADGE: Int = 2;
    static let PA_BUY_GHOST_MODE: Int = 3;
    static let PA_BUY_DISABLE_ADS: Int = 4;
    static let PA_BUY_REGISTRATION_BONUS: Int = 5;
    static let PA_BUY_REFERRAL_BONUS: Int = 6;
    static let PA_BUY_MANUAL_BONUS: Int = 7;
    
    static let PT_UNKNOWN: Int = 0;
    static let PT_CREDITS: Int = 1;
    static let PT_CARD: Int = 2;
    static let PT_GOOGLE_PURCHASE: Int = 3;
    static let PT_APPLE_PURCHASE: Int = 4;
    static let PT_ADMOB_REWARDED_ADS: Int = 5;
    static let PT_BONUS: Int = 6;
    
    static let OAUTH_TYPE_FACEBOOK: Int = 0;
    static let OAUTH_TYPE_GOOGLE: Int = 1;
}
