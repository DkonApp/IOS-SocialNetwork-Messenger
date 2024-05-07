//
//  SignupController.swift
//
//  Created by Mac Book on 08.08.21.
//  Copyright © 2021 raccoonsquare@gmail.com All rights reserved.
//

import UIKit


import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import GoogleSignIn

class SignupController: UIViewController, UITextFieldDelegate, LoginButtonDelegate {
    
    @IBOutlet weak var usernameSeparator: UIView!
    @IBOutlet weak var fullnameSeparator: UIView!
    @IBOutlet weak var passwordSeparator: UIView!
    @IBOutlet weak var emailSeparator: UIView!
    
    @IBOutlet weak var fbRegularSignupButton: UIButton!

    @IBOutlet weak var usernameEditText: UITextField!
    @IBOutlet weak var fullnameEditText: UITextField!
    @IBOutlet weak var passwordEditText: UITextField!
    @IBOutlet weak var emailEditText: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var navTitle: UINavigationItem!
    
    var facebookButton = FBLoginButton(permissions: [.publicProfile, .email])
    @IBOutlet weak var googleButton: GIDSignInButton!
    
    var fbdata : [String : AnyObject]!
    
    var usernameError : Bool = false;
    var fullnameError : Bool = false;
    var emailError : Bool = false;
    var passwordError : Bool = false;
    
    var username : String = "";
    var fullname : String = "";
    var password : String = "";
    var email : String = "";
    
    var oauth_id : String = "";
    var oauth_type : Int = 0;
    
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
            
        case self.usernameEditText:
            
            self.fullnameEditText.becomeFirstResponder()
            break
            
        case self.fullnameEditText:
            
            self.passwordEditText.becomeFirstResponder()
            break
            
        case self.passwordEditText:
            
            self.emailEditText.becomeFirstResponder()
            break
            
        default:
            
