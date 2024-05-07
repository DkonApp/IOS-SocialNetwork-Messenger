//
//  GroupController.swift
//
//  Created by Demyancuk Dmitry on 01.03.17.
//  Copyright © 2017 qascript@mail.ru All rights reserved.
//

import UIKit

class GroupController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var verifiedView: UIImageView!
    @IBOutlet weak var coverView: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorView: UILabel!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    var items = [Info]()
    
    var menuButton = UIBarButtonItem()
    var refreshControl = UIRefreshControl()
    
    var onload: Bool = false;
    
    var profile = Group();
    
    var profileId: Int = 0
    
    
    var itemId: Int = 0;
    var itemsLoaded: Int = 0;
    
    var loadMoreStatus = false
    var loading = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        actionButton.isHidden = true;
        
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
        
        var request = URLRequest(url: URL(string: Constants.METHOD_GROUP_GET)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&groupId=" + String(profileId) + "&ios_fcm_regId=" + iApp.sharedInstance.getFcmRegId();
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
                        
                        self.profile = Group(Response: response as AnyObject)
                        
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
        
        if (self.profile.getWebPage().count > 0) {
            
            self.items.append(Info(id: Constants.INFO_URL, title: self.profile.getWebPage(), detail: "", image: UIImage(named: "ic_web_30")!))
        }
    }
    
    func updateProfile() {
        
        if (iApp.sharedInstance.getId() != self.profile.getId() && !onload && self.profile.getState() == Constants.ACCOUNT_STATE_ENABLED) {
            
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
        
        showActionButton()
        showPhoto()
    }
    
    
    @IBAction func actionButtonTap(_ sender: Any) {
        
        if (self.profile.getId() == iApp.sharedInstance.getId()) {
            
            self.performSegue(withIdentifier: "editGroup", sender: self)
            
        } else {
            
            if (self.profile.isFollow()) {
                
                self.follow(profileId: self.profile.getId())
                
            } else {
                
                self.follow(profileId: self.profile.getId())
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
            
            if (self.profile.isFollow()) {
                
                self.actionButton.isEnabled = true
                
                self.actionButton.setTitle(NSLocalizedString("action_unfollow", comment: ""), for: .normal)
                
            } else {
                
                self.actionButton.isEnabled = true
                
                self.actionButton.setTitle(NSLocalizedString("action_follow", comment: ""), for: .normal)
            }
        }
    }
    
    @objc func showMenu() {
        
        let alertController = UIAlertController(title: self.profile.getFullname(), message: self.profile.getUsername(), preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: .cancel) { action in
            
            
        }
        
        alertController.addAction(cancelAction)
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if  (segue.identifier == "editProfile") {
            
            //
            
        } else if (segue.identifier == "showItems") {
            
            let destinationVC = segue.destination as! ItemsController
            destinationVC.profileId = self.profile.getId()
            destinationVC.groupAuthor = self.profile.getAccountAuthor()
            destinationVC.allowPosts = self.profile.getAllowPosts()
            destinationVC.pageId = Constants.ITEMS_GROUP_PAGE
            
        } else if (segue.identifier == "showFollowers") {
            
            let destinationVC = segue.destination as! FollowersController
            destinationVC.profileId = self.profile.getId()
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
            
            return 2
            
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
                
                cell?.textLabel?.text  = NSLocalizedString("label_followers", comment: "")
                cell?.detailTextLabel?.text = String(self.profile.getFollowersCount())
                
                break;
                
            case 1:
                
                cell?.textLabel?.text  = NSLocalizedString("label_items", comment: "")
                cell?.detailTextLabel?.text = String(self.profile.getPostsCount())
                
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
                
                self.performSegue(withIdentifier: "showFollowers", sender: self)
                
                break;
                
            case 1:
                
                self.performSegue(withIdentifier: "showItems", sender: self)
                
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
    
    func follow(profileId: Int) {
        
        self.serverRequestStart();
        
        var request = URLRequest(url: URL(string: Constants.METHOD_GROUP_FOLLOW)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&groupId=" + String(profileId);
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
    
    func report(profileId: Int, abuseId: Int) {
        
        self.serverRequestStart();
        
        var request = URLRequest(url: URL(string: Constants.METHOD_REPORT_NEW)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&itemId=" + String(profileId) + "&abuseId=" + String(abuseId) + "&itemType=" + String(Constants.REPORT_TYPE_COMMUNITY);
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
