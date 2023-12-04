//
//  WebViewViewController.swift
//  TGLiveScan
//
//  Created by apple on 11/22/23.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {

    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        let loadURL = "https://www.ticketgateway.com/pages/mobileapp/"
        let url = URL(string: loadURL)
        webView.load(URLRequest(url: url!))
    }
}
