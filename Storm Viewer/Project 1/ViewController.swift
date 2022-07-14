//
//  ViewController.swift
//  Project 1
//
//  Created by Andrew Emad on 03/07/2022.
//

import UIKit

class ViewController: UITableViewController {
    
    var pictures = [String]()

    var selectedPicture : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        title = "StormViewer"
        navigationController?.navigationBar.prefersLargeTitles = true
    
        performSelector(inBackground: #selector(fetchImages), with: nil)
        
    }
    
    @objc func fetchImages(){
        let path = Bundle.main.resourcePath!
        let items = try! FileManager.default.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        pictures = pictures.sorted(by: <)
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailsViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.totalImages = pictures.count
            vc.currentImageNumber = indexPath.row + 1
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PictureName", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }

    

}

