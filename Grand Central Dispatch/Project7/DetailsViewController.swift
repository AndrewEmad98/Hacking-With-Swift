//
//  DetailsViewController.swift
//  Project7
//
//  Created by Andrew Emad on 07/07/2022.
//

import UIKit
import WebKit

class DetailsViewController: UIViewController {

    var webView : WKWebView!
    var selectedPetitation : Petition?
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style>body{font-size : 150% }</style>
        </head>
        <body>
        \(selectedPetitation?.body ?? "")
        </body>
        </html>
        """
        webView.loadHTMLString(html, baseURL: nil)
    }
    

    

}
