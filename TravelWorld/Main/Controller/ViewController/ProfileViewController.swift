//
//  ProfileViewController.swift
//  TravelWorld
//
//  Created by Victor de Paula on 21/04/17.
//  Copyright © 2017 Victor de Paula. All rights reserved.
//

import UIKit
import SDWebImage
import FacebookLogin

class ProfileViewController: UIViewController, LoginButtonDelegate {

    //MARK: Outlets
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var panelInformationProfile: UIView!
    @IBOutlet weak var nameProfile: UILabel!
    @IBOutlet weak var emailProfile: UILabel!
    
    
    //MARK: Variables
    
    static let sharedInstance : ProfileViewController = {
        let instance = ProfileViewController()
        return instance
    }()
    let profileImage = (UIApplication.shared.delegate as! AppDelegate).BASE_URL_PHOTO_PROFILE

    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupView()
        getProfile()
    }
    
    func setupViewController(){
        let loginButton = LoginButton(readPermissions: [.publicProfile, .email])
        loginButton.delegate = self
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        loginButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 5).isActive = true
        loginButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -5).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    func setupView(){
        self.navigationController?.isNavigationBarHidden = false
        panelInformationProfile.layer.cornerRadius = 5
        panelInformationProfile.layer.masksToBounds = true
        profileImageView.maskToCircle()
    }
    
    func getProfile(){
        if let profile = ProfileData.sharedInstance.getProfileWith(currentUserID: UserManager.sharedInstance.getCurrentUserID()){
           let urlImage = profileImage.replacingOccurrences(of: "[USER_ID]", with: "\(profile.id!)")
            profileImageView.sd_setImage(with: URL(string: urlImage))
            nameProfile.text = profile.name
            emailProfile.text = profile.email
        }
    }
    
    //MARK: FacebookSDK Delegates For Login.
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {}
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        UserManager.sharedInstance.userIsLogged(value: false)
        self.dismiss(animated: true, completion: ({() in LoginViewController.sharedInstance.setupViewController()}))
        print("Logout From APP")
        
    }
}
