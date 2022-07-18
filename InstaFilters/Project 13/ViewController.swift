//
//  ViewController.swift
//  Project 13
//
//  Created by Andrew Emad on 17/07/2022.
//

import UIKit
import CoreImage

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var intensity: UISlider!
    @IBOutlet weak var imageView: UIImageView!
    var currentImage : UIImage!
    
    var context : CIContext!
    var currentFilter : CIFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //title = "InstaFilters"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPicture))
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
        title = "CISepiaTone"
    }
    
    @objc func addPicture(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

    @IBAction func changeFilter(_ sender: UIButton) {
       let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
       ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
       ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
       ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
       ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
       ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
       ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
       ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
       ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
       if let presentationController = ac.popoverPresentationController {
            presentationController.sourceView = sender
            presentationController.sourceRect = sender.bounds
       }
      
       present(ac, animated: true)
    }
    
    @IBAction func intensityChanged(_ sender: UISlider) {
        applyProcessing()
    }
    
    @IBAction func save(_ sender: UIButton) {
        guard let image = imageView.image else {
            let alert = UIAlertController(title: "No photo is added", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(alert, animated: true)
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    

    func applyProcessing(){
        guard let outputImage = currentFilter.outputImage else {return}

        let inputKeys = currentFilter.inputKeys

        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(intensity.value * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey) }
        if inputKeys.contains(kCIInputCenterKey) { currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey) }
        
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent){
            let processedImage = UIImage(cgImage: cgImage)
            imageView.image = processedImage
        }
    }
    func setFilter(action:UIAlertAction){
        
        guard currentImage != nil else { return }
        guard let filterName = action.title else {return}
        title = filterName
        
        currentFilter = CIFilter(name: filterName)
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        dismiss(animated: true)
        
        imageView.alpha = 0
        UIView.animate(withDuration: 5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: [], animations: {
            self.imageView.alpha = 1
        }){ _ in }
        
        currentImage = image
        
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    @objc func image(_ image : UIImage ,didFinishSavingWithError error : Error? ,contextInfo: UnsafeRawPointer ){
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}

