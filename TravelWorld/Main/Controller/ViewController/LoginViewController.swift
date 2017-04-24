//
//  LoginViewController.swift
//  TravelWorld
//
//  Created by Victor de Paula on 19/04/17.
//  Copyright © 2017 Victor de Paula. All rights reserved.
//

import Foundation
import FacebookLogin
import ObjectMapper

class LoginViewController: UIViewController, LoginButtonDelegate {
    
    //MARK: Variables 
    
    static let sharedInstance: LoginViewController = {
        let instance = LoginViewController()
        return instance
    }()

    let loginButton = LoginButton(readPermissions: [.publicProfile, .email])
    
    //MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        redirectUserLogged()
    }
    
    func redirectUserLogged(){
        if let isLogged = UserManager.sharedInstance.currentUserIsLogged() {
            if isLogged {
                self.userIsLogged()
                setupViewController()
            } else {
                setupViewController()
            }
        }
    }
    
    func setupViewController(){
        UIView.animate(withDuration: 0.5, animations: {
            self.loginButton.removeFromSuperview()
        })
        loginButton.delegate = self
        loginButton.center = view.center
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        
        // Constraints For LoginButton
        
        NSLayoutConstraint(item: loginButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 5).isActive = true
        NSLayoutConstraint(item: loginButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: -5).isActive = true
        NSLayoutConstraint(item: loginButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 40).isActive = true
        NSLayoutConstraint(item: loginButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: loginButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: -40).isActive = true
        NSLayoutConstraint(item: loginButton, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0).isActive = false
        
        self.view.layoutSubviews()
    }
    
    func userIsLogged() {
        UserManager.sharedInstance.userIsLogged(value: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK: FacebookSDK Delegates For Login.
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult){
        switch result {
            
        case .cancelled:
            print("User Cancelled login.")
            break
            
        case .failed(let error):
            print("Error in:")
            print(error)
            break
            
        case .success( _, _, _):
            print("Logged in !")
            if let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,email,name"], httpMethod: "GET"){
                loginFacebookWith(request)
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        UserManager.sharedInstance.userIsLogged(value: false)
        print("Logout From APP")
    }
    
    
    //MARK: Methods For Requests Facebook Login.
    
    func loginFacebookWith(_ request: FBSDKGraphRequest) {
        request.start(completionHandler: { (connection, result, error) in
            if error != nil {
                print("Error -> Login Facebook: \(error)")
                
            } else {
                
                let mapper = Mapper<Profile>()
                var profileCurrentUser = Profile()
                var isUserExists = false
                if let profile = mapper.map(JSON: result as! [String : Any]){
                    UserManager.sharedInstance.saveCurrentUserID(value: profile.id!)
                    isUserExists = ProfileData.sharedInstance.verifyExists(value: profile.id!)
                    profileCurrentUser = profile
                } else {
                    print("Error -> Mapper Object Profile !")
                }
                
                if isUserExists {
                    self.userIsLogged()
                    return
                    
                } else {
                    if let _ = ProfileData.sharedInstance.saveProfile(profileCurrentUser){
                        self.userIsLogged()
                        print("User Saved Successfully in Database !")
                    }
                    
                }
                
            }
            
        })
    }

}
