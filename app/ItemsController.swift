//
//  ItemsController.swift
//
//  Created by Demyanchuk Dmitry on 01.02.17.
//  Copyright © 2017 qascript@mail.ru All rights reserved.
//

import UIKit

class ItemsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var textMessageView: UILabel!
    
    var groupAuthor: Int = 0
    var allowPosts: Int = 0
    
    var profileId: Int = 0
    var pageId: Int = Constants.ITEMS_FEED_PAGE
    var postId: Int = 0;
    
    var refreshControl = UIRefreshControl()
    
    var items = [Item]()
    
    var itemId: Int = 0;
    var itemsLoaded: Int = 0;
    
    var loadMoreStatus = false
    var loading = false
    
    var videoUrl: String = "";

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if ((profileId == iApp.sharedInstance.getId() && pageId == Constants.ITEMS_PROFILE_PAGE) || pageId == Constants.ITEMS_FEED_PAGE || pageId == Constants.ITEMS_STREAM_PAGE) {
            
            let newItemButton = UIBarButtonItem(barButtonSystemItem: .add , target: self, action: #selector(newItem))
            self.navigationItem.rightBarButtonItem  = newItemButton
            
        } else if (groupAuthor == iApp.sharedInstance.getId() && pageId == Constants.ITEMS_GROUP_PAGE) {
            
            let newItemButton = UIBarButtonItem(barButtonSystemItem: .add , target: self, action: #selector(newItem))
            self.navigationItem.rightBarButtonItem  = newItemButton
            
        } else if (groupAuthor != iApp.sharedInstance.getId() && allowPosts == 1 && pageId == Constants.ITEMS_GROUP_PAGE) {
            
            let newItemButton = UIBarButtonItem(barButtonSystemItem: .add , target: self, action: #selector(newItem))
            self.navigationItem.rightBarButtonItem  = newItemButton
        }

        // add tableview delegate
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 65.0
        
        // add footer to delete empty cell's
        
        self.tableView.tableFooterView = UIView()
        
        // add refresh control
        
        self.refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        self.tableView.addSubview(refreshControl)
        self.tableView.alwaysBounceVertical = true
        
        // prepare for loading data
        
        self.showLoadingScreen()
        
        // start loading data
        
        self.loadData()
    }
    
    @objc func newItem() {
        
        self.performSegue(withIdentifier: "newItem", sender: self)
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
                
                self.loadData()
            }
            
            DispatchQueue.global().async  {
                
                refreshEnd(0)
            }
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if ((offsetY > contentHeight - scrollView.frame.size.height) && !loading && items.count >= Constants.LIST_ITEMS) {
            
            loadMore()
        }
    }
    
    func loadMore() {
        
        if (!loadMoreStatus) {
            
            self.loadMoreStatus = true
            
            loadMoreBegin(newtext: "Load more",
                          loadMoreEnd: {(x:Int) -> () in
                            self.tableView.reloadData()
                            self.loadMoreStatus = false
            })
        }
    }
    
    func loadMoreBegin(newtext:String, loadMoreEnd:@escaping (Int) -> ()) {
        
        self.loadData()
    }
    
    func loadData() {
        
        print(pageId)
        print(postId)
        print("group author" + String(self.groupAuthor))
        print("group allow posts" + String(self.allowPosts))
        
        switch pageId {
            
            case Constants.ITEMS_GROUP_PAGE:
                
                self.title = NSLocalizedString("label_group", comment: "")
                
                getItems(url: Constants.METHOD_GROUP_GET_WALL);
                
                break
                
            case Constants.ITEMS_FEED_PAGE:
                
                self.title = NSLocalizedString("label_feed", comment: "")
                
                getItems(url: Constants.METHOD_FEED_GET);
                
                break
                
            case Constants.ITEMS_STREAM_PAGE:
                
                self.title = NSLocalizedString("label_stream", comment: "")
                
                getItems(url: Constants.METHOD_STREAM_GET);
                
                break
                
            case Constants.ITEMS_FAVORITES_PAGE:
                
                self.title = NSLocalizedString("label_favorites", comment: "")
                
                getItems(url: Constants.METHOD_FAVORITES_GET);
                
                break
                
            case Constants.ITEMS_PROFILE_PAGE:
                
                self.title = NSLocalizedString("label_profile_items", comment: "")
                
                self.getProfileItems()
                
                break
                
            case Constants.ITEMS_GET_ITEM:
                
                self.title = NSLocalizedString("label_item", comment: "")
                
                self.getItem(itemId: self.postId)
                
                break
                
            default:
                
                break
        }
    }
    
    func getItem(itemId: Int) {
        
        loading = true;
        
        var request = URLRequest(url: URL(string: Constants.METHOD_ITEM_GET)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&ios_fcm_regId=" + iApp.sharedInstance.getFcmRegId() + "&itemId=" + String(itemId);
        
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
                DispatchQueue.main.async(execute: {
                    
                    self.loadingComplete()
                })
                
                return
            }
            
            do {
                
                //Get Response
                let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                
                //Get Error status
                let responseError = response["error"] as! Bool;
                
                //If error False - read data
                if (responseError == false) {
                    
                    //Get itemId
                    self.itemId = (response["itemId"] as AnyObject).integerValue
                    
                    //Get items array
                    let itemsArray = response["items"] as! [AnyObject]
                    
                    self.items.append(Item(Response: itemsArray[0] as AnyObject))
                    
                }
                
                DispatchQueue.main.async(execute: {
                    
                    self.loadingComplete()
                })
                
            } catch {
                
                DispatchQueue.main.async(execute: {
                    
                    self.loadingComplete()
                })
            }
            
        }).resume();
    }
    
    func getItems(url: String) {
        
//        self.textMessageView = nil
        
        loading = true;
        
        var request = URLRequest(url: URL(string: url)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&ios_fcm_regId=" + iApp.sharedInstance.getFcmRegId() + "&itemId=" + String(self.itemId) + "&profileId=" + String(self.profileId) + "&groupId=" + String(self.profileId);
        
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
                DispatchQueue.main.async(execute: {
                    
                    self.loadingComplete()
                })
                
                return
            }
            
            do {
                
                //Get Response
                let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                
                //Get Error status
                let responseError = response["error"] as! Bool;
                
                print(response)
                
                //If error False - read data
                if (responseError == false) {
                    
                    //Get itemId
                    self.itemId = (response["itemId"] as AnyObject).integerValue
                    
                    //Get items array
                    let itemsArray = response["items"] as! [AnyObject]
                    
                    //Items in array
                    self.itemsLoaded = itemsArray.count
                    
                    //Read items from array
                    for itemObj in itemsArray {
                        
                        //add item to adapter(array). insert to start | append to end
                        self.items.append(Item(Response: itemObj))
                    }
                }
                
                DispatchQueue.main.async(execute: {
                    
                    self.loadingComplete()
                })
                
            } catch {
                
                DispatchQueue.main.async(execute: {
                    
                    self.loadingComplete()
                })
            }
            
        }).resume();
    }
    
    func getProfileItems() {
        
        loading = true;
        
        var request = URLRequest(url: URL(string: Constants.METHOD_PROFILE_GET_ITEMS)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&ios_fcm_regId=" + iApp.sharedInstance.getFcmRegId() + "&itemId=" + String(self.itemId) + "&profileId=" + String(self.profileId);
        
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
                DispatchQueue.main.async(execute: {
                    
                    self.loadingComplete()
                })
                
                return
            }
            
            do {
                
                //Get Response
                let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                
                //Get Error status
                let responseError = response["error"] as! Bool;
                
                print(response)
                
                //If error False - read data
                if (responseError == false) {
                    
                    //Get itemId
                    self.itemId = (response["postId"] as AnyObject).integerValue
                    
                    //Get items array
                    let itemsArray = response["posts"] as! [AnyObject]
                    
                    //Items in array
                    self.itemsLoaded = itemsArray.count
                    
                    //Read items from array
                    for itemObj in itemsArray {
                        
                        //add item to adapter(array). insert to start | append to end
                        self.items.append(Item(Response: itemObj))
                    }
                }
                
                DispatchQueue.main.async(execute: {
                    
                    self.loadingComplete()
                })
                
            } catch {
                
                DispatchQueue.main.async(execute: {
                    
                    self.loadingComplete()
                })
            }
            
        }).resume();
    }
    
    func loadingComplete() {
        
        if (self.itemsLoaded >= Constants.LIST_ITEMS) {
            
            self.loadMoreStatus = false
            
        } else {
            
            self.loadMoreStatus = true
        }
        
        self.tableView.reloadData()
        self.loading = false
        
        if (self.items.count == 0) {
            
            self.showEmptyScreen()
            
        } else {
            
            self.showContentScreen()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if  (segue.identifier == "showProfile") {
            
            // Create a new variable to store the instance of ProfileController
            let destinationVC = segue.destination as! ProfileController
            destinationVC.profileId = self.tableView.tag
            
        } else if (segue.identifier == "showComments") {
            
            // Create a new variable to store the instance of ItemsCommentsController
            let destinationVC = segue.destination as! itemsCommentsController
            destinationVC.itemId = self.tableView.tag
            destinationVC.allowComments = self.loadingView.tag
            
        } else if (segue.identifier == "showGroup") {
            
            // Create a new variable to store the instance of GroupController
            let destinationVC = segue.destination as! GroupController
            destinationVC.profileId = self.tableView.tag
            
        } else if (segue.identifier == "showItem") {
            
            // Create a new variable to store the instance of ItemsController
            let destinationVC = segue.destination as! ItemsController
            destinationVC.postId = self.tableView.tag
            destinationVC.pageId = Constants.ITEMS_GET_ITEM
            
        } else if (segue.identifier == "newItem") {
            
            let destinationVC = segue.destination as? UINavigationController
            
            let newPost = destinationVC?.viewControllers.first as! ItemsNewController
            
            if (self.pageId == Constants.ITEMS_GROUP_PAGE) {
                
                newPost.groupId = self.profileId
            }
            
        } else if (segue.identifier == "playVideo") {
            
            let destinationVC = segue.destination as! ViewVideoController
            destinationVC.videoUrl = self.videoUrl
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView : UITableView,  titleForHeaderInSection section: Int) -> String? {
        
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        cell.photoView.tag = indexPath.row
        cell.pictureView.tag = indexPath.row
        cell.fullnameLabel.tag = indexPath.row
        
        cell.likeButton.tag = indexPath.row
        cell.commentButton.tag = indexPath.row
        cell.actionButton.tag = indexPath.row
        cell.showRepostButton.tag = indexPath.row
        
        var item: Item;
        
        item = items[indexPath.row];
        
        // Do any additional setup after loading the view.
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.likeTap(gesture:)) )
        let actionTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.actionTap(gesture:)) )
        let commentTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.commentTap(gesture:)) )
        let photoTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.photoTap(gesture:)) )
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(gesture:)))
        
        // add it to the image view;
        
        cell.likeButton.addGestureRecognizer(tapGesture)
        cell.actionButton.addGestureRecognizer(actionTapGesture)
        cell.commentButton.addGestureRecognizer(commentTapGesture)
        cell.photoView.addGestureRecognizer(photoTapGesture)
        cell.pictureView.addGestureRecognizer(imageTapGesture)
        
        // make sure imageView can be interacted with by user
        
        cell.likeButton.isUserInteractionEnabled = true
        cell.actionButton.isUserInteractionEnabled = true
        cell.commentButton.isUserInteractionEnabled = true
        cell.photoView.isUserInteractionEnabled = true
        cell.pictureView.isUserInteractionEnabled = true
        
        cell.fullnameLabel.text = item.getFullname()
        
        if (self.pageId == Constants.ITEMS_PROFILE_PAGE) {
            
            if (item.getPinned() == 0) {
                
                cell.timeAgoLabel.text = item.getTimeAgo()
                
            } else {
                
                cell.timeAgoLabel.text = item.getTimeAgo() + " | " + NSLocalizedString("label_item_pinned", comment: "");
            }
            
        } else {
            
            cell.timeAgoLabel.text = item.getTimeAgo()
        }
        
        if (item.getLikesCount() == 0) {
            
            cell.likesCountLabel.text = "0"
            cell.likesCountLabel.isHidden = true
            
        } else {
            
            cell.likesCountLabel.text = String(item.getLikesCount())
            cell.likesCountLabel.isHidden = false
        }
        
        if (item.getCommentsCount() == 0) {
            
            cell.commentsCountLabel.text = "0"
            cell.commentsCountLabel.isHidden = true
            
        } else {
            
            cell.commentsCountLabel.text = String(item.getCommentsCount())
            cell.commentsCountLabel.isHidden = false
        }
        
        if (item.isMyLike()) {
            
            cell.likeButton.image =  UIImage(named: "ic_like_active_30")
            
        } else {
            
            cell.likeButton.image =  UIImage(named: "ic_like_30")
        }
        
        cell.contentLabel.isHidden = true;
        
        if (item.getContent().count > 0) {
            
            cell.contentLabel.isHidden = false;
            cell.contentLabel.text = item.getContent()
        }
        
        // repost view button
        
        if (item.getRePostId() == 0) {
            
            cell.showRepostButton.isHidden = true
            cell.repostButtonHeight.constant = 0
            
        } else {
            
            cell.showRepostButton.isHidden = false
            
            cell.showRepostButton.addTarget(self, action: #selector(self.showRepostedItem), for: .touchUpInside)
        }
        
        // photo
        
        cell.photoView.layer.borderWidth = 1
        cell.photoView.layer.masksToBounds = false
        cell.photoView.layer.borderColor = UIColor.lightGray.cgColor
        cell.photoView.layer.cornerRadius = cell.photoView.frame.height/2
        cell.photoView.clipsToBounds = true
        
        cell.photoView.image = UIImage(named: "ic_profile_default_photo")
        
        if (item.getPhotoUrl().count == 0) {
            
            cell.photoView.image = UIImage(named: "ic_profile_default_photo")
            
        } else {
            
            if (iApp.sharedInstance.getCache().object(forKey: item.getPhotoUrl() as AnyObject) != nil) {
                
                cell.photoView.image = iApp.sharedInstance.getCache().object(forKey: item.getPhotoUrl() as AnyObject) as? UIImage
                
            } else {
                
                if (!item.photoLoading) {
                    
                    item.photoLoading = true;
                    
                    let imageUrlString = item.getPhotoUrl()
                    let imageUrl:URL = URL(string: imageUrlString)!
                    
                    DispatchQueue.global().async {
                        
                        let data = try? Data(contentsOf: imageUrl)
                        
                        DispatchQueue.main.async {
                            
                            if data != nil {
                                
                                let img = UIImage(data: data!)
                                
                                cell.photoView.image = img
                                
                                iApp.sharedInstance.getCache().setObject(img!, forKey: item.getPhotoUrl() as AnyObject)
                                
                                self.tableView.reloadData()
                            }
                        }
                    }
                    
                }
            }
        }
        
        if (item.getVideoUrl().count != 0) {
            
            cell.pictureView.isHidden = false
    
            cell.pictureView.image = UIImage(named: "ic_video_preview")
            
        } else {
            
            if (item.getImgUrl().count == 0) {
                
                cell.pictureView.isHidden = true
                cell.pictureViewHeight.constant = 0
                
            } else {
                
                cell.pictureView.isHidden = false
                
                if (iApp.sharedInstance.getCache().object(forKey: item.getImgUrl() as AnyObject) != nil) {
                    
                    cell.pictureView.image = iApp.sharedInstance.getCache().object(forKey: item.getImgUrl() as AnyObject) as? UIImage
                    
                } else {
                    
                    if (!item.imgLoading) {
                        
                        item.imgLoading = true;
                        
                        let imageUrlString = item.getImgUrl()
                        let imageUrl:URL = URL(string: imageUrlString)!
                        
                        DispatchQueue.global().async {
                            
                            let data = try? Data(contentsOf: imageUrl)
                            
                            DispatchQueue.main.async {
                                
                                if data != nil {
                                    
                                    let img = UIImage(data: data!)
                                    
                                    cell.pictureView.image = img
                                    
                                    iApp.sharedInstance.getCache().setObject(img!, forKey: item.getImgUrl() as AnyObject)
                                    
                                    self.tableView.reloadData()
                                }
                            }
                        }
                        
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        
        if let imageView = gesture.view as? UIImageView {
            
            if (self.items[imageView.tag].getVideoUrl().count != 0) {
            
                self.videoUrl = self.items[imageView.tag].getVideoUrl();
                self.performSegue(withIdentifier: "playVideo", sender: self);
                
            } else {
                
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
        }
    }
    
    @objc func dismissFullscreenImage(gesture: UIGestureRecognizer) {
        
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        gesture.view?.removeFromSuperview()
    }
    
    @objc func showRepostedItem(sender: UIButton!) {
        
        let storyboard = UIStoryboard(name: "Content", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "ItemsController") as! ItemsController
        
        destination.postId = self.items[sender.tag].getRePostId()
        destination.pageId = Constants.ITEMS_GET_ITEM
        
        navigationController?.pushViewController(destination, animated: true)
    }
    
    @objc func photoTap(gesture: UIGestureRecognizer) {
        
        if let imageView = gesture.view as? UIImageView {
            
            if (self.items[imageView.tag].getGroupId() != 0) {
                
                self.tableView.tag = self.items[imageView.tag].getGroupId()
                
                self.performSegue(withIdentifier: "showGroup", sender: self)
                
                
            } else {
                
                self.tableView.tag = self.items[imageView.tag].getFromUserId()
                
                self.performSegue(withIdentifier: "showProfile", sender: self)
            }
        }
    }
    
    @objc func commentTap(gesture: UIGestureRecognizer) {
        
        if let imageView = gesture.view as? UIImageView {
            
            self.tableView.tag = self.items[imageView.tag].getId()
            self.loadingView.tag = self.items[imageView.tag].getAllowComments()
            
            self.performSegue(withIdentifier: "showComments", sender: self)
        }
    }
    
    @objc func likeTap(gesture: UIGestureRecognizer) {
        
        if let imageView = gesture.view as? UIImageView {
            
            if (self.items[imageView.tag].isMyLike()) {
                
                self.items[imageView.tag].setMyLike(myLike: false)
                self.items[imageView.tag].setLikesCount(likesCount: self.items[imageView.tag].getLikesCount() - 1)
                
                self.tableView.reloadData()
                
            } else {
                
                self.items[imageView.tag].setMyLike(myLike: true)
                self.items[imageView.tag].setLikesCount(likesCount: self.items[imageView.tag].getLikesCount() + 1)
                
                self.tableView.reloadData()
            }
            
            self.like(itemId: self.items[imageView.tag].getId(), index: imageView.tag)

        }
    }
    
    @objc func actionTap(gesture: UIGestureRecognizer) {
        
        if let imageView = gesture.view as? UIImageView {
            
            if (self.items[imageView.tag].getFromUserId() == iApp.sharedInstance.getId()) {
                
                showMyItemMenu(index: imageView.tag)
                
            } else {
                
                self.showItemMenu(index: imageView.tag)
                
            }
        }
    }
    
    func showItemMenu(index: Int) {
        
        let alertController = UIAlertController(title: NSLocalizedString("label_choice_action", comment: ""), message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: .cancel) { action in
            
        }
        
        alertController.addAction(cancelAction)
        
        let reportAction = UIAlertAction(title: NSLocalizedString("action_report", comment: ""), style: .default) { action in
            
            self.showReportMenu(index: index)
        }
        
        alertController.addAction(reportAction)
        
        if let popoverController = alertController.popoverPresentationController {
            
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showMyItemMenu(index: Int) {
        
        let alertController = UIAlertController(title: NSLocalizedString("label_choice_action", comment: ""), message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: .cancel) { action in
            
        }
        
        alertController.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: NSLocalizedString("action_delete", comment: ""), style: .default) { action in
            
            self.remove(itemId: self.items[index].getId(), index: index)
        }
        
        alertController.addAction(deleteAction)
        
        if (self.pageId == Constants.ITEMS_PROFILE_PAGE && iApp.sharedInstance.getId() == self.profileId) {
            
            if (self.items[index].getPinned() == 1) {
                
                let unpinAction = UIAlertAction(title: NSLocalizedString("action_unpin", comment: ""), style: .default) { action in
                    
                    self.pin(itemId: self.items[index].getId(), index: index)
                }
                
                alertController.addAction(unpinAction)
                
            } else {
                
                let pinAction = UIAlertAction(title: NSLocalizedString("action_pin", comment: ""), style: .default) { action in
                    
                    self.pin(itemId: self.items[index].getId(), index: index)
                }
                
                alertController.addAction(pinAction)
            }
        }
        
        if let popoverController = alertController.popoverPresentationController {
            
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showReportMenu(index: Int) {
        
        let alertController = UIAlertController(title: NSLocalizedString("label_abuse_report", comment: ""), message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: .cancel) { action in
            
        }
        
        alertController.addAction(cancelAction)
        
        let spamAction = UIAlertAction(title: NSLocalizedString("label_report_spam", comment: ""), style: .default) { action in
            
            self.report(itemId: self.items[index].getId(), abuseId: 0) // 0 = Spam
        }
        
        alertController.addAction(spamAction)
        
        let hateAction = UIAlertAction(title: NSLocalizedString("label_report_hate", comment: ""), style: .default) { action in
            
            self.report(itemId: self.items[index].getId(), abuseId: 1) // 1 = Hate Speech
        }
        
        alertController.addAction(hateAction)
        
        let nudityAction = UIAlertAction(title: NSLocalizedString("label_report_nudity", comment: ""), style: .default) { action in
            
            self.report(itemId: self.items[index].getId(), abuseId: 2) // 2 = Nudity
        }
        
        alertController.addAction(nudityAction)
        
        let piracyAction = UIAlertAction(title: NSLocalizedString("label_report_piracy", comment: ""), style: .default) { action in
            
            self.report(itemId: self.items[index].getId(), abuseId: 3) // 3 = Piracy
        }
        
        alertController.addAction(piracyAction)
        
        if let popoverController = alertController.popoverPresentationController {
            
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func like(itemId: Int, index: Int) {
        
        var request = URLRequest(url: URL(string: Constants.METHOD_LIKES_LIKE)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&itemId=" + String(itemId) + "&itemType=" + String(Constants.ITEM_TYPE_POST);
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        self.items[index].setLikesCount(likesCount: (response["likesCount"] as AnyObject).integerValue)
                        self.items[index].setMyLike(myLike: response["myLike"] as! Bool)
                    }
                    
                    DispatchQueue.main.async() {
                        
                        self.loadingComplete();
                    }
                    
                } catch let error2 as NSError {
                    
                    print(error2.localizedDescription)
                }
            }
            
        }).resume();
    }
    
    func pin(itemId: Int, index: Int) {
        
        self.serverRequestStart();
        
        var request = URLRequest(url: URL(string: Constants.METHOD_ITEM_PIN)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&itemId=" + String(itemId);
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
                        
                        if (self.items[index].getPinned() == 1) {
                            
                            self.items[index].setPinned(pinned: 0);
                            
                        } else {
                            
                            self.items[0].setPinned(pinned: 0);
                            
                            self.items[index].setPinned(pinned: 1);
                            
                            self.items.swapAt(0, index);
                        }
                    }
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();
                        self.loadingComplete();
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
    
    func remove(itemId: Int, index: Int) {
        
        self.serverRequestStart();
        
        var request = URLRequest(url: URL(string: Constants.METHOD_ITEM_REMOVE)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&itemId=" + String(itemId);
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
                        
                        self.items.remove(at: index)
                    }
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();
                        self.loadingComplete();
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
    
    func report(itemId: Int, abuseId: Int) {
        
        self.serverRequestStart();
        
        var request = URLRequest(url: URL(string: Constants.METHOD_REPORT_NEW)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&itemId=" + String(itemId) + "&abuseId=" + String(abuseId) + "&itemType=" + String(Constants.REPORT_TYPE_ITEM);
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
                    
                    print(response)
                    
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
    
    func showLoadingScreen() {
        
        self.textMessageView.isHidden = true
        
        self.loadingView.isHidden = false
        self.loadingView.startAnimating()
        
        self.tableView.isHidden = true
    }
    
    func showContentScreen() {
        
        self.textMessageView.isHidden = true
        
        self.loadingView.isHidden = true
        self.loadingView.stopAnimating()
        
        self.tableView.isHidden = false
    }
    
    func showEmptyScreen() {
        
        self.textMessageView.text = NSLocalizedString("label_empty", comment: "");
        self.textMessageView.isHidden = false
        
        self.loadingView.isHidden = true
        self.loadingView.stopAnimating()
        
        self.tableView.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}
