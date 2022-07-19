//
//  ViewController.swift
//  Project 13-15 challenge
//
//  Created by Andrew Emad on 19/07/2022.
//

import UIKit

class ViewController: UITableViewController {

    var countries = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Country App"
        countries = ["Egypt",
                     "Peru",
                     "France",
                     "United States Of America",
                     "Algeria"
        ]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
        cell.textLabel?.text = countries[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        callTheAPI(countryName: countries[indexPath.row])
    }
    
    func callTheAPI(countryName : String){
        let str = "https://restcountries.com/v2/name/\(countryName)"
        guard let urlString = str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlString) else {return}

        let urlSession = URLSession(configuration: .default)
        let dataTask = urlSession.dataTask(with: url){ [weak self] (data,response,error) in
            if let _ = error {
                return
            }
            if let data = data {
                if let countryData = self?.parseJsonData(data: data){
                    DispatchQueue.main.async {
                        if let vc = self?.storyboard?.instantiateViewController(withIdentifier: "Details") as? DetailsViewController {
                            vc.country = countryData
                            self?.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
        }
        dataTask.resume()
    }
    func parseJsonData(data : Data) -> Country? {

        let jsonDecoder = JSONDecoder()
        do{
            let countries = try jsonDecoder.decode([Country].self, from: data)
            return countries[0]
        }catch{
            print(error.localizedDescription)
            return nil
        }
    }

}

