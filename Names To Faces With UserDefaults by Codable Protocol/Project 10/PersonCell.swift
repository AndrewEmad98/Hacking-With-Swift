//
//  PersonCell.swift
//  Project 10
//
//  Created by Andrew Emad on 11/07/2022.
//

import UIKit

class PersonCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func changeImage(imagePath : String){
        imageView.image = UIImage(contentsOfFile: imagePath)
        imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 3
    }
    func changeLabel(name : String){
        label.text = name
    }
}
