//
//  WebViewController.swift
//  Nusic
//
//  Created by Trevor MacGregor on 2017-04-22.
//  Copyright © 2017 Nusic_Inc. All rights reserved.
//

import UIKit
import MBProgressHUD


class WebViewController: UIViewController, UIWebViewDelegate {
    
    var passedURL: String!

    @IBOutlet weak var webViewer: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webViewer.delegate = self
        loadWebPage()
    }
    
    func loadWebPage () {
        let url = URL(string: passedURL!)
        let request = URLRequest(url: url!)
        webViewer.loadRequest(request)
        
    }

    func webViewDidStartLoad(_ webView: UIWebView) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
}
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
}
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
    print("There was a problem loading the web page!")
}
//
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    

}
