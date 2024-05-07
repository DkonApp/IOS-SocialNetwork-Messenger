//
//  TabBarController.swift
//
//  Created by Demyanchuk Dmitry on 30.01.17.
//  Copyright © 2019 raccoonsqare@gmail.com All rights reserved.
//

import UIKit

import GoogleMobileAds


class TabBarController: UITabBarController, GADBannerViewDelegate {
    
    @IBOutlet weak var mTabBar: UITabBar!
    
    var bannerView: GADBannerView!

    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if (iApp.sharedInstance.getFcmRegId().count != 0) {
            
            print("Set Device Token")
            
            self.setDeviceToken()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateBadges), name: NSNotification.Name(rawValue: "updateBadges"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateAdmobBanner), name: NSNotification.Name(rawValue: "updateAdmobBanner"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideAdmobBanner), name: NSNotification.Name(rawValue: "hideAdmobBanner"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showAdmobBanner), name: NSNotification.Name(rawValue: "showAdmobBanner"), object: nil)
        
        updateBadges();
        
        getSettings();
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        
        addBannerViewToView(bannerView)
        
        bannerView.adUnitID = NSLocalizedString("admob_banner_id", comment: "")
        bannerView.rootViewController = self
        bannerView.load(GADRequest())        
        
        bannerView.delegate = self
        
        updateAdmobBanner();
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        
        
        bannerView.translatesAutoresizingMaskIntoConstraints = false
    
        
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: self.tabBar,
                                attribute: .top,
                                multiplier: 1,
                                constant: self.mTabBar.frame.size.height - 49),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        
        addBannerViewToView(bannerView)
    }

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
      print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
      print("bannerViewDidRecordImpression")
    }

    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillPresentScreen")
    }

    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillDIsmissScreen")
    }

    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewDidDismissScreen")
    }
    
    @objc func updateAdmobBanner() {
        
        print("update banner notify")
        
        if (iApp.sharedInstance.getAdmob() == 1) {
            
            self.bannerView.isHidden = false;
            
        } else {
            
            self.bannerView.isHidden = true;
        }
    }
    
    @objc func hideAdmobBanner() {
        
        print("hide banner")
        
        self.bannerView.isHidden = true;
    }
    
    @objc func showAdmobBanner() {
        
        print("show banner")
        
        self.bannerView.isHidden = false;
    }
    
    @objc func updateBadges() {
        
        print("update badges notify")
        
        if (iApp.sharedInstance.getNotificationsCount() > 0) {
            
            self.tabBar.items?[1].badgeValue = String(iApp.sharedInstance.getNotificationsCount())
            
        } else {
            
            self.tabBar.items?[1].badgeValue = nil
        }
        
        if (iApp.sharedInstance.getMessagesCount() > 0) {
            
            self.tabBar.items?[2].badgeValue = String(iApp.sharedInstance.getMessagesCount())
            
        } else {
            
            self.tabBar.items?[2].badgeValue = nil
        }
    }
    
    func setDeviceToken() {
        
        var request = URLRequest(url: URL(string: Constants.METHOD_ACCOUNT_SET_DEVICE_TOKEN)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&fcm_regId=" + iApp.sharedInstance.getFcmRegId();
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        // print(response)
                    }
                    
                } catch let error2 as NSError {
                    
                    print(error2.localizedDescription)
                }
            }
            
        }).resume();
    }
    
    func getSettings() {
        
        var request = URLRequest(url: URL(string: Constants.METHOD_ACCOUNT_GET_SETTINGS)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken();
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        iApp.sharedInstance.setMessagesCount(messagesCount: (response["messagesCount"] as? Int)!)
                        
                        if let notificationsCount = response["notificationsCount"] as? String {
                            
                            iApp.sharedInstance.setNotificationsCount(notificationsCount: Int(notificationsCount)!)
                            
                        } else {
                            
                            iApp.sharedInstance.setNotificationsCount(notificationsCount: (response["notificationsCount"] as! Int))
                        }
                    }
                    
                    DispatchQueue.main.async() {
                        
                        self.updateBadges()
                    }
                    
                } catch let error2 as NSError {
                    
                    print(error2.localizedDescription)
                }
            }
            
        }).resume();
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}
