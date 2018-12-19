//
//  NewsViewController.swift
//  ContinuouslyMac
//
//  Created by Steve Martin on 02/06/2016.
//  Copyright © 2016 Steve Martin. All rights reserved.
//

import UIKit
import Foundation

class NewsViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    // The NewsViewController is the controller for the NewsView.
    // This view displays all of the news articles collected from the ContinuouslyMacAPI and displays them in a tableView format.
    // Selecting a cell within the tableView takes the user to the ArticleView where the main article is loaded.
    // Also, pressing the Info button will take the user to the InfoView where information about the app is displayed.


    @IBOutlet weak var tableView: UITableView!

    var textArray: NSMutableArray! = NSMutableArray()
    var dataObject: ContinuouslyMacAPI?
    var refreshControl = UIRefreshControl()
    
    var detailViewURL:String!
    var sourceImageURL:Data!
    var sourceImageLabel:String!
    
    var activityFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Populates the dataObject with data from the ContinuouslyMacAPI
        dataObject = ContinuouslyMacAPI.initContinuouslyMacAPI()
        
        // Sets up the main tableView
        refreshControl.addTarget(self, action: #selector(self.tableViewDataWillRefresh), for: UIControl.Event.valueChanged)
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 478
        self.tableView.contentInset = UIEdgeInsets.init(top: (76), left: 0, bottom: 0, right: 0);
        self.tableView.addSubview(refreshControl)

        print ("log: self.view.frame.width detected at:", self.view.frame.width)
        
        // Initates a timer that will reload the main tableView with data every 5 minutes (60 seconds x 5=300).
        var timer: Timer?
        timer = Timer.scheduledTimer(timeInterval: 300, target: self, selector: #selector(self.tableViewDataWillRefresh), userInfo: nil, repeats: true)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        // Refreshes the main tableView when the view displays.
        tableViewDataWillRefresh()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // Removes the activity indicator if it's still running.
        self.activityFrame.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func pressedHeaderButton(_ sender: AnyObject) {
        // Moves the maintable View to the top if the user presses the logo.
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }


    @IBAction func pressedInfoButton(_ sender: AnyObject) {
        // Takes the juser to the InfoView if the users presses the info button.
        self.activityFrame.removeFromSuperview()
        performSegue(withIdentifier: "NewsViewToInfoView", sender: self)
    }

    
    
    // UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Sets the number of rows within the mainTable view to the same number of items in the dataObject.
        return dataObject!.articles!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Populates the main tableView
        
        // Each tableView cell is controlled by CustomUITableViewCell
        let cell: CustomUITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomUITableViewCell
        
        // Identify the main cell objects
        let descriptionImage = cell.viewWithTag(1) as! UIImageView
        let descriptionText = cell.viewWithTag(2) as! UILabel
        let sourceImage = cell.viewWithTag(3) as! UIImageView
        let sourceText = cell.viewWithTag(4) as! UILabel
        let dateText = cell.viewWithTag(5) as! UILabel
        let categoryText = cell.viewWithTag(6) as! UILabel
        let badgeImage = cell.viewWithTag(7) as! UIImageView

        // Set the main article image object, streching it's height to match the image.
        if (dataObject!.articles![(indexPath as NSIndexPath).row].articlePhoto != nil) {
            let thisDescriptionImage = UIImage(data: dataObject!.articles![(indexPath as NSIndexPath).row].articlePhoto! as Data)!
            descriptionImage.image = thisDescriptionImage
            let thisDescriptionImageHeight = (descriptionImage.image!.size.height / descriptionImage.image!.size.width) * (self.view.frame.width - 30)
            cell.articleImageHeightConstraint.constant = thisDescriptionImageHeight
        } else {
            descriptionImage.image = nil
            descriptionImage.backgroundColor = UIColor.white
            cell.articleImageHeightConstraint.constant = 30
        }
        
        // Populate the article description object
        descriptionText.text = dataObject!.articles![(indexPath as NSIndexPath).row].description
        
        // Set the article source image object, setting it blank if one isn't found.
        if (dataObject!.articles![(indexPath as NSIndexPath).row].sourcePhoto != nil) {
            sourceImage.image = UIImage(data: dataObject!.articles![(indexPath as NSIndexPath).row].sourcePhoto! as Data)!
        } else {
            sourceImage.image = nil
            sourceImage.backgroundColor = UIColor.white
        }
        sourceImage.layer.cornerRadius = 24
        sourceImage.clipsToBounds = true
        
        // Populate the article source name object
        sourceText.text = dataObject!.articles![(indexPath as NSIndexPath).row].sourceName
        
        // Populate the article date object
        let thisTimeStamp: Double = dataObject!.articles![(indexPath as NSIndexPath).row].timestamp
        dateText.text = dataObject!.articles![(indexPath as NSIndexPath).row].articleAge(timestamp: thisTimeStamp)
        
        // Populate the tags label obejct
        categoryText.text = dataObject!.articles![(indexPath as NSIndexPath).row].category
        // tagsText.textColor = UIColor(hexString: "#" + dataObject!.articles![(indexPath as NSIndexPath).row].badgeColour + "FF")
        
        // Set the badge image object
        badgeImage.image = UIImage(named: dataObject!.articles![(indexPath as NSIndexPath).row].badgeImageName())
        
        // add cell border
        let borderView = cell.viewWithTag(21) as! UIImageView
        borderView.layer.borderColor = UIColor(red:222/255, green:225/255, blue:227/255, alpha: 1).cgColor
        borderView.layer.borderWidth = 1
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // When the user presses the cell the NewsView will be loaded with the selected article.
        
        detailViewURL = dataObject!.articles![(indexPath as NSIndexPath).row].articleLink
        sourceImageLabel = dataObject!.articles![(indexPath as NSIndexPath).row].sourceName
        sourceImageURL = dataObject!.articles![(indexPath as NSIndexPath).row].sourcePhoto as Data
        
        self.activityFrame.removeFromSuperview()
        performSegue(withIdentifier: "NewsViewToArticleView", sender: self)
    }

    @objc func tableViewDataWillRefresh() {
        // This function reloads the main tableView with the latest data from the ContinuouslyMacAPI.
        // The function first checks if a refresh is required (based on how long ago it was last refreshed) then it displays an activity indicate to show the the user that the data is loading.
        
        if (dataObject!.refreshRequired()) {
            dataObject!.updateDataObjectFromContinuouslyMacAPI(tableViewDataDidRefresh)
        } else {
            self.tableViewDataDidRefresh()
        }

    }
    
    func tableViewDataDidRefresh() {
        // This function is triggered once the mainTable view has finished being refreshed with data from the ContinuouslyMacAPI.
        // This function also removes the activity indicator to show the user that the refresh is complete.
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
        self.activityFrame.removeFromSuperview()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Before the ArtcileView is loaded it needs to be told about the selected article.
        
        if (segue.identifier == "NewsViewToArticleView") {
            let pageVC : ArticleViewController = segue.destination as! ArticleViewController
            pageVC.webViewURLString = detailViewURL
        }

    }
    
}


extension UIColor {
    // This extension allows the UIColor function to be initiated using a hex code as a string.
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = String(hexString[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}
