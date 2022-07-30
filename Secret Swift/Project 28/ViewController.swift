//
//  ViewController.swift
//  Project 28
//
//  Created by Andrew Emad on 30/07/2022.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    
    @IBOutlet weak var secret: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Nothing to see here"
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveSecretItem), name: UIApplication.willResignActiveNotification, object: nil)
        
    }

    func makeBarButton(isHidden : Bool){
        if isHidden {
            navigationItem.rightBarButtonItem = nil
        }else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        }
    }
    @objc func doneTapped(){
        saveSecretItem()
    }
    
    @IBAction func authorizationTapped(_ sender: UIButton) {
        let context = LAContext()
        var error : NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = "Identify yourself!"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason){ [weak self] success,errorHappened in
                DispatchQueue.main.async {
                    if success {
                        self?.unLockSecretItem()
                        self?.makeBarButton(isHidden: false)
                    }else{
                        let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified; please try again.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }
        }else{
            // no face ID or Touch ID authorized in this device
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @objc func adjustKeyboard(notification : Notification){
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        }else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height-view.safeAreaInsets.bottom, right: 0)
        }
        secret.scrollIndicatorInsets = secret.contentInset
        secret.scrollRangeToVisible(secret.selectedRange)
    }
    func unLockSecretItem(){
        secret.isHidden = false
        title = "secret Stuff!"
        secret.text = KeychainWrapper.standard.string(forKey: "secretMessage") ?? ""
    }
    @objc func saveSecretItem(){
        guard secret.isHidden == false else {return}
        KeychainWrapper.standard.set(secret.text, forKey: "secretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true
        title = "Nothing to see here"
        makeBarButton(isHidden: true)
    }
}

