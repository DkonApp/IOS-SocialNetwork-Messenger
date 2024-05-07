//
//  UpgradesController.swift
//  SocialNetwork
//
//  Created by Demyanchuk Dmitry on 03.02.17.
//  Copyright © 2019 raccoonsquare@gmail.com All rights reserved.
//

import UIKit

class UpgradesController: UITableViewController {
    
//    static let GHOST_MODE_COST = 100;
//    static let VERIFIED_BADGE_COST = 150;
//    static let DISABLE_ADS_COST = 200;

    override func viewDidLoad() {
        
        super.viewDidLoad()

        update()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        switch section {
            
        case 0:
            
            return 1
            
        case 1:
            
            return 1
            
        default:
            
            return 1
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Verified
        
        if (indexPath.section == 0 && indexPath.row == 0) {
            
            if (iApp.sharedInstance.getVerified() == 0) {
                
                if (iApp.sharedInstance.getBalance() < Constants.VERIFIED_BADGE_COST) {
                    
                    let alert = UIAlertController(title: NSLocalizedString("label_balance", comment: ""), message: NSLocalizedString("label_you_balance_null", comment: ""), preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    
                    self.upgrade(upgradeType: Constants.PA_BUY_VERIFIED_BADGE, credits: Constants.VERIFIED_BADGE_COST)
                }
            }
        }
        
        // Ghost
        
        if (indexPath.section == 1 && indexPath.row == 0) {
            
            if (iApp.sharedInstance.getGhost() == 0) {
                
                if (iApp.sharedInstance.getBalance() < Constants.GHOST_MODE_COST) {
                    
                    let alert = UIAlertController(title: NSLocalizedString("label_balance", comment: ""), message: NSLocalizedString("label_you_balance_null", comment: ""), preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    
                    self.upgrade(upgradeType: Constants.PA_BUY_GHOST_MODE, credits: Constants.GHOST_MODE_COST)
                }
            }
        }
        
        // Admob
        
        if (indexPath.section == 2 && indexPath.row == 0) {
            
            if (iApp.sharedInstance.getAdmob() == 1) {
                
                if (iApp.sharedInstance.getBalance() < Constants.DISABLE_ADS_COST) {
                    
                    let alert = UIAlertController(title: NSLocalizedString("label_balance", comment: ""), message: NSLocalizedString("label_you_balance_null", comment: ""), preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    
                    self.upgrade(upgradeType: Constants.PA_BUY_DISABLE_ADS, credits: Constants.DISABLE_ADS_COST)
                }
            }
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        update();
    }
    
    func update() {
        
        if (iApp.sharedInstance.getVerified() == 1) {
            
            let cell:UITableViewCell? = tableView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath)
            cell?.detailTextLabel?.text = "";
            cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
            
        } else {
            
            let cell:UITableViewCell? = tableView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath)
            cell?.detailTextLabel?.text = NSLocalizedString("action_enable", comment: "") + " (" + String(Constants.VERIFIED_BADGE_COST) + ")";
        }
        
        if (iApp.sharedInstance.getGhost() == 1) {
            
            let cell:UITableViewCell? = tableView.cellForRow(at: NSIndexPath(row: 0, section: 1) as IndexPath)
            cell?.detailTextLabel?.text = "";
            cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
            
        } else {
            
            let cell:UITableViewCell? = tableView.cellForRow(at: NSIndexPath(row: 0, section: 1) as IndexPath)
            cell?.detailTextLabel?.text = NSLocalizedString("action_enable", comment: "") + " (" + String(Constants.GHOST_MODE_COST) + ")";
        }
        
        if (iApp.sharedInstance.getAdmob() == 0) {
            
            let cell:UITableViewCell? = tableView.cellForRow(at: NSIndexPath(row: 0, section: 2) as IndexPath)
            cell?.detailTextLabel?.text = "";
            cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
            
        } else {
            
            let cell:UITableViewCell? = tableView.cellForRow(at: NSIndexPath(row: 0, section: 2) as IndexPath)
            cell?.detailTextLabel?.text = NSLocalizedString("action_enable", comment: "") + " (" + String(Constants.DISABLE_ADS_COST) + ")";
        }
    }
    
    
    func upgrade(upgradeType: Int, credits: Int) {
        
        self.serverRequestStart();
        
        var request = URLRequest(url: URL(string: Constants.METHOD_ACCOUNT_UPGRADE)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&credits=" + String(credits) + "&upgradeType=" + String(upgradeType);
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
                        
                        switch (upgradeType) {
                            
                            case Constants.PA_BUY_VERIFIED_BADGE:
                                
                                iApp.sharedInstance.setBalance(balance: iApp.sharedInstance.getBalance() - credits)
                                
                                iApp.sharedInstance.setVerified(verified: 1)
                            
                                break;
                            
                            
                            case Constants.PA_BUY_GHOST_MODE:
                                
                                iApp.sharedInstance.setBalance(balance: iApp.sharedInstance.getBalance() - credits)
                                
                                iApp.sharedInstance.setGhost(ghost: 1)
                                
                                break;
                            
                            
                            case Constants.PA_BUY_DISABLE_ADS:
                                
                                iApp.sharedInstance.setBalance(balance: iApp.sharedInstance.getBalance() - credits)
                                
                                iApp.sharedInstance.setAdmob(admob: 0)
                            
                                break;
                        
                            default:
                                
                                break;
                        }
                    }
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.serverRequestEnd();
                        
                        self.update();
                    })
                    
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
