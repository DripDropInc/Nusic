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
    
    var passedWikiURL: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wikiWebView.delegate = self
        loadWebPage()
    }
    
    func loadWebPage () {
        let url = URL(string: passedWikiURL!)
        let request = URLRequest(url: url!)
        wikiWebView.loadRequest(request)
        
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

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
