//
//  CountriesVisitedViewController.swift
//  TravelWorld
//
//  Created by Victor de Paula on 22/04/17.
//  Copyright © 2017 Victor de Paula. All rights reserved.
//

import UIKit
import SDWebImage

class CountriesVisitedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UILabel!
    
    //MARK: Variables

    var countriesArray: [Country]?
    let BASE_URL_FLAGS = (UIApplication.shared.delegate as! AppDelegate).BASE_URL_FLAGS

    
    //MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        requestCountries()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        requestCountries()
    }
    
    func setupViewController(){
        self.emptyView.isHidden = true
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "CountriesVisitedCell", bundle: Bundle.main), forCellReuseIdentifier: "CountriesVisitedCell")
    }
    
    func requestCountries(){
        if let countries = CountryData.sharedInstance.getCountriesWith(userId: UserManager.sharedInstance.getCurrentUserID()!){
            countriesArray?.removeAll()
            countriesArray = countries
            countriesArray?.sort { $0.shortname! < $1.shortname! }
            tableView.reloadData()
        }
        
        if countriesArray?.count == 0 {
            self.tableView.isHidden = true
            self.emptyView.isHidden = false
        } else {
            self.tableView.isHidden = false
            self.emptyView.isHidden = true
        }
    }
    
    //MARK: Delegates For UITableView.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesArray?.count ?? 0
    }
    //montagem da celulla
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountriesVisitedCell", for: indexPath) as! CountriesVisitedCell
        
        if let country = countriesArray?[indexPath.row] {
            cell.countryShortnameLabel.text = country.shortname
            let country_flag = BASE_URL_FLAGS.replacingOccurrences(of: "[COUNTRY_ID]", with: String(describing: country.id!))
            cell.countryFlagImageView.maskTo(5)
            cell.countryFlagImageView.sd_setImage(with: URL(string:country_flag))
        }
        
        return cell
    }
    //quando a celula e clickada
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let country = countriesArray?[indexPath.row]{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let countriesViewController = storyboard.instantiateViewController(withIdentifier: "CountriesViewController") as! CountriesViewController
            countriesViewController.country = country
            countriesViewController.flagFavoriteCountry = "FAVORITE"
            self.navigationController?.pushViewController(countriesViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 93.0
    }

}
