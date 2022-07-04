//
//  DetailsViewController.swift
//  project 1-3 challenge
//
//  Created by Andrew Emad on 04/07/2022.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var selectedImage : String?
    var currentImageNumber = 0
    var totalNumberOfImages = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.image = UIImage(named: selectedImage!)
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Picture \(currentImageNumber) of \(totalNumberOfImages)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }

    @IBAction func sharePressed(_ sender: UIBarButtonItem) {
        if let image = imageView.image?.jpegData(compressionQuality: 0.8){
            let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
            vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
            present(vc, animated: true)
        }
    }
}
