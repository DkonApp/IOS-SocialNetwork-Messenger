//
//  ProfileController.swift
//
//  Created by Demyancuk Dmitry on 25.01.17.
//  Copyright © 2017 qascript@mail.ru All rights reserved.
//

import UIKit

class ProfileController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var verifiedView: UIImageView!
    @IBOutlet weak var coverView: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorView: UILabel!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var giftButton: UIButton!
    
    var items = [Info]()
    
    var menuButton = UIBarButtonItem()
    var refreshControl = UIRefreshControl()
    
    var onload: Bool = false;
    
    var profile = Profile();
    
    var profileId: Int = 0
    
    
    var itemId: Int = 0;
    var itemsLoaded: Int = 0;
    
    var loadMoreStatus = false
    var loading = false

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        actionButton.isHidden = true;
        messageButton.isHidden = true;
        
        actionButton.layer.cornerRadius = 5;
        
        if (profileId == 0) {
            
            profileId = iApp.sharedInstance.getId()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        self.tableView.addSubview(refreshControl)
        self.tableView.alwaysBounceVertical = true
        
        showLoadingScreen()
        
        getData(profileId: profileId)
    }
    
    @objc func refresh(sender:AnyObject) {
        
        refreshBegin(newtext: "Refresh",
                     refreshEnd: {(x:Int) -> () in

                        self.tableView.reloadData()
                        self.refreshControl.endRefreshing()
        })
    }
    
    func refreshBegin(newtext:String, refreshEnd:@escaping (Int) -> ()) {
        
        DispatchQueue.global().async {
            
            if (!self.loading) {
                
                self.items.removeAll()
                
                self.tableView.reloadData()
                
                self.itemId = 0;
                
                self.getData(profileId: self.profileId)
            }
            
            DispatchQueue.global().async  {
                
                refreshEnd(0)
            }
        }
        
    }
    
    func showLoadingScreen() {
        
        self.errorView.isHidden = true
        
        self.loadingIndicator.isHidden = false
        self.loadingIndicator.startAnimating()
        
        self.tableView.isHidden = true
    }
    
    func showContentScreen() {
        
        self.errorView.isHidden = true
        
        self.loadingIndicator.isHidden = true
        self.loadingIndicator.stopAnimating()
        
        self.tableView.isHidden = false
    }
    
    func showErrorScreen() {
        
        self.errorView.isHidden = false
        
        self.loadingIndicator.isHidden = true
        self.loadingIndicator.stopAnimating()
        
        self.tableView.isHidden = true
    }
    
    func getData(profileId: Int) {
        
        self.loading = true;
        
        var request = URLRequest(url: URL(string: Constants.METHOD_PROFILE_GET)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&profileId=" + String(profileId) + "&ios_fcm_regId=" + iApp.sharedInstance.getFcmRegId();
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
                DispatchQueue.main.async() {
                    
                    self.showErrorScreen();
                }
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        self.profile = Profile(Response: response as AnyObject)
                        
                        DispatchQueue.global(qos: .background).async {
                            
                            DispatchQueue.main.async {
                                
                                // show profile info
                                
                                if (self.profile.getState() != Constants.ACCOUNT_STATE_ENABLED) {
                                    
                                    self.showErrorScreen();
                                    
                                    self.errorView.text = NSLocalizedString("label_profile_blocked", comment: "")
                                    
                                } else {
                                    
                                    self.showContentScreen();
                                }
                                
                                self.loadingComplete();
                            }
                        }
                        
                    } else {
                        
                        // error
                        
                        DispatchQueue.main.async() {
                            
                            self.showErrorScreen();
                        }
                    }
                    
                    
                } catch let error2 as NSError {
                    
                    print(error2.localizedDescription)
                    
                    DispatchQueue.main.async() {
                        
                        self.showErrorScreen();
                    }
                }
            }
            
        }).resume();
    }
    
    func loadingComplete() {
        
        if (self.itemsLoaded >= Constants.LIST_ITEMS) {
            
            self.loadMoreStatus = false
            
        } else {
            
            self.loadMoreStatus = true
        }
        
        self.updateProfile()
        self.updateInfo()
        
        self.tableView.reloadData()
        self.loading = false
    }
    
    func updateInfo() {
        
        if (self.profile.getType() == Constants.ACCOUNT_TYPE_USER) {
            
            var activity: String = ""
            
            if (profile.isOnline()) {
                
                activity = NSLocalizedString("label_online", comment: "")
                
            } else {
                
                activity = profile.getAuthorizeTimeAgo()
            }
            
            
            self.items.append(Info(id: self.profile.getSex(), title: NSLocalizedString("label_activity", comment: ""), detail: activity, image: UIImage(named: "ic_profile_30")!))
        }
        
        if (self.profile.getSex() != Constants.SEX_UNKNOWN) {
            
            self.items.append(Info(id: self.profile.getSex(), title: NSLocalizedString("label_gender", comment: ""), detail: Helper.getGender(sex: self.profile.getSex()), image: UIImage(named: "ic_gender_30")!))
        }
        
        if (iApp.sharedInstance.getId() != self.profile.getId() && self.profile.getAllowShowMyInfo() == 1  && !self.profile.isFriend()) {
            
            //
            
        } else {
            
            if (self.profile.getFacebookPage().count > 0) {
                
                self.items.append(Info(id: Constants.INFO_URL, title: self.profile.getFacebookPage(), detail: "", image: UIImage(named: "ic_web_30")!))
            }
            
            if (self.profile.getInstagramPage().count > 0) {
                
                self.items.append(Info(id: Constants.INFO_URL, title: self.profile.getInstagramPage(), detail: "", image: UIImage(named: "ic_web_30")!))
            }
        }
    }
    
    func updateProfile() {
        
        if (iApp.sharedInstance.getId() != self.profile.getId() && !onload && self.profile.getState() == Constants.ACCOUNT_STATE_ENABLED && self.profile.getType() == Constants.ACCOUNT_TYPE_USER) {
            
            self.menuButton = UIBarButtonItem(image: UIImage(named: "ic_dots_30"), style: .plain, target: self, action: #selector(showMenu))
            self.navigationItem.rightBarButtonItem  = menuButton
        }
        
        self.onload = true;
        
        if (self.profile.getId() != iApp.sharedInstance.getId()) {
            
            self.title = self.profile.getFullname()
        }
        
        self.fullnameLabel.text = self.profile.getFullname()
        
        self.verifiedView.isHidden = true;
        
        if (self.profile.getVerified() == 1) {
            
            self.verifiedView.isHidden = false;
        }
        
        self.photoView.image = UIImage(named: "ic_profile_default_photo")
        self.coverView.image = UIImage(named: "ic_profile_default_cover")
        
        self.photoView.layer.borderWidth = 1
        self.photoView.layer.masksToBounds = false
        self.photoView.layer.borderColor = UIColor.white.cgColor
        self.photoView.layer.cornerRadius = self.photoView.frame.height/2
        self.photoView.clipsToBounds = true
        
        self.coverView.clipsToBounds = true
        
        if (self.profile.getPhotoUrl().count != 0) {
            
            let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(gesture:)))
            self.photoView.addGestureRecognizer(imageTapGesture)
            self.photoView.isUserInteractionEnabled = true
        }
        
        showGiftButton();
        showMessageButton();
        showActionButton()
        showPhoto()
        showCover()
    }
    
    @IBAction func messageButtonTap(_ sender: Any) {
        
        self.performSegue(withIdentifier: "showChat", sender: self)
    }
    
    func showMessageButton() {
        
        if (self.profile.getId() == iApp.sharedInstance.getId() || self.profile.getType() != Constants.ACCOUNT_TYPE_USER) {
            
            self.messageButton.isHidden = true
            
        } else {
            
            if (self.profile.isInBlackList()) {
                
                self.messageButton.isHidden = true
                
            } else {
                
                if (self.profile.getAllowMessages() == 1) {
                    
                    self.messageButton.isHidden = false
                    
                } else {
                    
                    if (self.profile.isFriend()) {
                        
                        self.messageButton.isHidden = false;
                        
                    } else {
                        
                        self.messageButton.isHidden = true;
                    }
                }
            }
        }
    }
    
    @IBAction func actionButtonTap(_ sender: Any) {
        
        if (self.profile.getId() == iApp.sharedInstance.getId()) {
            
            self.performSegue(withIdentifier: "editProfile", sender: self)
            
        } else {
            
            if (self.profile.isFriend()) {
                
                self.friendsRemove(profileId: self.profile.getId())
                
            } else {
                
                if (!profile.isFollow()) {
                    
                    self.friendsSendRequest(profileId: self.profile.getId())
                    
                } else {
                    
                    self.friendsSendRequest(profileId: self.profile.getId())
                }
            }
        }
    }
    
    func showActionButton() {
        
        actionButton.backgroundColor = Helper.hexStringToUIColor(hex: "#007cf7")
        actionButton.setTitleColor(UIColor.white, for: .normal)
        
        self.actionButton.isHidden = false
        
        if (self.profile.getId() == iApp.sharedInstance.getId()) {
            
            self.actionButton.isEnabled = true
            
            self.actionButton.setTitle(NSLocalizedString("action_edit", comment: ""), for: .normal)
            
        } else {
            
            if (self.profile.isFriend()) {
                
                self.actionButton.isEnabled = true
                
                self.actionButton.setTitle(NSLocalizedString("action_remove_from_freinds", comment: ""), for: .normal)
                
            } else {
                
                if (!profile.isFollow()) {
                    
                    self.actionButton.isEnabled = true
                    
                    self.actionButton.setTitle(NSLocalizedString("action_add_to_freinds", comment: ""), for: .normal)
                    
                } else {
                    
//                    actionButton.backgroundColor = Helper.hexStringToUIColor(hex: "#f2f2f2")
//                    actionButton.setTitleColor(UIColor.darkGray, for: .disabled)
                    
                    self.actionButton.isEnabled = true
                    
                    self.actionButton.setTitle(NSLocalizedString("action_cancel_request", comment: ""), for: .normal)
                }
            }
        }
    }
    
    @IBAction func giftButtonTap(_ sender: Any) {
        
        self.performSegue(withIdentifier: "selectGift", sender: self)
    }
    
    func showGiftButton() {
        
        self.giftButton.isHidden = false
        
        if (self.profile.getId() == iApp.sharedInstance.getId() || self.profile.getType() != Constants.ACCOUNT_TYPE_USER) {
            
            self.giftButton.isHidden = true
            
        } else {
            
            self.giftButton.isHidden = false
        }
    }
    
    @objc func showMenu() {
        
        let alertController = UIAlertController(title: self.profile.getFullname(), message: self.profile.getUsername(), preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: .cancel) { action in
            
            
        }
        
        alertController.addAction(cancelAction)
        
        if (self.profile.isBlocked()) {
         
            let unBlockAction = UIAlertAction(title: NSLocalizedString("action_unblock", comment: ""), style: .default) { action in
                
                self.unblock(profileId: self.profile.getId())
            }
            
            alertController.addAction(unBlockAction)
            
        } else {
            
            let blockAction = UIAlertAction(title: NSLocalizedString("action_block", comment: ""), style: .default) { action in
                
                self.block(profileId: self.profile.getId())
            }
            
            alertController.addAction(blockAction)
        }
        
        let reportAction = UIAlertAction(title: NSLocalizedString("action_report", comment: ""), style: .default) { action in
            
            self.showReportMenu();
        }
        
        alertController.addAction(reportAction)
        
        if let popoverController = alertController.popoverPresentationController {
            
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showReportMenu() {
        
        let alertController = UIAlertController(title: NSLocalizedString("label_abuse_report", comment: ""), message: self.profile.getFullname(), preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: .cancel) { action in
            
        }
        
        alertController.addAction(cancelAction)
                
        let spamAction = UIAlertAction(title: NSLocalizedString("label_report_spam", comment: ""), style: .default) { action in
            
            self.report(profileId: self.profile.getId(), abuseId: 0) // 0 = Spam
        }
        
        alertController.addAction(spamAction)
        
        let hateAction = UIAlertAction(title: NSLocalizedString("label_report_hate", comment: ""), style: .default) { action in
            
            self.report(profileId: self.profile.getId(), abuseId: 1) // 1 = Hate Speech
        }
        
        alertController.addAction(hateAction)
        
        let nudityAction = UIAlertAction(title: NSLocalizedString("label_report_nudity", comment: ""), style: .default) { action in
            
            self.report(profileId: self.profile.getId(), abuseId: 2) // 2 = Nudity
        }
        
        alertController.addAction(nudityAction)
        
        let fakeAction = UIAlertAction(title: NSLocalizedString("label_report_fake", comment: ""), style: .default) { action in
            
            self.report(profileId: self.profile.getId(), abuseId: 3) // 3 = Fake profile
        }
        
        alertController.addAction(fakeAction)
        
        if let popoverController = alertController.popoverPresentationController {
            
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showPhoto() {
        
        if (self.profile.getPhotoUrl().count != 0 && Helper.isInternetAvailable()) {
            
            if (iApp.sharedInstance.getCache().object(forKey: self.profile.getPhotoUrl() as AnyObject) != nil) {
                
                self.photoView.image = iApp.sharedInstance.getCache().object(forKey: self.profile.getPhotoUrl() as AnyObject) as? UIImage
                
            } else {
             
                let imageUrl:URL = URL(string: self.profile.getPhotoUrl())!
                
                DispatchQueue.global().async {
                    
                    let data = try? Data(contentsOf: imageUrl)
                    
                    DispatchQueue.main.async {
                        
                        if data != nil {
                            
                            let img = UIImage(data: data!)
                            
                            self.photoView.image = img
                            
                            iApp.sharedInstance.getCache().setObject(img!, forKey: self.profile.getPhotoUrl() as AnyObject)
                        }
                    }
                }
                
            }
        }
    }
    
    func showCover() {
        
        if (self.profile.getCoverUrl().count != 0 && Helper.isInternetAvailable()) {
            
            if (iApp.sharedInstance.getCache().object(forKey: self.profile.getCoverUrl() as AnyObject) != nil) {
                
                self.coverView.image = iApp.sharedInstance.getCache().object(forKey: self.profile.getCoverUrl() as AnyObject) as? UIImage
                
            } else {
                
                let imageUrl:URL = URL(string: self.profile.getCoverUrl())!
                
                DispatchQueue.global().async {
                    
                    let data = try? Data(contentsOf: imageUrl)
                    
                    DispatchQueue.main.async {
                        
                        if data != nil {
                            
                            let img = UIImage(data: data!)
                            
                            self.coverView.image = img
                            
                            iApp.sharedInstance.getCache().setObject(img!, forKey: self.profile.getCoverUrl() as AnyObject)
                        }
                    }
                }
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if  (segue.identifier == "editProfile") {
            
            //
            
        } else if (segue.identifier == "showGallery") {
            
            let destinationVC = segue.destination as! GalleryController
            destinationVC.profileId = self.profile.getId()
            
        } else if (segue.identifier == "showItems") {
            
            let destinationVC = segue.destination as! ItemsController
            destinationVC.profileId = self.profile.getId()
            destinationVC.pageId = Constants.ITEMS_PROFILE_PAGE
            
        } else if (segue.identifier == "showFriends") {
            
            let destinationVC = segue.destination as! FriendsController
            destinationVC.profileId = self.profile.getId()
            
        } else if (segue.identifier == "showFollowers") {
            
            let destinationVC = segue.destination as! FollowersController
            destinationVC.profileId = self.profile.getId()
            
        } else if (segue.identifier == "showLikes") {
            
            let destinationVC = segue.destination as! LikesController
            destinationVC.profileId = self.profile.getId()
            
        } else if (segue.identifier == "showChat") {
            
            let destinationVC = segue.destination as! ChatViewController
            destinationVC.profileId = self.profile.getId()
            
            destinationVC.with_user_username = self.profile.getUsername()
            destinationVC.with_user_username = self.profile.getFullname()
            destinationVC.with_user_photo_url = self.profile.getPhotoUrl()
            
        } else if (segue.identifier == "showGifts") {
            
            let destinationVC = segue.destination as! GiftsController
            destinationVC.profileId = self.profile.getId()
            
        } else if (segue.identifier == "selectGift") {
            
            let destinationVC = segue.destination as? UINavigationController
            
            let selectGiftVC = destinationVC?.viewControllers.first as! SelectGiftController
            
            selectGiftVC.profileId = self.profile.getId()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView : UITableView,  titleForHeaderInSection section: Int) -> String? {
        
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (section == 0) {
            
            return 4
            
        } else {
            
            return items.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0) {
         
            var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "InfoCell")!
            
            if (cell == nil) {
                
                cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "InfoCell")
            }
            
            switch indexPath.row {
                
            case 0:
                
                cell?.textLabel?.text  = NSLocalizedString("label_gallery", comment: "")
                cell?.detailTextLabel?.text = String(self.profile.getGalleryItemsCount())
                
                break;
                
            case 1:
                
                cell?.textLabel?.text  = NSLocalizedString("label_friends", comment: "")
                cell?.detailTextLabel?.text = String(self.profile.getFriendsCount())
                
                break;
                
            case 2:
                
                cell?.textLabel?.text  = NSLocalizedString("label_items", comment: "")
                cell?.detailTextLabel?.text = String(self.profile.getPostsCount())
                
                break;
                
            case 3:
                
                cell?.textLabel?.text  = NSLocalizedString("label_gifts", comment: "")
                cell?.detailTextLabel?.text = String(self.profile.getGiftsCount())
                
                break;
                
            default:
                
                break
            }
            
            return cell!
            
        } else {
            
            var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "AddonCell")!
            
            if (cell == nil) {
                
                cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "AddonCell")
            }
            
            let item = self.items[indexPath.row]
            
            cell?.textLabel?.text  = item.getTitle()
            cell?.imageView?.image  = item.getImage()
            cell?.detailTextLabel?.text = item.getDetail()
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.section == 0) {
            
            switch indexPath.row {
                
            case 0:
                
                if (iApp.sharedInstance.getId() != self.profile.getId() && self.profile.getAllowShowMyGallery() == 1  && !self.profile.isFriend()) {
                    
                    
                } else {
                    
                    self.performSegue(withIdentifier: "showGallery", sender: self)
                }
                
                break;
                
            case 1:
                
                if (iApp.sharedInstance.getId() != self.profile.getId() && self.profile.getAllowShowMyFriends() == 1  && !self.profile.isFriend()) {
                    
                    
                } else {
                    
                    self.performSegue(withIdentifier: "showFriends", sender: self)
                }
                
                break;
                
            case 2:
                
                self.performSegue(withIdentifier: "showItems", sender: self)
                
                break;
                
            case 3:
                
                if (iApp.sharedInstance.getId() != self.profile.getId() && self.profile.getAllowShowMyGifts() == 1  && !self.profile.isFriend()) {
                    
                    
                } else {
                    
                    self.performSegue(withIdentifier: "showGifts", sender: self)
                }
                
                break;
                
            default:
                
                break
            }
            
        } else {
            
            var info: Info;
            
            info = items[indexPath.row];
            
            if (info.getId() == Constants.INFO_URL) {
                
                UIApplication.shared.open(URL(string: info.getTitle())!)
            }
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        
        let imageView = gesture.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func dismissFullscreenImage(gesture: UIGestureRecognizer) {
        
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        gesture.view?.removeFromSuperview()
    }
    
    func friendsRemove(profileId: Int) {
        
        self.serverRequestStart();
        
        var request = URLRequest(url: URL(string: Constants.METHOD_FRIENDS_REMOVE)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&friendId=" + String(profileId);
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
                DispatchQueue.main.async() {
                    
                    self.serverRequestEnd();
                }
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        self.profile.setFriend(friend: false)
                    }
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();
                        
                        self.updateProfile();
                    }
                    
                } catch let error2 as NSError {
                    
                    print(error2.localizedDescription)
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();
                    }
                }
            }
            
        }).resume();
    }
    
    func friendsSendRequest(profileId: Int) {
        
        self.serverRequestStart();
        
        var request = URLRequest(url: URL(string: Constants.METHOD_FRIENDS_SEND_REQUEST)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&profileId=" + String(profileId);
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
                DispatchQueue.main.async() {
                    
                    self.serverRequestEnd();
                }
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        if (self.profile.isFollow()) {
                            
                            self.profile.setFollow(follow: false)
                            
                        } else {
                            
                            self.profile.setFollow(follow: true)
                        }
                    }
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();
                        
                        self.updateProfile();
                    }
                    
                } catch let error2 as NSError {
                    
                    print(error2.localizedDescription)
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();
                    }
                }
            }
            
        }).resume();
    }
    
    func follow(profileId: Int) {
        
        self.serverRequestStart();
        
        var request = URLRequest(url: URL(string: Constants.METHOD_PROFILE_FOLLOW)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&profileId=" + String(profileId);
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
                DispatchQueue.main.async() {
                    
                    self.serverRequestEnd();
                }
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        self.profile.setFollow(follow: response["follow"] as! Bool)
                        self.profile.setFollowersCount(followersCount: Int((response["followersCount"] as? String)!)!)
                    }
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();
                        
                        self.updateProfile();
                    }
                    
                } catch let error2 as NSError {
                    
                    print(error2.localizedDescription)
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();
                    }
                }
            }
            
        }).resume();
    }
    
    func unblock(profileId: Int) {
        
        self.serverRequestStart();
        
        var request = URLRequest(url: URL(string: Constants.METHOD_BLACKLIST_REMOVE)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&profileId=" + String(profileId);
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
                DispatchQueue.main.async() {
                    
                    self.serverRequestEnd();
                }
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        self.profile.setBlocked(blocked: false)
                    }
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();
                    }
                    
                } catch let error2 as NSError {
                    
                    print(error2.localizedDescription)
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();
                    }
                }
            }
            
        }).resume();
        
    }
    
    func block(profileId: Int) {
        
        self.serverRequestStart();
        
        var request = URLRequest(url: URL(string: Constants.METHOD_BLACKLIST_ADD)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&profileId=" + String(profileId);
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
                DispatchQueue.main.async() {
                    
                    self.serverRequestEnd();
                }
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        self.profile.setBlocked(blocked: true)
                    }
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();
                    }
                    
                } catch let error2 as NSError {
                    
                    print(error2.localizedDescription)
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();
                    }
                }
            }
            
        }).resume();
    }
    
    func report(profileId: Int, abuseId: Int) {
        
        self.serverRequestStart();
        
        var request = URLRequest(url: URL(string: Constants.METHOD_REPORT_NEW)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&itemId=" + String(profileId) + "&abuseId=" + String(abuseId) + "&itemType=" + String(Constants.REPORT_TYPE_PROFILE);
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
                DispatchQueue.main.async() {
                    
                    self.serverRequestEnd();
                }
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        // ;)
                    }
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();
                    }
                    
                } catch let error2 as NSError {
                    
                    print(error2.localizedDescription)
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();
                    }
                }
            }
            
        }).resume();
    }
    
    func serverRequestStart() {
        
        LoadingIndicatorView.show(NSLocalizedString("label_loading", comment: ""));
    }
    
    func serverRequestEnd() {
        
        LoadingIndicatorView.hide();
    }
    
    
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}
