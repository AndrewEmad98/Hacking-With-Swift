//
//  ViewController.swift
//  Project 4
//
//  Created by Andrew Emad on 04/07/2022.
//

import UIKit
import WebKit

class ViewController: UIViewController,WKNavigationDelegate {

    var webView : WKWebView!
    var progressBar : UIProgressView!
    var websites: [String] = []
    var selectedWebsite = ""
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeUI()
        
        let url = URL(string: "https://www.\(selectedWebsite)/")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true

        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
    }
    
    func initializeUI(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: webView, action: nil)
        
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        let backwardButton = UIBarButtonItem(title: "Backward", style: .plain, target: self, action: #selector(goToBackwardPage))
        
        let forwardButton = UIBarButtonItem(title: "Forward", style: .plain, target: self, action: #selector(goToForwardPage))
        
        progressBar = UIProgressView(progressViewStyle: .default)
        progressBar.sizeToFit()
        
        let progressButton = UIBarButtonItem(customView: progressBar)
        
        toolbarItems = [progressButton,refresh,spacer,backwardButton,forwardButton]
        navigationController?.isToolbarHidden = false
        

    }
    @objc func goToBackwardPage(){
        webView.goBack()
    }
    @objc func goToForwardPage(){
        webView.goForward()
    }
    @objc func openTapped(){
        
        let alertVC = UIAlertController(title: "Open Page...", message: nil, preferredStyle: .actionSheet)
        for website in websites {
            alertVC.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(alertVC, animated: true)
        
    }
    
    func openPage(alertAction : UIAlertAction){
        guard let actionTitle = alertAction.title else {return}
        guard let url = URL(string: "https://www.\(actionTitle)/") else {return}
        webView.load(URLRequest(url: url))
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressBar.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        print(url!)
        if url?.absoluteString == "about:blank"{
            decisionHandler(.allow)
            return
        }
        if let host = url?.host {
            for website in websites {
                if host.contains(website){
                    progressBar.isHidden = false
                    decisionHandler(.allow)
                    return
                }
            }
        }
        decisionHandler(.cancel)
        makeAlert()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressBar.isHidden = true
    }

    func makeAlert(){
        let vc = UIAlertController(title: "Blocked", message: "it's blocked", preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "OK", style: .default))
        present(vc, animated: true)
    }
}

