//
//  ViewController.swift
//  Project7
//
//  Created by Andrew Emad on 07/07/2022.
//

import UIKit

class ViewController: UITableViewController {

    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    var dataResource : String?
    var isFiltered = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        
        let urlString:String
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        }else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        dataResource = urlString
        if let url = URL(string: urlString){
            if let data = try? Data(contentsOf: url){
                parseJson(json: data)
            }else {
                showError()
            }
        }else {
            showError()
        }
        /*if let url = URL(string: urlString){
            let urlSession = URLSession(configuration: .default)
            let task = urlSession.dataTask(with: url){ (data,response,error) in
                
                if let e = error {
                    print(e.localizedDescription)
                    return
                }

                if let data = data {
                    if let petitions = self.parseJson(json: data){
                        self.petitions = petitions
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
            task.resume()
        }*/
        let rightBarButton = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(credit))
        navigationItem.rightBarButtonItem = rightBarButton
        
        let leftBarButton = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterText))
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    
    @objc func credit(){
        let ac = UIAlertController(title: "Data Credit To :", message: dataResource!, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    @objc func filterText(){
        let ac = UIAlertController(title: "Insert a word", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submit = UIAlertAction(title: "Submit", style: .default){ [weak self,weak ac] action in
            guard let text = ac?.textFields?[0].text else {return}
            self?.filterPetitions(text: text)
        }
        ac.addAction(submit)
        let clear = UIAlertAction(title: "Clear Filter", style: .default){ [weak self] action in
            self?.isFiltered = false
            self?.tableView.reloadData()
        }
        ac.addAction(clear)
        present(ac, animated: true)
    }
    
    func filterPetitions(text :String){
        filteredPetitions.removeAll()
        for petition in petitions {
            if petition.body.contains(text) {
                filteredPetitions.append(petition)
            }else {
                if petition.title.contains(text){
                    filteredPetitions.append(petition)
                }
            }
        }
        isFiltered = true
        tableView.reloadData()
    }
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parseJson(json : Data){
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(Petitions.self, from: json)
            let petitions = decodedData.results
            self.petitions = petitions
        }catch {
            print(error.localizedDescription)
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltered ? filteredPetitions.count : petitions.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if isFiltered {
            cell.textLabel?.text = filteredPetitions[indexPath.row].title
            cell.detailTextLabel?.text = filteredPetitions[indexPath.row].body
        }else {
            cell.textLabel?.text = petitions[indexPath.row].title
            cell.detailTextLabel?.text = petitions[indexPath.row].body
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailsViewController()
        vc.selectedPetitation = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }


}

