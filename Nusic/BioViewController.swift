//
//  BioViewController.swift
//  Nusic
//
//  Created by Trevor MacGregor on 2017-04-25.
//  Copyright © 2017 Nusic_Inc. All rights reserved.
//

import UIKit

class BioViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var wikiWebView: UIWebView!
    
    var passedWikiURL: String? {
        didSet {
            guard let _ = wikiWebView else {
                return
            }
            loadWebPage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wikiWebView.delegate = self
        loadWebPage()
    }
    
    func showUrlAlert()
    {
        let shareAlert = UIAlertController(title: "Error", message: "Sorry... that URL does not exist. Have you tried searching for Slayer? They're pretty cool.", preferredStyle: .alert)
        let action = UIAlertAction (title: "Dismiss", style: .cancel, handler: nil)
        
        shareAlert.addAction(action)
        present(shareAlert, animated: true, completion: nil)
    }

    
    func loadWebPage () {
        guard let wikiURL = self.passedWikiURL else {
            return
        }
        print(#line, wikiURL)
        let url = URL(string: wikiURL)
        if url == nil {
        showUrlAlert()
            self.navigationController?.popViewController(animated: true)
            
        } else {
        let request = URLRequest(url: url!)
        wikiWebView.loadRequest(request)
        }
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
    
    deinit {
        
    }
    
    
    
    
    
}
