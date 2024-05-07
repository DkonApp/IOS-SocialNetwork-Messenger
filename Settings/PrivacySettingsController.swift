//
//  PrivacySettingsController.swift
//
//  Created by Demyanchuk Dmitry on 30.01.17.
//  Copyright © 2017 qascript@mail.ru All rights reserved.
//

import UIKit

class PrivacySettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // add footer to delete empty cell's
        
        self.tableView.tableFooterView = UIView()
        
        // add tableview delegate
        
        tableView.delegate = self
        tableView.dataSource = self

        
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "PrivacyCell")!
    
        cell?.selectionStyle = .default
        
        switch indexPath.row {
            
        case 0:
            
            cell?.textLabel?.text  = NSLocalizedString("label_privacy_messages", comment: "")
            cell?.detailTextLabel?.text = self.getAllowMessagesText()
            
            break
            
        case 1:
            
            cell?.textLabel?.text  = NSLocalizedString("label_privacy_items_comments", comment: "")
            cell?.detailTextLabel?.text = self.getAllowCommentsText()
            
            break
            
        case 2:
            
            cell?.textLabel?.text  = NSLocalizedString("label_privacy_gallery_comments", comment: "")
            cell?.detailTextLabel?.text = self.getAllowGalleryCommentsText();
            
            break
            
        case 3:
            
            cell?.textLabel?.text  = NSLocalizedString("label_privacy_photos", comment: "")
            cell?.detailTextLabel?.text = self.getAllowText(option: iApp.sharedInstance.getAllowShowMyPhotos());
            
            break
            
        case 4:
            
            cell?.textLabel?.text  = NSLocalizedString("label_privacy_videos", comment: "")
            cell?.detailTextLabel?.text = self.getAllowText(option: iApp.sharedInstance.getAllowShowMyVideos());
            
            break
            
        case 5:
            
            cell?.textLabel?.text  = NSLocalizedString("label_privacy_friends", comment: "")
            cell?.detailTextLabel?.text = self.getAllowText(option: iApp.sharedInstance.getAllowShowMyFriends());
            
            break
            
        case 6:
            
            cell?.textLabel?.text  = NSLocalizedString("label_privacy_gifts", comment: "")
            cell?.detailTextLabel?.text = self.getAllowText(option: iApp.sharedInstance.getAllowShowMyGifts());
            
            break
            
        default:
            
            cell?.textLabel?.text  = NSLocalizedString("label_privacy_info", comment: "")
            cell?.detailTextLabel?.text = self.getAllowText(option: iApp.sharedInstance.getAllowShowMyInfo());
            
            break
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
            
            case 0:
            
                
                let alertController = UIAlertController(title: NSLocalizedString("label_privacy_messages", comment: ""), message: nil, preferredStyle: .actionSheet)
                
                let cancelAction = UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: .cancel) { action in
                    
                }
                
                alertController.addAction(cancelAction)
                
                let fromAllAction = UIAlertAction(title: NSLocalizedString("action_from_all", comment: ""), style: .default) { action in
                    
                    self.setAllowMessages(allowMessages: 1)
                }
                
                alertController.addAction(fromAllAction)
                
                let fromFriendsAction = UIAlertAction(title: NSLocalizedString("action_from_friends", comment: ""), style: .default) { action in
                    
                    self.setAllowMessages(allowMessages: 0)
                }
                
                alertController.addAction(fromFriendsAction)
                
                if let popoverController = alertController.popoverPresentationController {
                    
                    popoverController.sourceView = tableView.cellForRow(at: indexPath)
                    popoverController.sourceRect = (tableView.cellForRow(at: indexPath)?.bounds)!
                    popoverController.permittedArrowDirections = UIPopoverArrowDirection.any
                }
                
                self.present(alertController, animated: true, completion: nil)
                
                break
            
            case 1:
                
                let alertController = UIAlertController(title: NSLocalizedString("label_privacy_items_comments", comment: ""), message: nil, preferredStyle: .actionSheet)
                
                let cancelAction = UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: .cancel) { action in
                    
                }
                
                alertController.addAction(cancelAction)
                
                let disableAction = UIAlertAction(title: NSLocalizedString("action_off", comment: ""), style: .default) { action in
                    
                    self.setAllowComments(allowComments: 0)
                }
                
                alertController.addAction(disableAction)
                
                let allowAction = UIAlertAction(title: NSLocalizedString("action_on", comment: ""), style: .default) { action in
                    
                    self.setAllowComments(allowComments: 1)
                }
                
                alertController.addAction(allowAction)
                
                if let popoverController = alertController.popoverPresentationController {
                    
                    popoverController.sourceView = tableView.cellForRow(at: indexPath)
                    popoverController.sourceRect = (tableView.cellForRow(at: indexPath)?.bounds)!
                    popoverController.permittedArrowDirections = UIPopoverArrowDirection.any
                }
                
                self.present(alertController, animated: true, completion: nil)
            
                break
            
            case 2:
                
                let alertController = UIAlertController(title: NSLocalizedString("label_privacy_gallery_comments", comment: ""), message: nil, preferredStyle: .actionSheet)
                
                let cancelAction = UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: .cancel) { action in
                    
                }
                
                alertController.addAction(cancelAction)
                
                let disableAction = UIAlertAction(title: NSLocalizedString("action_off", comment: ""), style: .default) { action in
                    
                    self.setAllowGalleryComments(allowGalleryComments: 0)
                }
                
                alertController.addAction(disableAction)
                
                let allowAction = UIAlertAction(title: NSLocalizedString("action_on", comment: ""), style: .default) { action in
                    
                    self.setAllowGalleryComments(allowGalleryComments: 1)
                }
                
                alertController.addAction(allowAction)
                
                if let popoverController = alertController.popoverPresentationController {
                    
                    popoverController.sourceView = tableView.cellForRow(at: indexPath)
                    popoverController.sourceRect = (tableView.cellForRow(at: indexPath)?.bounds)!
                    popoverController.permittedArrowDirections = UIPopoverArrowDirection.any
                }
                
                self.present(alertController, animated: true, completion: nil)
            
                break
            
        case 3:
            
            let alertController = UIAlertController(title: NSLocalizedString("label_privacy_photos", comment: ""), message: nil, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: .cancel) { action in
                
            }
            
            alertController.addAction(cancelAction)
            
            let disableAction = UIAlertAction(title: NSLocalizedString("action_off", comment: ""), style: .default) { action in
                
                iApp.sharedInstance.setAllowShowMyPhotos(allowShowMyPhotos: 0)
                self.setPrivacySettings()
            }
            
            alertController.addAction(disableAction)
            
            let allowAction = UIAlertAction(title: NSLocalizedString("action_on", comment: ""), style: .default) { action in
                
                iApp.sharedInstance.setAllowShowMyPhotos(allowShowMyPhotos: 1)
                self.setPrivacySettings()
            }
            
            alertController.addAction(allowAction)
            
            if let popoverController = alertController.popoverPresentationController {
                
                popoverController.sourceView = tableView.cellForRow(at: indexPath)
                popoverController.sourceRect = (tableView.cellForRow(at: indexPath)?.bounds)!
                popoverController.permittedArrowDirections = UIPopoverArrowDirection.any
            }
            
            self.present(alertController, animated: true, completion: nil)
            
            break
            
        case 4:
            
            let alertController = UIAlertController(title: NSLocalizedString("label_privacy_videos", comment: ""), message: nil, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: .cancel) { action in
                
            }
            
            alertController.addAction(cancelAction)
            
            let disableAction = UIAlertAction(title: NSLocalizedString("action_off", comment: ""), style: .default) { action in
                
                iApp.sharedInstance.setAllowShowMyVideos(allowShowMyVideos: 0)
                self.setPrivacySettings()
            }
            
            alertController.addAction(disableAction)
            
            let allowAction = UIAlertAction(title: NSLocalizedString("action_on", comment: ""), style: .default) { action in
                
                iApp.sharedInstance.setAllowShowMyVideos(allowShowMyVideos: 1)
                self.setPrivacySettings()
            }
            
            alertController.addAction(allowAction)
            
            if let popoverController = alertController.popoverPresentationController {
                
                popoverController.sourceView = tableView.cellForRow(at: indexPath)
                popoverController.sourceRect = (tableView.cellForRow(at: indexPath)?.bounds)!
                popoverController.permittedArrowDirections = UIPopoverArrowDirection.any
            }
            
            self.present(alertController, animated: true, completion: nil)
            
            break
            
        case 5:
            
            let alertController = UIAlertController(title: NSLocalizedString("label_privacy_friends", comment: ""), message: nil, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: .cancel) { action in
                
            }
            
            alertController.addAction(cancelAction)
            
            let disableAction = UIAlertAction(title: NSLocalizedString("action_off", comment: ""), style: .default) { action in
                
                iApp.sharedInstance.setAllowShowMyFriends(allowShowMyFriends: 0)
                self.setPrivacySettings()
            }
            
            alertController.addAction(disableAction)
            
            let allowAction = UIAlertAction(title: NSLocalizedString("action_on", comment: ""), style: .default) { action in
                
                iApp.sharedInstance.setAllowShowMyFriends(allowShowMyFriends: 1)
                self.setPrivacySettings()
            }
            
            alertController.addAction(allowAction)
            
            if let popoverController = alertController.popoverPresentationController {
                
                popoverController.sourceView = tableView.cellForRow(at: indexPath)
                popoverController.sourceRect = (tableView.cellForRow(at: indexPath)?.bounds)!
                popoverController.permittedArrowDirections = UIPopoverArrowDirection.any
            }
            
            self.present(alertController, animated: true, completion: nil)
            
            break
            
        case 6:
            
            let alertController = UIAlertController(title: NSLocalizedString("label_privacy_gifts", comment: ""), message: nil, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: .cancel) { action in
                
            }
            
            alertController.addAction(cancelAction)
            
            let disableAction = UIAlertAction(title: NSLocalizedString("action_off", comment: ""), style: .default) { action in
                
                iApp.sharedInstance.setAllowShowMyGifts(allowShowMyGifts: 0)
                self.setPrivacySettings()
            }
            
            alertController.addAction(disableAction)
            
            let allowAction = UIAlertAction(title: NSLocalizedString("action_on", comment: ""), style: .default) { action in
                
                iApp.sharedInstance.setAllowShowMyGifts(allowShowMyGifts: 1)
                self.setPrivacySettings()
            }
            
            alertController.addAction(allowAction)
            
            if let popoverController = alertController.popoverPresentationController {
                
                popoverController.sourceView = tableView.cellForRow(at: indexPath)
                popoverController.sourceRect = (tableView.cellForRow(at: indexPath)?.bounds)!
                popoverController.permittedArrowDirections = UIPopoverArrowDirection.any
            }
            
            self.present(alertController, animated: true, completion: nil)
            
            break
            
        default:
            
            let alertController = UIAlertController(title: NSLocalizedString("label_privacy_info", comment: ""), message: nil, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: .cancel) { action in
                
            }
            
            alertController.addAction(cancelAction)
            
            let disableAction = UIAlertAction(title: NSLocalizedString("action_off", comment: ""), style: .default) { action in
                
                iApp.sharedInstance.setAllowShowMyInfo(allowShowMyInfo: 0)
                self.setPrivacySettings()
            }
            
            alertController.addAction(disableAction)
            
            let allowAction = UIAlertAction(title: NSLocalizedString("action_on", comment: ""), style: .default) { action in
                
                iApp.sharedInstance.setAllowShowMyInfo(allowShowMyInfo: 1)
                self.setPrivacySettings()
            }
            
            alertController.addAction(allowAction)
            
            if let popoverController = alertController.popoverPresentationController {
                
                popoverController.sourceView = tableView.cellForRow(at: indexPath)
                popoverController.sourceRect = (tableView.cellForRow(at: indexPath)?.bounds)!
                popoverController.permittedArrowDirections = UIPopoverArrowDirection.any
            }
            
            self.present(alertController, animated: true, completion: nil)
            
            break
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func getAllowMessagesText()->String {
        
        if (iApp.sharedInstance.getAllowMessages() == 1) {
            
            return NSLocalizedString("action_from_all", comment: "")
            
        } else {
            
            return NSLocalizedString("action_from_friends", comment: "")
        }
    }
    
    func getAllowGalleryCommentsText()->String {
        
        if (iApp.sharedInstance.getAllowGalleryComments() == 1) {
            
            return NSLocalizedString("action_on", comment: "")
            
        } else {
            
            return NSLocalizedString("action_off", comment: "")
        }
    }
    
    func getAllowCommentsText()->String {
        
        if (iApp.sharedInstance.getAllowComments() == 1) {
            
            return NSLocalizedString("action_on", comment: "")
            
        } else {
            
            return NSLocalizedString("action_off", comment: "")
        }
    }
    
    func getAllowText(option: Int)->String {
        
        if (option == 0) {
            
            return NSLocalizedString("action_off", comment: "")
            
        } else {
            
            return NSLocalizedString("action_on", comment: "")
        }
    }
    
    func setPrivacySettings() {
        
        self.serverRequestStart()
        
        var request = URLRequest(url: URL(string: Constants.METHOD_PRIVACY_SETTINGS)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&allowShowMyPhotos=" + String(iApp.sharedInstance.getAllowShowMyPhotos()) + "&allowShowMyGifts=" + String(iApp.sharedInstance.getAllowShowMyGifts()) + "&allowShowMyFriends=" + String(iApp.sharedInstance.getAllowShowMyFriends()) + "&allowShowMyVideos=" + String(iApp.sharedInstance.getAllowShowMyVideos()) + "&allowShowMyInfo=" + String(iApp.sharedInstance.getAllowShowMyInfo());
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
                DispatchQueue.main.async(execute: {
                    
                    self.serverRequestEnd()
                })
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        iApp.sharedInstance.setAllowShowMyPhotos(allowShowMyPhotos: (response["allowShowMyPhotos"] as AnyObject).integerValue)
                        iApp.sharedInstance.setAllowShowMyGifts(allowShowMyGifts: (response["allowShowMyGifts"] as AnyObject).integerValue)
                        iApp.sharedInstance.setAllowShowMyFriends(allowShowMyFriends: (response["allowShowMyFriends"] as AnyObject).integerValue)
                        iApp.sharedInstance.setAllowShowMyVideos(allowShowMyVideos: (response["allowShowMyVideos"] as AnyObject).integerValue)
                        iApp.sharedInstance.setAllowShowMyInfo(allowShowMyInfo: (response["allowShowMyInfo"] as AnyObject).integerValue)
                    }
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.serverRequestEnd()
                        
                        self.tableView.reloadData()
                    })
                    
                } catch let error2 as NSError {
                    
                    print(error2.localizedDescription)
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.serverRequestEnd()
                    })
                }
            }
            
        }).resume();
    }
    
    func setAllowMessages(allowMessages: Int) {
        
        self.serverRequestStart()
        
        var request = URLRequest(url: URL(string: Constants.METHOD_ACCOUNT_SET_ALLOW_MESSAGES)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&allowMessages=" + String(allowMessages);
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
                DispatchQueue.main.async(execute: {
                    
                    self.serverRequestEnd()
                })
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    print(response)
                    
                    if (responseError == false) {
                        
                        iApp.sharedInstance.setAllowMessages(allowMessages: (response["allowMessages"] as AnyObject).integerValue)
                    }
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.serverRequestEnd()
                        
                        self.tableView.reloadData()
                    })
                    
                } catch let error2 as NSError {
                    
                    print(error2.localizedDescription)
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.serverRequestEnd()
                    })
                }
            }
            
        }).resume();
    }
    
    func setAllowComments(allowComments: Int) {
        
        self.serverRequestStart()
        
        var request = URLRequest(url: URL(string: Constants.METHOD_ACCOUNT_SET_ALLOW_COMMENTS)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&allowComments=" + String(allowComments);
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
                DispatchQueue.main.async(execute: {
                    
                    self.serverRequestEnd()
                })
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        iApp.sharedInstance.setAllowComments(allowComments: (response["allowComments"] as AnyObject).integerValue)
                    }
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.serverRequestEnd()
                        
                        self.tableView.reloadData()
                    })
                    
                } catch let error2 as NSError {
                    
                    print(error2.localizedDescription)
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.serverRequestEnd()
                    })
                }
            }
            
        }).resume();
    }
    
    func setAllowGalleryComments(allowGalleryComments: Int) {
        
        self.serverRequestStart()
        
        var request = URLRequest(url: URL(string: Constants.METHOD_ACCOUNT_SET_ALLOW_GALLERY_COMMENTS)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&allowGalleryComments=" + String(allowGalleryComments);
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
                DispatchQueue.main.async(execute: {
                    
                    self.serverRequestEnd()
                })
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        iApp.sharedInstance.setAllowGalleryComments(allowGalleryComments: (response["allowGalleryComments"] as AnyObject).integerValue)
                    }
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.serverRequestEnd()
                        
                        self.tableView.reloadData()
                    })
                    
                } catch let error2 as NSError {
                    
                    print(error2.localizedDescription)
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.serverRequestEnd()
                    })
                }
            }
            
        }).resume();
    }
    
    func serverRequestStart() {
        
        LoadingIndicatorView.show("Loading");
    }
    
    func serverRequestEnd() {
        
        LoadingIndicatorView.hide();
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}
