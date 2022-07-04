//
//  ViewController.swift
//  project 1-3 challenge
//
//  Created by Andrew Emad on 04/07/2022.
//

import UIKit

class ViewController: UITableViewController {

    var flags = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        flags += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Flags Storm"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flags.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Flag", for: indexPath)
        cell.imageView?.image = UIImage(named: flags[indexPath.row])
        cell.imageView?.layer.borderWidth = 1.0
        cell.imageView?.layer.borderColor = UIColor.lightGray.cgColor
        //cell.textLabel?.text = flags[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "Details") as! DetailsViewController
        vc.selectedImage = flags[indexPath.row]
        vc.totalNumberOfImages = flags.count
        vc.currentImageNumber = indexPath.row + 1
        navigationController?.pushViewController(vc, animated: true)
    }


}