            textField.resignFirstResponder()
        }
        
        return true
    }
    

    @IBAction func userTappedBackground(sender: AnyObject) {
        
        view.endEditing(true)
    }

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.usernameEditText.tag = 0
        self.fullnameEditText.tag = 1
        self.passwordEditText.tag = 2
        self.emailEditText.tag = 3
        
        self.usernameEditText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.fullnameEditText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.passwordEditText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.emailEditText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        signupButton.addTarget(self, action: #selector(self.signUpPressed), for: .touchUpInside)
        
        self.usernameEditText.delegate = self
        self.fullnameEditText.delegate = self
        self.passwordEditText.delegate = self
        self.emailEditText.delegate = self
        
        if AccessToken.current != nil{
            
            self.logoutFromFacebook()
        }
        
        facebookButton.delegate = self
        view.addSubview(facebookButton)
        
        facebookButton.translatesAutoresizingMaskIntoConstraints = false
        
        facebookButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        facebookButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
        
        if (!Constants.FACEBOOK_AUTHORIZATION) {
            
            self.facebookButton.isHidden = true
        }
        
        if (!Constants.GOOGLE_AUTHORIZATION) {
            
            self.googleButton.isHidden = true
        }
        
        if (oauth_id.count != 0) {
            
            self.oauthSignup();
            
        } else {
            
            self.regularSignup();
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    
    @IBAction func googleSignInClicked(_ sender: Any) {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in

          if let error = error {
            // ...
            return
          }

          guard
            
            let authentication = user?.authentication,
            let idToken = authentication.idToken
          
          else {
            
            return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                
                if let error = error {
                    
                    let authError = error as NSError
                  
                    return
                }
                
                guard let userID = Auth.auth().currentUser?.uid else {
                    
                    return
                }
                
                print(userID)
                
                self.oauth_id = userID;
                self.oauth_type = Constants.OAUTH_TYPE_GOOGLE;
                
                loginByGoogle(glId: userID)
                
                // User is signed in
                // ...
                
                let firebaseAuth = Auth.auth()
                
                do {
                    
                  try firebaseAuth.signOut()
                    
                } catch let signOutError as NSError {
                    
                  print("Error signing out: %@", signOutError)
                }
            }

          // ...
        }
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        if ((error) != nil) {
            
            print(error!)
            
        } else if result!.isCancelled {
            
            print("User cancelled login.")
            
        } else {
            
            self.setLoginButtonTitle()
            
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            
            if result!.grantedPermissions.contains("email") {
                
                self.readFacebookData()
            }
            
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
        return
    }
    
    func readFacebookData() {
        
        if (AccessToken.current != nil) {
            
            // alswo can use "picture.type(large)" for get photo
            
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil) {
                    
                    self.fbdata = result as? [String : AnyObject]
                    
//                    iApp.sharedInstance.setFacebookId(fbId: self.fbdata["id"] as! String)
//                    iApp.sharedInstance.setFacebookName(fbName: self.fbdata["name"] as! String)
//                    iApp.sharedInstance.setFacebookEmail(fbEmail: self.fbdata["email"] as! String)
                    
                    self.oauth_id = self.fbdata["id"] as! String;
                    self.oauth_type = Constants.OAUTH_TYPE_FACEBOOK;
                    
                    // print(FBSDKAccessToken.current().userID)
                    
                    self.logoutFromFacebook(); // Kill Access token
                    
                    self.loginByFacebook(fbId: iApp.sharedInstance.getFacebookId())
                }
            })
        }
    }
    
    func setLoginButtonTitle() {
        
        let buttonText = NSAttributedString(string: NSLocalizedString("action_facebook_signup", comment: ""))
        self.facebookButton.setAttributedTitle(buttonText, for: .normal)
        self.facebookButton.setAttributedTitle(buttonText, for: .focused)
        self.facebookButton.setAttributedTitle(buttonText, for: .selected)
    }
    
    func logoutFromFacebook() {
        
        self.setLoginButtonTitle()
        
        let loginManager: LoginManager = LoginManager()
        loginManager.logOut()
    }
    
    func regularSignup() {
        
        self.fbRegularSignupButton.isHidden = true
        
        self.facebookButton.isHidden = false
        self.googleButton.isHidden = false
    }
    
    func oauthSignup() {
        
        self.setLoginButtonTitle()
        
        self.fbRegularSignupButton.isHidden = false
        self.facebookButton.isHidden = true
        self.googleButton.isHidden = true
    }
    
    @IBAction func regularSignupClick(_ sender: Any) {
        
        self.oauth_id = "";
        
        self.regularSignup();
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 0.0
            } else {
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        switch(textField.tag) {
            
        case 0:
            
            if (self.usernameError) {
                
                self.usernameError = false
                
                self.usernameSeparator.backgroundColor = UIColor.lightGray
            }
            
            break
            
        case 1:
            
            if (self.fullnameError) {
                
                self.fullnameError = false
                
                self.fullnameSeparator.backgroundColor = UIColor.lightGray
            }
            
            break
            
        case 2:
            
            if (self.passwordError) {
                
                self.passwordError = false
                
                self.passwordSeparator.backgroundColor = UIColor.lightGray
            }
            
            break
            
        default:
            
            if (self.emailError) {
                
                self.emailError = false
                
                self.emailSeparator.backgroundColor = UIColor.lightGray
            }
            
            break
        }
    }
    
    @objc func signUpPressed(sender: UIButton!) {
        
        username = self.usernameEditText.text!;
        fullname = self.fullnameEditText.text!;
        password = self.passwordEditText.text!;
        email = self.emailEditText.text!;
        
        if (username.count == 0) {
            
            self.usernameError = true
            
            self.usernameSeparator.backgroundColor = UIColor.red
        }
        
        if (fullname.count == 0) {
            
            self.fullnameError = true
            
            self.fullnameSeparator.backgroundColor = UIColor.red
        }
        
        if (email.count == 0) {
            
            self.emailError = true
            
            self.emailSeparator.backgroundColor = UIColor.red
        }
        
        if (password.count == 0) {
            
            self.passwordError = true
            
            self.passwordSeparator.backgroundColor = UIColor.red
        }
        
        if (!usernameError && !fullnameError && !emailError && !passwordError) {
            
            self.view.endEditing(true)
            
            self.signup(username: username, fullname: fullname, password: password, email: email);
        }
    }
    
    func signup(username: String, fullname: String, password: String, email: String) {
        
        self.serverRequestStart();
        
        var request = URLRequest(url: URL(string: Constants.METHOD_ACCOUNT_SIGNUP)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&username=" + username + "&fullname=" + fullname + "&password=" + password + "&email=" + email + "&fcm_regId=" + iApp.sharedInstance.getFcmRegId() + "&appType=" + String(Constants.APP_TYPE_IOS) + "&lang=en" + "&oauth_id=" + oauth_id + "&oauth_type=" + String(oauth_type) + "&hash=" + Helper.MD5(string: Helper.MD5(string: username) + Constants.CLIENT_SECRET);
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        let accessToken = response["accessToken"] as! String;
                        
                        iApp.sharedInstance.setAccessToken(access_token: accessToken);
                        
                        DispatchQueue.global(qos: .background).async {
                            
                            //Get account array
                            let accountArray = response["account"] as! [AnyObject]
                            
                            iApp.sharedInstance.authorize(Response: accountArray[0]);
                            
                            DispatchQueue.main.async {
                                
                                let storyboard = UIStoryboard(name: "Content", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "TabController")
                                
                                // not root navigation controller
                                
                                // let navigationController = UINavigationController(rootViewController: vc)
                                
                                vc.modalPresentationStyle = .fullScreen
                                
                                self.present(vc, animated: true, completion: nil)
                            }
                        }
                        
                    } else {
                        
                        let error_code = response["error_code"] as! Int;
                        
                        switch error_code {
                            
                            case Constants.ERROR_CLIENT_ID:
                            
                                DispatchQueue.global(qos: .background).async {
                                
                                    DispatchQueue.main.async {
                                    
                                        let alert = UIAlertController(title: Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String, message: "CLEINT_ID Incorrect or not the same in both config files! Make correct settings in config files!", preferredStyle: UIAlertController.Style.alert)
                                    
                                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                                    
                                        // show the alert
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                }
                            
                                break;
                            
                            case Constants.ERROR_CLIENT_SECRET:
                            
                                DispatchQueue.global(qos: .background).async {
                                
                                    DispatchQueue.main.async {
                                    
                                        let alert = UIAlertController(title: Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String, message: "CLEINT_SECRET Incorrect or not the same in both config files! Make correct settings in config files!", preferredStyle: UIAlertController.Style.alert)
                                    
                                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                                    
                                        // show the alert
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                }
                            
                                break;
                            
                            case Constants.ERROR_LOGIN_TAKEN:
                            
                                DispatchQueue.global(qos: .background).async {
                                
                                    DispatchQueue.main.async {
                                    
                                        let alert = UIAlertController(title: Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String, message: NSLocalizedString("login_taken_message", comment: ""), preferredStyle: UIAlertController.Style.alert)
                                    
                                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                                    
                                        // show the alert
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                }
                            
                                break;
                            
                            case Constants.ERROR_EMAIL_TAKEN:
                            
                                DispatchQueue.global(qos: .background).async {
                                
                                    DispatchQueue.main.async {
                                    
                                        let alert = UIAlertController(title: Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String, message: NSLocalizedString("email_taken_message", comment: ""), preferredStyle: UIAlertController.Style.alert)
                                    
                                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                                    
                                        // show the alert
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                }
                            
                                break;
                            
                            default:
                                
                                let error_type = response["error_type"] as! Int;
                                
                                switch error_type {
                                    
                                    case 0:
                                        
                                        DispatchQueue.global(qos: .background).async {
                                            
                                            DispatchQueue.main.async {
                                                
                                                let alert = UIAlertController(title: Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String, message: NSLocalizedString("username_error", comment: ""), preferredStyle: UIAlertController.Style.alert)
                                                
                                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                                                
                                                // show the alert
                                                self.present(alert, animated: true, completion: nil)
                                                
                                                self.usernameError = true
                                                
                                                self.usernameSeparator.backgroundColor = UIColor.red
                                            }
                                        }
                                    
                                        break;
                                    
                                    case 1:
                                    
                                        DispatchQueue.global(qos: .background).async {
                                        
                                            DispatchQueue.main.async {
                                            
                                                let alert = UIAlertController(title: Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String, message: NSLocalizedString("password_error", comment: ""), preferredStyle: UIAlertController.Style.alert)
                                            
                                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                                            
                                                // show the alert
                                                self.present(alert, animated: true, completion: nil)
                                            
                                                self.passwordError = true
                                            
                                                self.passwordSeparator.backgroundColor = UIColor.red
                                            }
                                        }
                                    
                                        break;
                                    
                                    case 2:
                                    
                                        DispatchQueue.global(qos: .background).async {
                                        
                                            DispatchQueue.main.async {
                                            
                                                let alert = UIAlertController(title: Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String, message: NSLocalizedString("email_error", comment: ""), preferredStyle: UIAlertController.Style.alert)
                                            
                                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                                            
                                                // show the alert
                                                self.present(alert, animated: true, completion: nil)
                                            
                                                self.emailError = true
                                            
                                                self.emailSeparator.backgroundColor = UIColor.red
                                            }
                                        }
                                    
                                    break;
                                    
                                    default:
                                        
                                        DispatchQueue.global(qos: .background).async {
                                            
                                            DispatchQueue.main.async {
                                                
                                                let alert = UIAlertController(title: Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String, message: NSLocalizedString("fullname_error", comment: ""), preferredStyle: UIAlertController.Style.alert)
                                                
                                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                                                
                                                // show the alert
                                                self.present(alert, animated: true, completion: nil)
                                                
                                                self.fullnameError = true
                                                
                                                self.fullnameSeparator.backgroundColor = UIColor.red
                                            }
                                        }
                                    
                                        break
                                    
                                }
                            
                                break;
                        }
                    }
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();
                    }
                    
                } catch let error2 as NSError {
                    
                    print(error2)
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();
                    }
                }
            }
            
        }).resume();
    }
    
    func loginByFacebook(fbId: String) {
        
        self.serverRequestStart();
        
        var request = URLRequest(url: URL(string: Constants.METHOD_ACCOUNT_LOGINBYFACEBOOK)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&facebookId=" + fbId + "&fcm_regId=" + iApp.sharedInstance.getFcmRegId() + "&appType=" + String(Constants.APP_TYPE_IOS) + "&lang=en";
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
                DispatchQueue.main.async() {
                    
                    self.serverRequestEnd();
                }
                
                print("start auth error")
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        if (response["accessToken"] as? String != nil) {
                            
                            let accessToken = response["accessToken"] as! String;
                            
                            iApp.sharedInstance.setAccessToken(access_token: accessToken);
                            
                            // all right. start to read auth data
                            
                            DispatchQueue.global(qos: .background).async {
                                
                                //Get account array
                                let accountArray = response["account"] as! [AnyObject]
                                
                                iApp.sharedInstance.authorize(Response: accountArray[0]);
                                
                                DispatchQueue.main.async {
                                    
                                    // run main content storyboard
                                    
                                    let storyboard = UIStoryboard(name: "Content", bundle: nil)
                                    let vc = storyboard.instantiateViewController(withIdentifier: "TabController")
                                    
                                    // not root navigation controller
                                    
                                    // let navigationController = UINavigationController(rootViewController: vc)
                                    
                                    vc.modalPresentationStyle = .fullScreen
                                    
                                    self.present(vc, animated: true, completion: nil)
                                }
                            }
                            
                        } else {
                            
                            // login error
                            // check account state
                            
                            var accountState: Int = 0;
                            
                            if (Constants.SERVER_ENGINE_VERSION > 1) {
                                
                                accountState = Int((response["account_state"] as? String)!)!
                                
                            } else {
                                
                                // old server engine
                                
                                accountState = Int((response["state"] as? String)!)!
                            }
                            
                            // for new version
                            // let accoutState = Int((response["account_state"] as? String)!)
                            
                            if (accountState == Constants.ACCOUNT_STATE_BLOCKED) {
                                
                                // account blocked
                                
                                DispatchQueue.global(qos: .background).async {
                                    
                                    DispatchQueue.main.async {
                                        
                                        // show message with error
                                        
                                        let alert = UIAlertController(title: Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String, message: NSLocalizedString("alert_account_blocked", comment: ""), preferredStyle: UIAlertController.Style.alert)
                                        
                                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                                        
                                        // show the alert
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                }
                            }
                            
                        }
                        
                    } else {
                        
                        // go to signup with facebook
                        
                        // self.regularSignup()
                    }
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();
                        
                        if (self.oauth_id.count > 0) {
                            
                            self.oauthSignup();
                            
                        } else {
                            
                            self.regularSignup();
                        }
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
    
    func loginByGoogle(glId: String) {
        
        self.serverRequestStart();
        
        var request = URLRequest(url: URL(string: Constants.METHOD_ACCOUNT_GOOGLE_AUTH)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "client_id=" + String(Constants.CLIENT_ID) + "&uid=" + glId + "&fcm_regId=" + iApp.sharedInstance.getFcmRegId() + "&app_type=" + String(Constants.APP_TYPE_IOS) + "&lang=en";
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
                        
                        if (response["accessToken"] as? String != nil) {
                            
                            let accessToken = response["accessToken"] as! String;
                            
                            iApp.sharedInstance.setAccessToken(access_token: accessToken);
                            
                            // all right. start to read auth data
                            
                            DispatchQueue.global(qos: .background).async {
                                
                                //Get account array
                                let accountArray = response["account"] as! [AnyObject]
                                
                                iApp.sharedInstance.authorize(Response: accountArray[0]);
                                
                                DispatchQueue.main.async {
                                    
                                    // run main content storyboard
                                    
                                    let storyboard = UIStoryboard(name: "Content", bundle: nil)
                                    let vc = storyboard.instantiateViewController(withIdentifier: "TabController")
                                    
                                    // not root navigation controller
                                    
                                    // let navigationController = UINavigationController(rootViewController: vc)
                                    
                                    vc.modalPresentationStyle = .fullScreen
                                    
                                    self.present(vc, animated: true, completion: nil)
                                }
                            }
                            
                        } else {
                            
                            // login error
                            // check account state
                            
                            var accountState: Int = 0;
                            
                            if (Constants.SERVER_ENGINE_VERSION > 1) {
                                
                                accountState = Int((response["account_state"] as? String)!)!
                                
                            } else {
                                
                                // old server engine
                                
                                accountState = Int((response["state"] as? String)!)!
                            }
                            
                            // for new version
                            // let accoutState = Int((response["account_state"] as? String)!)
                            
                            if (accountState == Constants.ACCOUNT_STATE_BLOCKED) {
                                
                                // account blocked
                                
                                DispatchQueue.global(qos: .background).async {
                                    
                                    DispatchQueue.main.async {
                                        
                                        // show message with error
                                        
                                        let alert = UIAlertController(title: Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String, message: NSLocalizedString("alert_account_blocked", comment: ""), preferredStyle: UIAlertController.Style.alert)
                                        
                                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                                        
                                        // show the alert
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                }
                            }
                            
                        }
                        
                    } else {
                        
                        // go to signup with google
                        
                    }
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();
                        
                        if (self.oauth_id.count > 0) {
                            
                            self.oauthSignup();
                            
                        } else {
                            
                            self.regularSignup();
                        }
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

}
