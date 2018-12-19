//
//  ContinuouslyMacAPI.swift
//
//  Created by Steve Martin on 09/05/2016.
//  Copyright (c) 2016 Steve Martin. All rights reserved.
//
//
//  The ContinuouslyMacAPI is a 'singleton' class containing an array of ContinuouslyMacDataStructure instances.
//  Note: The Model/Article.swift class is required.
//  Note: The Error.Data.json file is required.
//
//


import Foundation
import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}
;


class ContinuouslyMacAPI {
    
    var articles : [ContinuouslyMacDataStructure]?
    var lastRefreshDate : Date?
    
    fileprivate static var currentAPI : ContinuouslyMacAPI?
    
    // The latest version of the Continuously Mac API
    let continuouslyMacAPIURL = "http://api.continuously-mac.com/"
    
    // The initContinuouslyMacAPI function ensures that ContinuouslyMacAPI is a 'singleton' class.
    static func initContinuouslyMacAPI() -> ContinuouslyMacAPI {
        
        if currentAPI == nil {
            currentAPI = ContinuouslyMacAPI()
            currentAPI!.articles = [ContinuouslyMacDataStructure]()
            currentAPI!.lastRefreshDate = nil
        }
        
        return currentAPI!
    }
    
    
    func updateDataObjectFromContinuouslyMacAPI(_ completion: (() -> Void)?) {
        // The updateDataObjectFromContinuouslyMacAPI function performs the API call that populates the ContinuouslyMacAPI with the latest data from the Continuously Mac Website.
        
        // later consider add the following to the URL string for tracking: UIDevice.current.identifierForVendor!.uuidString
        print("log: Requesting API data from \(continuouslyMacAPIURL).")
        
        // Sets the URL session up.
        let sessionconfig = URLSessionConfiguration.default
        sessionconfig.timeoutIntervalForRequest = 8
        sessionconfig.timeoutIntervalForResource = 8
        
        let session = URLSession(configuration: sessionconfig)
        
        let continuouslyMacUrl = URL(string: continuouslyMacAPIURL)
        
        // Executes the data task with the Continuously Mac API url.
        let task = session.dataTask(with: continuouslyMacUrl!, completionHandler: {
            (data,response, error) -> Void in

            var articles = [ContinuouslyMacDataStructure]()
            var articleData: NSArray = []
            
            if error != nil {
                // Error executing the data task with that URL.
                print("error: \(error!.localizedDescription)")
                articleData = self.setAsErrorData()
            } else {
                do {
                    // The data task successfully populates the articleData object with data from the API url.
                    articleData = (try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSArray
                } catch {
                    // The url can not be found, switching to local error file instead.
                    print("error: url can not be found, switching to local error file instead.")
                    articleData = self.setAsErrorData()
                }
            }
            
            // Populates the articles object with data from the articleData in the structure defined by the ContinuouslyMacDataStructure object.
            for article in articleData {
                let article = ContinuouslyMacDataStructure(data: article as! NSDictionary)
                if (article.sourcePhotoURL != "") {
                    article.sourcePhoto = try? Data(contentsOf: URL(string: article.sourcePhotoURL)!)
                }
                if (article.articlePhotoURL != "") {
                    article.articlePhoto = try? Data(contentsOf: URL(string: article.articlePhotoURL)!)
                }
                articles.append(article)
            }
            
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                DispatchQueue.main.async {
                    self.articles?.removeAll()
                    self.articles = articles
                    print ("TEMP: Article Count: \(self.articles?.count as Int?)")
                    if (self.articles?.count > 1) {
                        print ("TEMP: >1")
                        self.lastRefreshDate = Date()
                    } else {
                        print ("TEMP: =<1")
                        self.lastRefreshDate = nil
                    }
                    completion!()
                }
            }
        }) 
        
        task.resume()
        
    }
    

    func refreshRequired () -> Bool {
        //  The refreshRequired function checks the timestamp of the last API call and returns a 'true' or 'false' depending on if more than 5 minutes has passed since the last refresh.
        
        var refreshRequiredResult: Bool = false
        let oldDate = self.lastRefreshDate
        
        print("log: the last refresh date of the API was: \(self.lastRefreshDate as Date?).")
        
        if (oldDate != nil) {
            let newDate:Date = Date()
            let cal = Calendar.current
            let unit:NSCalendar.Unit = .minute
            let components = (cal as NSCalendar).components(unit, from: oldDate!, to: newDate, options: [])
            
            if (components.minute > 5) {
                refreshRequiredResult = true
                print("log: older than 5 minutes. Refresh needed.")
            } else {
                print("log: the api was refreshed less than 5 minutes ago - \(components.minute as Int?) minute(s) ago. Refresh NOT needed.")
            }
        } else {
            refreshRequiredResult = true
            print("log: last refresh date unknown. Refresh needed.")
        }
        
        return refreshRequiredResult
    }
    
    

    func setAsErrorData () -> NSArray {
        //  The setAsErrorData function populates the ContinuouslyMacAPI with an error message (based on data found in a local error file) notifying the user that the app was unable to collect data from the Continuously Mac API.
        
        var thisErrorData: NSArray = []
        
        if let filepath = Bundle.main.path(forResource: "Error.Data", ofType: "json") {
            do {
                // loading error file into the articleData NSArray
                let errorFile = try NSString(contentsOfFile: filepath, usedEncoding: nil) as String
                let errorData = errorFile.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                
                thisErrorData = try! JSONSerialization.jsonObject(with: errorData, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
            } catch {
                // error file contents could not be loaded
                print("error: error file contents could not be loaded")
            }
        } else {
            // error file not found
            print("error: error file not found")
        }
        
        return thisErrorData
    }
    
    
    
}
