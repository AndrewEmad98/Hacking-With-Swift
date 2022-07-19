//
//  DetailsViewController.swift
//  Project 16
//
//  Created by Andrew Emad on 19/07/2022.
//

import UIKit
import WebKit

class DetailsViewController: UIViewController {

    var capitalName : String?
    var webView : WKWebView!
    var urlString = "https://en.wikipedia.org/wiki/"
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        urlString += capitalName ?? ""
        guard let url = URL(string: urlString) else {return}
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    

}
