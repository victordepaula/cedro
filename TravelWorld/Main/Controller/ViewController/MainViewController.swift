//
//  MainViewController.swift
//  TravelWorld
//
//  Created by Victor de Paula on 18/04/17.
//  Copyright © 2017 Victor de Paula. All rights reserved.
//

import UIKit
import SDWebImage

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CountriesViewControllerDelegate, UITabBarControllerDelegate {

    //MARK: Variables
    
    var CountriesApplicationUser = CountriesApplication()
    var countriesResponse = [Country]()
    let BASE_URL_FLAGS = (UIApplication.shared.delegate as! AppDelegate).BASE_URL_FLAGS
    var refresh = UIRefreshControl()

    
    //MARK: Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicatorCountries: UIActivityIndicatorView!
    
    
    //MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        requestContriesService()
    }
    
    func setupController(){
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "clear_sky"))
        self.collectionView.backgroundColor = .clear
        refresh.tintColor = .gray
        refresh.addTarget(self, action: #selector(refreshCountriesService), for: .valueChanged)
        collectionView.addSubview(refresh)
        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = self
        collectionView.delegate = self
        self.tabBarController?.delegate = self
        collectionView.register(UINib.init(nibName: "CountriesCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CountrieCell")
    }
    
    func requestContriesService(){
        activityIndicatorCountries.startAnimating()
        CountriesApplicationUser.countries(onSuccess: { (result) in
            self.countriesResponse.removeAll()
            self.countriesResponse = result
            self.countriesResponse.sort { $0.shortname! < $1.shortname! }
            self.activityIndicatorCountries.stopAnimating()
            self.collectionView.reloadData()
            
        }, onFailureMessage: { (errorMessage) in
            print(errorMessage)
            self.activityIndicatorCountries.stopAnimating()

        }) { (error) in
            print(error)
            self.activityIndicatorCountries.stopAnimating()
            
        }
    }
    
    func reloadCollectionView(){
        self.collectionView.reloadData()
    }
    
    func refreshCountriesService(){
        refresh.beginRefreshing()
        CountriesApplicationUser.countries(onSuccess: { (result) in
            self.countriesResponse.removeAll()
            self.countriesResponse = result
            self.countriesResponse.sort { $0.shortname! < $1.shortname! }
            self.refresh.endRefreshing()
            self.collectionView.reloadData()
            
        }, onFailureMessage: { (errorMessage) in
            print(errorMessage)
            self.refresh.endRefreshing()
            
        }) { (error) in
            print(error)
            self.refresh.endRefreshing()
            
            
        }
    }
    
    //MARK: Delegates For UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countriesResponse.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CountriesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CountrieCell", for: indexPath) as! CountriesCell
        let country = countriesResponse[indexPath.row]
        cell.shortnameLabel.text = country.shortname
        let country_flag = BASE_URL_FLAGS.replacingOccurrences(of: "[COUNTRY_ID]", with: String(describing: country.id!))
        cell.countryImageView.sd_setImage(with: URL(string:country_flag))
        cell.countryImageView.layer.cornerRadius = 5
        cell.countryImageView.layer.masksToBounds = true
        cell.checkedIcon.isHidden = true
        if let _  = CountryData.sharedInstance.verifyCountryExistWith(userID: UserManager.sharedInstance.getCurrentUserID()!, countryID: country.id!) {
            cell.checkedIcon.isHidden = false
            
        }
     
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let country = countriesResponse[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let countriesViewController = storyboard.instantiateViewController(withIdentifier: "CountriesViewController") as! CountriesViewController
        
        if let countryExists = CountryData.sharedInstance.verifyCountryExistWith(userID: UserManager.sharedInstance.getCurrentUserID()!, countryID: country.id!){
            let countryExist = Country()
            countryExist.id = countryExists.id
            countryExist.shortname = countryExists.shortname
            countryExist.longname = countryExists.longname
            countryExist.callingCode = countryExists.callingCode
            countryExist.isvisited = countryExists.isvisited
            countryExist.checkin = countryExists.checkin
            countriesViewController.country = countryExist
            countriesViewController.flagFavoriteCountry = "FAVORITE"
            self.navigationController?.pushViewController(countriesViewController, animated: true)

        } else {
            countriesViewController.country = country
            countriesViewController.flagFavoriteCountry = "MAIN"
            countriesViewController.delegate = self
            self.navigationController?.pushViewController(countriesViewController, animated: true)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }

    //MARK: Delegates For CountriesViewController
    
    func finishViewCountry(){
        self.collectionView.reloadData()
    }
    
    //MARK: Delegates For UITabBarViewController
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.collectionView.reloadData()
    }
}
