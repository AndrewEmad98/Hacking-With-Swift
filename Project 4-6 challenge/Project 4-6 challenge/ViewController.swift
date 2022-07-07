//
//  ViewController.swift
//  Project 4-6 challenge
//
//  Created by Andrew Emad on 07/07/2022.
//

import UIKit

class ViewController: UITableViewController {

    var shoppingList = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        let alertVC = UIAlertController(title: "Shopping List", message: "Add your Item", preferredStyle: .alert)
        alertVC.addTextField()
        
        let submitButton = UIAlertAction(title: "Submit", style: .default){ [weak self , weak alertVC] _ in
            guard let item = alertVC?.textFields?[0].text else {return}
            self?.addItem(item: item)
        }
        alertVC.addAction(submitButton)
        present(alertVC, animated: true)

    }
    
    func addItem(item : String){
        shoppingList.insert(item, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    @IBAction func clearItemsPressed(_ sender: UIBarButtonItem) {
        shoppingList.removeAll()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
    @IBAction func sharePressed(_ sender: UIBarButtonItem) {
        let joinedShoppingList = shoppingList.joined(separator: "\n")
        let vc = UIActivityViewController(activityItems: [joinedShoppingList], applicationActivities: [])
        popoverPresentationController?.barButtonItem = sender
        present(vc, animated: true)
    }
}

