//
//  rootViewController.swift
//  Project 4
//
//  Created by Andrew Emad on 04/07/2022.
//

import UIKit

class rootViewController: UITableViewController {

    
    var websites = ["hackingwithswift.com","apple.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WebsiteHost", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "webView") as! ViewController
        vc.websites = self.websites
        vc.selectedWebsite = websites[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    

}
