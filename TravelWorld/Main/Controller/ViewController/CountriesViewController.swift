//
//  CountriesViewController.swift
//  TravelWorld
//
//  Created by Victor de Paula on 22/04/17.
//  Copyright © 2017 Victor de Paula. All rights reserved.
//

import UIKit
import SDWebImage
import AFDateHelper
import SCLAlertView

@objc protocol CountriesViewControllerDelegate: class {
    @objc optional func finishViewCountry()
}

class CountriesViewController: UIViewController {

    //MARK: Outlets
    
    @IBOutlet weak var countryFlagImageView: UIImageView!
    @IBOutlet weak var countryShortNameLabel: UILabel!
    @IBOutlet weak var countryLongNameLabel: UILabel!
    @IBOutlet weak var countryCallingCodeLabel: UILabel!
    @IBOutlet weak var countryDateCheckInLabel: UILabel!
    @IBOutlet weak var countrySelectCheckInDateButton: UIButton!
    @IBOutlet weak var countryCheckInSwitch: UISwitch!
    
    //MARK: Variables
    
    var country: Country = Country()
    var flagFavoriteCountry : String?
    let BASE_URL_FLAGS = (UIApplication.shared.delegate as! AppDelegate).BASE_URL_FLAGS
    weak var delegate: CountriesViewControllerDelegate?
    
    //MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = country.shortname
        if flagFavoriteCountry == "FAVORITE" {
            verifyCountyVisited()
            setCountry()
        } else {
            setCountry()
        }
    }

    func verifyCountyVisited() {
        if country.isvisited! {
           countryCheckInSwitch.isOn = true
        } else {
           countryCheckInSwitch.isOn = false
        }
    }
    
    func setCountry(){
        let country_flag = BASE_URL_FLAGS.replacingOccurrences(of: "[COUNTRY_ID]", with: String(describing: country.id!))
        countryFlagImageView.maskTo(5)
        countryFlagImageView.sd_setImage(with: URL(string:country_flag))
        countryLongNameLabel.text = country.longname
        countryCallingCodeLabel.text = country.callingCode
        country.isvisited = false
        if country.checkin != nil && flagFavoriteCountry == "FAVORITE" {
            countrySelectCheckInDateButton.setTitle(country.checkin, for: .normal)
        }
    }
    
    //MARK: Actions
    
    @IBAction func perfomCheckin(_ sender: Any) {
        if countryCheckInSwitch.isOn {
            if country.checkin != nil {
                country.isvisited = true
            } else {
                countryCheckInSwitch.isOn = false
                SCLAlertView().showError("Atenção", subTitle: "O campo data é obrigatório")
            }
            
            if flagFavoriteCountry == "MAIN"{
                delegate?.finishViewCountry!()
            }
        } else {
            country.isvisited = false
        }
        
         countryVisited(isVisited: country.isvisited!)
    }
    
    @IBAction func performDateCheckin(_ sender: Any) {
        let currentDate = Date()
        var dateComponents = DateComponents()
        dateComponents.month = -3
        let threeMonthAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate)
        DatePickerDialog().show("Escolha Uma Data", doneButtonTitle: "Escolher", cancelButtonTitle: "Cancelar", minimumDate: threeMonthAgo, maximumDate: currentDate, datePickerMode: .date) { (date) in
            if let dt = date {
                var dateString = dt.toString(format: .custom("dd/MM/yyyy"))
                    dateString = dateString.replacingOccurrences(of: "+0000", with: "")
                self.country.checkin = "\(dateString)"
                self.countrySelectCheckInDateButton.setTitle("\(dateString)", for: .normal)
                if self.countryCheckInSwitch.isOn {
                    self.country.isvisited = true
                   CountryData.sharedInstance.updateCountryWith(currentUserUD: UserManager.sharedInstance.getCurrentUserID(), country: self.country)
                   
                }
            }
        }
        
        
    }
    
    func countryVisited(isVisited: Bool){
        if isVisited {
            if let _ = CountryData.sharedInstance.saveCountry(country, userID: UserManager.sharedInstance.getCurrentUserID()!){
                print("Country \(country.shortname) Saved Suceccfully !")
            }
        } else {
            let isSuccess = CountryData.sharedInstance.removeWithUserIdAndCountryId(value: UserManager.sharedInstance.getCurrentUserID()!, countryID: country.id!, attribute: .country)
            if isSuccess {
                print("Country \(country.shortname) Removed Suceccfully !")
            }
        }
    }
}
