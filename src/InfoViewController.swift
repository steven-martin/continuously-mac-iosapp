//
//  InfoViewController.swift
//  ContinuouslyMac
//
//  Created by Steve Martin on 03/06/2016.
//  Copyright © 2016 Steve Martin. All rights reserved.
//

import UIKit
import WebKit

class InfoViewController: UIViewController {
    // The InfoViewController is the controller for the InfoView.
    // This view displays some basic informtion about the app including an introduction, the version number and who built it.
    
    @IBOutlet weak var infoUILabel: UILabel!
    @IBOutlet weak var steveEmailButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Populates the main page description with the following text.
        infoUILabel.text = "Continuously Mac is a news aggregator dedicated to finding you the latest apple news from the very best Tech Journalists.\n\nNo complex categories to navigate, just a simple list of great Apple news."
        
        steveEmailButton.layer.borderWidth = 1
        steveEmailButton.layer.cornerRadius = 7
        steveEmailButton.layer.borderColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0).cgColor
        steveEmailButton.titleLabel?.textColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
    }
    

    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewDidDisappear(_ animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func pressedSteveEmailButton(_ sender: AnyObject) {
        // Sends the user to the mail app with my email address populated, when they click on the email button.
        //let url = NSURL(string: "mailto:steven.martin@me.com")
        let url = URL(string: "http://stevenpaulmartin.uk")
        UIApplication.shared.openURL(url!)
    }
    
    
    
}
