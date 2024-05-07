//
//  LoginController.swift
//  iMyFirstApp
//
//  Created by Mac Book on 08.08.21.
//  Copyright © 2021 raccoonsquare@gmail.com. All rights reserved.
//

import UIKit

import FacebookLogin
import FacebookCore
import Foundation
import Firebase
import GoogleSignIn

class LoginController: UIViewController, UITextFieldDelegate, LoginButtonDelegate {
    
    var fbdata : [String : AnyObject]!
    
    @IBOutlet weak var usernameSeparator: UIView!
    @IBOutlet weak var passwordSeparator: UIView!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var remindButton: UIButton!
    
    @IBOutlet weak var googleButton: GIDSignInButton!
    var facebookButton = FBLoginButton(permissions: [.publicProfile, .email])
    
    var usernameError : Bool = false;
    var passwordError : Bool = false;
    
    var username : String = "";
    var password : String = "";
    
    var showSignup : Bool = false;
    
    var oauth_id : String = "";
    var oauth_type : Int = 0;

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.passwordTextField.delegate = self
        self.usernameTextField.delegate = self
        
        self.usernameTextField.tag = 0
        self.passwordTextField.tag = 1
        
        logInButton.addTarget(self, action: #selector(self.logInButtonPressed), for: .touchUpInside)
        
        self.usernameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        if (AccessToken.current != nil) {
            
            self.logoutFromFacebook()
        }
        
        facebookButton.delegate = self
        view.addSubview(facebookButton)
        
        facebookButton.translatesAutoresizingMaskIntoConstraints = false
        
        facebookButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        facebookButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
        
        if (!Constants.FACEBOOK_AUTHORIZATION) {
            
            facebookButton.isHidden = true
            
        } else {
            
            facebookButton.isHidden = false
        }
        
        if (!Constants.GOOGLE_AUTHORIZATION) {
            
            googleButton.isHidden = true
            
        } else {
            
            googleButton.isHidden = false
        }
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
                    
                    //iApp.sharedInstance.setFacebookId(fbId: (self.fbdata["id"] as! String))
                    //iApp.sharedInstance.setFacebookName(fbName: (self.fbdata["name"] as! String))
                    //iApp.sharedInstance.setFacebookEmail(fbEmail: (self.fbdata["email"] as! String))
                    
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
        
        let buttonText = NSAttributedString(string: NSLocalizedString("action_facebook_login", comment: ""))
        self.facebookButton.setAttributedTitle(buttonText, for: .normal)
        self.facebookButton.setAttributedTitle(buttonText, for: .focused)
        self.facebookButton.setAttributedTitle(buttonText, for: .selected)
    }
    
    func logoutFromFacebook() {
        
        self.setLoginButtonTitle()
        
        let loginManager: LoginManager = LoginManager()
        loginManager.logOut()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if  (segue.identifier == "showSignup") {
            
            // Create a new variable to store the instance of SignupController

            let destinationVC = segue.destination as! SignupController
            
            destinationVC.oauth_id = self.oauth_id
            destinationVC.oauth_type = self.oauth_type
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        switch(textField.tag) {
            
            case 0:
                
                if (self.usernameError) {
                    
                    self.usernameError = false
                    
                    self.usernameSeparator.backgroundColor = UIColor.lightGray
                }
            
                break
            
            default:
                
                if (self.passwordError) {
                    
                    self.passwordError = false
                    
                    self.passwordSeparator.backgroundColor = UIColor.lightGray
                }
            
                break
        }
    }
    
    @objc func logInButtonPressed(sender: UIButton!) {
        
        username = self.usernameTextField.text!;
        password = self.passwordTextField.text!;
        
        if (username.count == 0) {
         
            self.usernameError = true
            
            self.usernameSeparator.backgroundColor = UIColor.red
        }
        
        if (password.count == 0) {
            
            self.passwordError = true
            
            self.passwordSeparator.backgroundColor = UIColor.red
        }
        
        if (!usernameError && !passwordError) {
            
            self.view.endEditing(true)
            
            self.login(username: username, password: password);
        }
    }
    
    func login(username: String, password: String) {
        
        self.serverRequestStart();
        
        print("Firebase registration token LoginView: \(iApp.sharedInstance.getFcmRegId())")
        
        var request = URLRequest(url: URL(string: Constants.METHOD_ACCOUNT_SIGNIN)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&username=" + username + "&password=" + password + "&fcm_regId=" + iApp.sharedInstance.getFcmRegId() + "&appType=" + String(Constants.APP_TYPE_IOS) + "&lang=en";
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
                                
                                print(response)
                                
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
                        
                        // error authorization
                        
                        DispatchQueue.global(qos: .background).async {
                            
                            DispatchQueue.main.async {
                                
                                // show message with error
                                
                                let alert = UIAlertController(title: Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String, message: NSLocalizedString("incorrect_login_message", comment: ""), preferredStyle: UIAlertController.Style.alert)
                                
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                                
                                // show the alert
                                self.present(alert, animated: true, completion: nil)
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
                        
                        self.showSignup = true
                    }
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();
                        
                        if (self.showSignup) {
                            
                            print("showSignup")
                            
                            self.performSegue(withIdentifier: "showSignup", sender: self)
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
                        
                        // go to signup with facebook
                        
                        self.showSignup = true
                    }
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();
                        
                        if (self.showSignup) {
                            
                            print("showSignup")
                            
                            self.performSegue(withIdentifier: "showSignup", sender: self)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
            
            case self.usernameTextField:
            
                self.passwordTextField.becomeFirstResponder()
                break
            
            default:
            
                textField.resignFirstResponder()
        }
        
        return true
    }
    
    @IBAction func userTappedBackground(sender: AnyObject) {
        
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}
