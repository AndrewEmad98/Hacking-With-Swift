//
//  ActionViewController.swift
//  Extension
//
//  Created by Andrew Emad on 20/07/2022.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController{

    var pageTitle = ""
    var pageURL = ""
    
    var userScripts : [String:String] = [:]
    
    @IBOutlet weak var script: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserScripts()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(chooseScript))

        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        

        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: UTType.propertyList.identifier){ [weak self] (dict , error) in
                    guard let itemDictionary = dict as? NSDictionary else {return}
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else {return}
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                    }
                    for (key,value) in self?.userScripts ?? [:] {
                        if let url = URL(string: self?.pageURL ?? ""){
                            if let savedURL = URL(string: key){
                                if url.host == savedURL.host {
                                    DispatchQueue.main.async {
                                        self?.script.text = value
                                    }
                                    break
                                }
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    @objc func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        if let _ = URL(string: pageURL){
            userScripts[pageURL] = script.text
            saveUserScripts()
        }
        let item = NSExtensionItem()
        let arguments : NSDictionary = ["customJavaScript" : script.text ?? ""]
        let webDictionary : NSDictionary = ["NSExtensionJavaScriptFinalizeArgumentKey":arguments]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: UTType.propertyList.identifier)
        item.attachments = [customJavaScript]
        extensionContext?.completeRequest(returningItems: [item])
        
    }

    @objc func adjustForKeyboard(notification : Notification){
        guard let keyboardInfo = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardScreenEndFrame = keyboardInfo.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        }else{
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        script.scrollIndicatorInsets = script.contentInset
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }
    
    @objc func chooseScript(){
        let alert = UIAlertController(title: "Choose Script To run on the browser", message: nil, preferredStyle: .actionSheet)
        let scripts = ["alert(document.title);"]
        for script in scripts {
            alert.addAction(UIAlertAction(title: script, style: .default, handler: scriptsHandler(action:)))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    @objc func scriptsHandler(action : UIAlertAction){
        script.text = action.title ?? ""
        dismiss(animated: true)
    }
    
    func saveUserScripts(){
        let userDefaults = UserDefaults.standard
        userDefaults.set(userScripts, forKey: "scripts")
    }
    func loadUserScripts(){
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let userDefaults = UserDefaults.standard
            if let scripts = userDefaults.object(forKey: "scripts") as? [String:String]{
                self?.userScripts = scripts
            }
        }
    }
}
