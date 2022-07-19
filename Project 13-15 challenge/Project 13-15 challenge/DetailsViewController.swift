//
//  DetailsViewController.swift
//  Project 13-15 challenge
//
//  Created by Andrew Emad on 19/07/2022.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    
    @IBOutlet weak var populationLabel: UILabel!
    
    @IBOutlet weak var currencyLabel: UILabel!
    

    @IBOutlet weak var languageLabel: UILabel!
    
    var country : Country!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        countryNameLabel.text = country.name
        capitalLabel.text = country.capital
        regionLabel.text = country.region
        populationLabel.text = String(country.population)
        currencyLabel.text = country.currencies[0].name
        languageLabel.text = country.languages[0].name
    }
    

}
