//
//  ViewController.swift
//  project 25-27 challenge
//
//  Created by Andrew Emad on 28/07/2022.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    var bottomText : String?
    var topText : String?
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func importPictureTapped(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    @IBAction func setTextTapped(_ sender: UIButton) {
        var isBottomText = false
        let title : String
        if sender.titleLabel?.text == "Set Bottom Text"{
            title = "Add Bottom text for your meme"
            isBottomText = true
        }else{
            title = "Add Top text for your meme"
        }

        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addTextField()
        let submit = UIAlertAction(title: "Submit", style: .default){ [weak self,weak alert] action in
            guard let text = alert?.textFields?[0].text else {return}
            if isBottomText {
                self?.bottomText = text
            }else{
                self?.topText = text
            }
            guard let _ = self?.imageView.image else {return}
            if let _ = self?.bottomText , let _ = self?.topText {
                DispatchQueue.main.async {
                    self?.createMeme()
                }
            }
            
        }
        alert.addAction(submit)
        present(alert, animated: true)
    }

    func createMeme(){
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let image = renderer.image{ [unowned self] context in

            guard let topText = topText else {return}
            guard let bottomText = bottomText else {return}

            guard let currentImage = self.imageView.image else {return}
            let imageRect = CGRect(x: 0, y: 0, width: 512, height: 512)
            currentImage.draw(in: imageRect)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attributes : [NSAttributedString.Key:Any] = [
                .foregroundColor : UIColor.white,
                .font : UIFont.systemFont(ofSize: 36,weight: .bold),
                .paragraphStyle : paragraphStyle
            ]
            
            let topAttributedString = NSAttributedString(string: topText, attributes: attributes)
            let bottomAttributedString = NSAttributedString(string: bottomText, attributes: attributes)
            
            let rect1 = CGRect(x: 0, y: 15, width: 512, height: 40)
            topAttributedString.draw(in: rect1)
            
            let rect2 = CGRect(x: 0, y: 400, width: 512, height: 40)
            bottomAttributedString.draw(in: rect2)
            
            
        }
        imageView.image = image
        imageView.sizeToFit()
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        imageView.image = image
        dismiss(animated: true)
    }
}

