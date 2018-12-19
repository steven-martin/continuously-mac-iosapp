//
//  ArticleViewController.swift
//  ContinuouslyMac
//
//  Created by Steve Martin on 02/06/2016.
//  Copyright © 2016 Steve Martin. All rights reserved.
//

import UIKit
import WebKit

class ArticleViewController: UIViewController {
    // The ArticleViewController is the controller for the ArticleView.
    // This view displays the main web page of a selected article.
    
    @IBOutlet weak var webView: UIWebView!

    var webViewURLString : String = ""
    var activityFrame = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        // When the view is displayed the webView object starts loading the assigned URL, collected from the webViewString variable - which is populated based on the selected article.
        
        let url = URL(string: webViewURLString)
        let request = URLRequest(url: url!)
        
        print("log: loading web article at url: \(url as Optional).")
        self.webView.loadRequest(request)
        self.webView.scrollView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0);

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // When the view disappears it rempoves any 'live' activity indicators and then the loaded web view.
        self.webView.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 

    
}
