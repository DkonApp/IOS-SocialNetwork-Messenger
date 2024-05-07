//
//  ProfileSettingsController.swift
//  SocialApp
//
//  Created by Mac Book on 23.01.17.
//  Copyright © 2017 Ifsoft. All rights reserved.
//

import UIKit
import Darwin

class ProfileSettingsController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var coverView: UIImageView!
    @IBOutlet weak var uploadIndicator: UIActivityIndicatorView!
    
    var fullname: String = "";
    var location: String = "";
    var facebookPage: String = "";
    var instagramPage: String = "";
    
    var bio: String = "";
    
    var sex: Int = 0;
    
    var year: Int = 0;
    var month: Int = 0;
    var day: Int = 0;
    
    var relationshipStatus: Int = 0;
    var politicalViews: Int = 0;
    var worldViews: Int = 0;
    var personalPriority: Int = 0;
    var importantInOthers: Int = 0;
    var smokingViews: Int = 0;
    var alcoholViews: Int = 0;
    var lookingFor: Int = 0;
    var genderLike: Int = 0;
    
    var modified: Bool = false;
    
    var imgMode: Int = 0 // 0 - photo, 1 - cover
    
    var saveButton = UIBarButtonItem()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        saveButton = UIBarButtonItem(barButtonSystemItem: .save , target: self, action: #selector(save))
        self.navigationItem.rightBarButtonItem  = saveButton
        
        modify(modified: false)
        
        self.fullname = iApp.sharedInstance.getFullname()
        self.location = iApp.sharedInstance.getLocation()
        self.facebookPage = iApp.sharedInstance.getFacebookPage()
        self.instagramPage = iApp.sharedInstance.getInstagramPage()
        self.sex = iApp.sharedInstance.getSex()
        
        self.bio = iApp.sharedInstance.getBio()
        
        self.year = iApp.sharedInstance.getYear()
        self.month = iApp.sharedInstance.getMonth()
        self.day = iApp.sharedInstance.getDay()

        self.uploadIndicator.isHidden = true;
        
        self.photoView.layer.borderWidth = 1
        self.photoView.layer.masksToBounds = false
        self.photoView.layer.borderColor = UIColor.white.cgColor
        self.photoView.layer.cornerRadius = self.photoView.frame.height/2
        self.photoView.clipsToBounds = true
        
        self.coverView.clipsToBounds = true
        
        updatePhoto()
        updateCover()
    }
    
    @objc func save() {
        
        self.saveSettings(accountId: iApp.sharedInstance.getId(), accessToken: iApp.sharedInstance.getAccessToken(), fullname: self.fullname, location: self.location, facebookPage: self.facebookPage, instagramPage: self.instagramPage, sex: self.sex)
    }
    
    func modify(modified: Bool) {
        
        self.modified = modified
        
        if (self.modified) {
            
            self.navigationItem.rightBarButtonItem?.isEnabled = true;
            
        } else {
            
            self.navigationItem.rightBarButtonItem?.isEnabled = false;
        }
    }
    
    func updatePhoto() {
        
        if (iApp.sharedInstance.getPhotoUrl().count != 0 && Helper.isInternetAvailable()) {
            
            if (iApp.sharedInstance.getCache().object(forKey: iApp.sharedInstance.getPhotoUrl() as AnyObject) != nil) {
                
                self.photoView.image = iApp.sharedInstance.getCache().object(forKey: iApp.sharedInstance.getPhotoUrl() as AnyObject) as? UIImage
                
            } else {
                
                let imageUrl:URL = URL(string: iApp.sharedInstance.getPhotoUrl())!
                
                uploadPhotoRequestStart()
                
                DispatchQueue.global().async {
                    
                    let data = try? Data(contentsOf: imageUrl)
                    
                    DispatchQueue.main.async {
                        
                        if data != nil {
                            
                            let img = UIImage(data: data!)
                            
                            self.photoView.image = img
                        }
                        
                        self.uploadPhotoRequestEnd()
                    }
                }
            }
        }
    }
    
    func updateCover() {
        
        if (iApp.sharedInstance.getCoverUrl().count != 0 && Helper.isInternetAvailable()) {
            
            if (iApp.sharedInstance.getCache().object(forKey: iApp.sharedInstance.getCoverUrl() as AnyObject) != nil) {
                
                self.coverView.image = iApp.sharedInstance.getCache().object(forKey: iApp.sharedInstance.getCoverUrl() as AnyObject) as? UIImage
                
            } else {
                
                let imageUrl:URL = URL(string: iApp.sharedInstance.getCoverUrl())!
                
                uploadPhotoRequestStart()
                
                DispatchQueue.global().async {
                    
                    let data = try? Data(contentsOf: imageUrl)
                    
                    DispatchQueue.main.async {
                        
                        if data != nil {
                            
                            let img = UIImage(data: data!)
                            
                            self.coverView.image = img
                        }
                        
                        self.uploadPhotoRequestEnd()
                    }
                }
            }
        }
    }
    
    @IBAction func actionButtonTapped(_ sender: Any) {
        
        let alertController = UIAlertController(title: NSLocalizedString("label_profile_photo", comment: ""), message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: .cancel) { action in
            
            
        }
        
        alertController.addAction(cancelAction)
        
        let librarylAction = UIAlertAction(title: NSLocalizedString("action_photo_from_library", comment: ""), style: .default) { action in
            
            self.imgMode = 0;
            
            self.photoFromLibrary()
        }
        
        alertController.addAction(librarylAction)
        
        let cameraAction = UIAlertAction(title: NSLocalizedString("action_photo_from_camera", comment: ""), style: .default) { action in
            
            self.imgMode = 0;
            
            self.photoFromCamera()
        }
        
        alertController.addAction(cameraAction)
        
        let coverLibrarylAction = UIAlertAction(title: NSLocalizedString("action_cover_from_library", comment: ""), style: .default) { action in
            
            self.imgMode = 1;
            
            self.photoFromLibrary()
        }
        
        alertController.addAction(coverLibrarylAction)
        
        let coverCameraAction = UIAlertAction(title: NSLocalizedString("action_cover_from_camera", comment: ""), style: .default) { action in
            
            self.imgMode = 1;
            
            self.photoFromCamera()
        }
        
        alertController.addAction(coverCameraAction)
        
        if let popoverController = alertController.popoverPresentationController {
            
            popoverController.sourceView = sender as? UIView
            popoverController.sourceRect = (sender as AnyObject).bounds
        }
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var chosenImage = UIImage()
        
        chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        if (self.imgMode == 0) {
            
            photoView.image = chosenImage
            
        } else {
            
            coverView.image = chosenImage
        }
        
        self.uploadImage()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func photoFromLibrary() {
        
        let myPickerController = UIImagePickerController()
        
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    func photoFromCamera() {
        
        let myPickerController = UIImagePickerController()
        
        myPickerController.delegate = self;
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            myPickerController.allowsEditing = false
            myPickerController.sourceType = UIImagePickerController.SourceType.camera
            myPickerController.cameraCaptureMode = .photo
            myPickerController.modalPresentationStyle = .fullScreen
            
            present(myPickerController, animated: true, completion: nil)
            
        } else {
            
            let alertVC = UIAlertController(title: "No Camera", message: "Sorry, this device has no camera", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
            
            alertVC.addAction(okAction)
            
            present(alertVC, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField.tag {
            
            case 0:
                
                self.fullname = textField.text!
            
                break
            
            case 1:
                
                self.location = textField.text!
            
                break
            
            case 2:
                
                self.facebookPage = textField.text!
            
                break
            
            case 3:
                
                self.instagramPage = textField.text!
            
                break
            
            default:
            
                break
        }
        
        modify(modified: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    override func tableView(_ tableView : UITableView,  titleForHeaderInSection section: Int) -> String? {
        
        return NSLocalizedString("label_profile_info", comment: "")
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row > 3) {
            
            var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "CustomCell")!
            
            if (cell == nil) {
                
                cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "CustomCell")
            }
        
            
            cell?.selectionStyle = .default
            
            switch indexPath.row {
                
            case 4:
                
                cell?.textLabel?.text  = NSLocalizedString("label_gender", comment: "")
                cell?.detailTextLabel?.text = Helper.getGender(sex: self.sex)
                cell?.imageView?.image = UIImage(named: "ic_gender_30")
                
                break
                
            default:
                
                break
            }
            
            return cell!
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditableCell", for: indexPath) as! EdiatableSettingsCell
            
            cell.selectionStyle = .none
            
            switch indexPath.row {
                
            case 0:
                
                cell.textField.tag = 0
                cell.textField.text = self.fullname
                cell.textField.placeholder = NSLocalizedString("label_fullname", comment: "")
                
                cell.iconView.image = UIImage(named: "ic_profile_30")
                
                break
                
            case 1:
                
                cell.textField.tag = 1
                cell.textField.text = self.location
                cell.textField.placeholder = NSLocalizedString("label_location", comment: "")
                
                cell.iconView.image = UIImage(named: "ic_nearby_30")
                
                break
                
            case 2:
                
                cell.textField.tag = 2
                cell.textField.text = self.facebookPage
                cell.textField.placeholder = NSLocalizedString("label_facebook", comment: "")
                
                cell.iconView.image = UIImage(named: "ic_web_30")
                
                break
                
            case 3:
                
                cell.textField.tag = 3
                cell.textField.text = self.instagramPage
                cell.textField.placeholder = NSLocalizedString("label_instagram", comment: "")
                
                cell.iconView.image = UIImage(named: "ic_web_30")
                
                break
                
            default:
                
                break
            }
            
            cell.textField.delegate = self
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.row == 4) {
            
            let alertController = UIAlertController(title: nil, message: NSLocalizedString("label_gender", comment: ""), preferredStyle: .actionSheet)
            
            let maleAction = UIAlertAction(title: NSLocalizedString("label_male", comment: ""), style: .default) { action in
                
                self.sex = Constants.SEX_MALE
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(maleAction)
            
            let femaleAction = UIAlertAction(title: NSLocalizedString("label_female", comment: ""), style: .default) { action in
                
                self.sex = Constants.SEX_FEMALE
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(femaleAction)
            
            if let popoverController = alertController.popoverPresentationController {
                
                popoverController.sourceView = tableView.cellForRow(at: indexPath)
                popoverController.sourceRect = (tableView.cellForRow(at: indexPath)?.bounds)!
                popoverController.permittedArrowDirections = UIPopoverArrowDirection.any
            }
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

    func uploadImage() {
        
        let myUrl = NSURL(string: Constants.METHOD_PROFILE_UPLOAD_IMAGE);
        
        var imageData = Helper.rotateImage(image: photoView.image!).jpeg(.low)
        
        if (self.imgMode == 1) {
        
            imageData = Helper.rotateImage(image: coverView.image!).jpeg(.low)
        }
        
        if (imageData == nil) {
            
            return;
        }
        
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";
        
        let param = ["accountId" : String(iApp.sharedInstance.getId()), "accessToken" : iApp.sharedInstance.getAccessToken(), "imgType" : String(imgMode)]
        
        let boundary = Helper.generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = Helper.createBodyWithParameters(parameters: param, filePathKey: "uploaded_file", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        
        
        uploadPhotoRequestStart()
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            
            data, response, error in
            
            if error != nil {
                
                DispatchQueue.main.async() {
                    
                    self.uploadPhotoRequestEnd();
                }
                
                return
            }
            
            do {
                
                let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                let responseError = response["error"] as! Bool;
                
                print(response)
                
                if (responseError == false) {
                    
                    if (self.imgMode == 0) {
                        
                        if (Constants.SERVER_ENGINE_VERSION > 1) {
                        
                            iApp.sharedInstance.setPhotoUrl(photoUrl: response["photoUrl"] as! String)
                            
                        } else {
                            
                            iApp.sharedInstance.setPhotoUrl(photoUrl: response["lowPhotoUrl"] as! String)
                        }
                        
                    } else {
                        
                        if (Constants.SERVER_ENGINE_VERSION > 1) {
                            
                            iApp.sharedInstance.setCoverUrl(coverUrl: response["coverUrl"] as! String)
                            
                        } else {
                            
                            iApp.sharedInstance.setCoverUrl(coverUrl: response["normalCoverUrl"] as! String)
                        }
                    }
                }
                
                DispatchQueue.main.async() {
                    
                    self.uploadPhotoRequestEnd();
                }
                
            } catch {
                
                print(error)
                
                DispatchQueue.main.async() {
                    
                    self.uploadPhotoRequestEnd();
                }
            }
            
        }
        
        task.resume()
    }
    
    func serverRequestStart() {
        
        LoadingIndicatorView.show(NSLocalizedString("label_loading", comment: ""));
    }
    
    func serverRequestEnd() {
        
        LoadingIndicatorView.hide();
    }
    
    func uploadPhotoRequestStart() {
        
        self.actionButton.isEnabled = false;
        self.uploadIndicator.startAnimating();
        self.uploadIndicator.isHidden = false;
        
        self.photoView.isHidden = true;
        self.coverView.isHidden = true;
    }
    
    func uploadPhotoRequestEnd() {
        
        self.actionButton.isEnabled = true;
        self.uploadIndicator.stopAnimating();
        self.uploadIndicator.isHidden = true;
        
        self.photoView.isHidden = false;
        self.coverView.isHidden = false;
    }
    
    func saveSettings(accountId: Int, accessToken: String, fullname: String, location: String, facebookPage: String, instagramPage: String, sex: Int) {
        
        self.serverRequestStart()
        
        var request = URLRequest(url: URL(string: Constants.METHOD_ACCOUNT_SAVE_SETTINGS)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=\(String(Constants.CLIENT_ID))&accountId=\(accountId)&accessToken=\(accessToken)&fullname=\(fullname)&location=\(location)&facebookPage=\(facebookPage)&instagramPage=\(instagramPage)&sex=\(String(sex))&iStatus=\(String(self.relationshipStatus))&politicalViews=\(String(self.politicalViews))&worldViews=\(String(self.worldViews))&personalPriority=\(String(self.personalPriority))&importantInOthers=\(String(self.importantInOthers))&smokingViews=\(String(self.smokingViews))&alcoholViews=/(String(self.alcoholViews))&lookingViews=\(String(self.lookingFor))&interestedViews=\(String(self.genderLike))&bio=\(self.bio)&year=\(String(self.year))&month=\(String(self.month))&day=\(String(self.day))";
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
                DispatchQueue.main.async() {
                    
                    self.serverRequestEnd()
                    self.modify(modified: true)
                }
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        iApp.sharedInstance.authorize(Response: response as AnyObject)
                        
                        DispatchQueue.global(qos: .background).async {
                            
                            DispatchQueue.main.async {
                                
                                self.modify(modified: false)
                            }
                        }
                    }
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd()
                    }
                    
                } catch let error2 as NSError {
                    
                    print(error2.localizedDescription)
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd()
                        self.modify(modified: true)
                    }
                }
            }
            
        }).resume()
    }
}

extension NSMutableData {
    
    func appendString(string: String) {
        
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }

}

extension UIImage {
    
    enum JPEGQuality: CGFloat {
        
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    var png: Data? { return self.pngData() }
    
    func jpeg(_ quality: JPEGQuality) -> Data? {
        
        return self.jpegData(compressionQuality: quality.rawValue)
    }
}
