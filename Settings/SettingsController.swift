//
//  SettingsController.swift
//
//  Created by Demyanchuk Dmitry on 23.01.17.
//  Copyright © 2017 qascript@mai.ru All rights reserved.
//

import UIKit

class SettingsController: UITableViewController {
    
    @IBOutlet weak var logoutItem: UITableViewCell!
    
    var pageId: Int = 0
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if  (segue.identifier == "showProfile") {
            
            // Create a new variable to store the instance of ProfileController
            let destinationVC = segue.destination as! ProfileController
            destinationVC.profileId = iApp.sharedInstance.getId()
            
        } else if (segue.identifier == "showItems") {
            
            // Create a new variable to store the instance of ItemsController
            let destinationVC = segue.destination as! ItemsController
            destinationVC.profileId = iApp.sharedInstance.getId()
            destinationVC.pageId = self.pageId
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        switch section {
            
            case 0:
            
                return 7
            
            case 1:
            
                return 10
        
            default:
        
                return 1
        
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Stream
        
        if (indexPath.section == 0 && indexPath.row == 1) {
         
            self.pageId = Constants.ITEMS_STREAM_PAGE
            self.performSegue(withIdentifier: "showItems", sender: self)
        }
        
        // Favorites
        
        if (indexPath.section == 0 && indexPath.row == 2) {
            
            self.pageId = Constants.ITEMS_FAVORITES_PAGE
            self.performSegue(withIdentifier: "showItems", sender: self)
        }
        
        // logout
        
        if (indexPath.section == 2 && indexPath.row == 0) {
            
            let alertController = UIAlertController(title: nil, message: NSLocalizedString("alert_logout", comment: ""), preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("action_no", comment: ""), style: .cancel) { action in
                
                
            }
            
            alertController.addAction(cancelAction)
            
            let yesAction = UIAlertAction(title: NSLocalizedString("action_yes", comment: ""), style: .default) { action in
                
                self.logout(accountId: iApp.sharedInstance.getId(), accessToken: iApp.sharedInstance.getAccessToken());
            }
            
            alertController.addAction(yesAction)
            
            if let popoverController = alertController.popoverPresentationController {
                
                popoverController.sourceView = tableView.cellForRow(at: indexPath)
                popoverController.sourceRect = (tableView.cellForRow(at: indexPath)?.bounds)!
                popoverController.permittedArrowDirections = UIPopoverArrowDirection.any
            }
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

    
    func logout(accountId: Int, accessToken: String) {
        
        self.serverRequestStart();
        
        var request = URLRequest(url: URL(string: Constants.METHOD_ACCOUNT_LOGOUT)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=\(accountId)" + "&accessToken=" + accessToken;
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
                        
                        iApp.sharedInstance.logout();
                        
                        DispatchQueue.global(qos: .background).async {
                            
                            DispatchQueue.main.async {
                                
                                let storyboard = UIStoryboard(name: "Main", bundle: nil);
                                let vc = storyboard.instantiateViewController(withIdentifier: "AppController");
                                
                                vc.modalPresentationStyle = .fullScreen
                                
                                self.present(vc, animated: true, completion: nil);
                            }
                        }
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
        
        LoadingIndicatorView.show("Loading");
    }
    
    func serverRequestEnd() {
        
        LoadingIndicatorView.hide();
    }

}
