//
//  DetailsViewController.swift
//  Project 1
//
//  Created by Andrew Emad on 03/07/2022.
//

import UIKit

class DetailsViewController: UIViewController {

    var selectedImage : String?
    var totalImages : Int?
    var currentImageNumber : Int?
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Picture \(currentImageNumber!) of \(totalImages!)"
        navigationItem.largeTitleDisplayMode = .never
        
        if let loadImage = selectedImage {
            imageView.image = UIImage(named: loadImage)
        }
    }
    
    @IBAction func sharedPressed(_ sender: Any) {
        if let image = imageView.image?.jpegData(compressionQuality: 0.8){
            let vc = UIActivityViewController(activityItems: [image,selectedImage!], applicationActivities: [])
            vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
            present(vc, animated: true)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }

}
