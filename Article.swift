//
//  ContinuouslyMacDataStructure.swift
//
//  Created by Steve Martin on 09/05/2016.
//  Copyright (c) 2016 Steve Martin. All rights reserved.
//
//
//  The Model/Article describes the fields and functions available through the ContinuouslyMacAPI.
//
//

import Foundation

class ContinuouslyMacDataStructure
{
    var sourceName : String
    var sourcePhotoURL : String
    var articleLink : String
    var articlePhotoURL : String
    var description : String
    var date : String
    var timestamp : Double
    var score : String
    var category : String
    var category_badge : String
    var tags : String
    
    var sourcePhoto : Data!
    var articlePhoto : Data!
    var articleImageData : Data?
    var sourceImageData : Data?
    
    init(data: NSDictionary) {
        // The following defines the available fields for the ContinuouslyMacAPI object
        self.sourceName = getStringFromJSON(data, key: "source_name")
        self.sourcePhotoURL = getStringFromJSON(data, key: "source_photo")
        self.articleLink = getStringFromJSON(data, key: "article_link")
        self.articlePhotoURL = getStringFromJSON(data, key: "article_photo")
        self.description = getStringFromJSON(data, key: "article_description")
        self.date = getStringFromJSON(data, key: "publish_date")
        self.timestamp = getTimestampFromJSON(data, key: "timestamp")
        self.score = getStringFromJSON(data, key: "score")
        self.category = getStringFromJSON(data, key: "category")
        self.category_badge = getStringFromJSON(data, key: "category_badge")
        self.tags = getStringFromJSON(data, key: "tags")
    }
    

    func articleAge (timestamp:Double) -> String {
        // The articleAge function calculates how old the article is (from the time the function is executed) based on the articles published date.
        
        var result : String

        // Collects the date when the articles was published.
        result = ""
        
        // current time
        let now = NSDate().timeIntervalSince1970 * 1000
        
        // time since message was sent in seconds
        let delta = Int((now - timestamp) / 1000);
        
        // format string
        if (delta < 60) {
            result = "Just Now."
        } else if (delta < 130) { // sent in last minute
            result = "Posted about \(delta) seconds ago."
        } else if (delta < 7210) { // sent in last hour
            result = "Posted about \(delta / 60) minutes ago."
        } else if (delta < 172810) { // sent on last day
            result = "Posted about \(delta / 3600) hours ago."
        } else { // sent more than one day ago
            result = "Posted about \(delta / 86400) days ago."
        }
        
        if (timestamp == 0) {
            result = ""
        }
        
        return result
    }
    

    
    func badgeImageName () -> String {
        // The badgeImageName function looks up the badgeValue and determins the name of the badge image stored in images.xcassets.
        
        var thisBadgeImageName : String

        let thisBadgeValue: String = self.category_badge.lowercased()
        print("log: Article.badgeName() input: \(thisBadgeValue)!")
        
        // Returns the Badge Name. Default is the standard news badge.
        switch thisBadgeValue {
        case "error":
            thisBadgeImageName = "BadgeError"
        case "applemusic_badge":
            thisBadgeImageName = "BadgeAppleMusic"
        case "appletv_badge":
            thisBadgeImageName = "BadgeAppleTv"
        case "applewatch_badge":
            thisBadgeImageName = "BadgeAppleWatch"
        case "appstore_badge":
            thisBadgeImageName = "BadgeAppStore"
        case "ibooks_badge":
            thisBadgeImageName = "BadgeiBooks"
        case "imac_badge":
            thisBadgeImageName = "BadgeiMac"
        case "ipad_badge":
            thisBadgeImageName = "BadgeiPad"
        case "iphone_badge":
            thisBadgeImageName = "BadgeiPhone"
        default:
            thisBadgeImageName = "BadgeNews"
        }

        print("log: Article.badgeName() output: \(thisBadgeImageName)!")
        return thisBadgeImageName
    }
    
}


func regexReplace (_ thisString:String, replaceThis: String, withThis: String) -> String {
    // The following helper function performs a regex replace on a string and returns the modified string.
    
    var modString: String = ""
    
    if let regex = try? NSRegularExpression(pattern: replaceThis, options: .caseInsensitive) {
        modString = regex.stringByReplacingMatches(in: thisString, options: .withTransparentBounds, range: NSMakeRange(0, thisString.count), withTemplate: withThis)
    }
    
    return modString
}


func getStringFromJSON(_ data: NSDictionary, key: String) -> String {
    // The following helper function retrieves a string from within a JSON object
    
    if let info = data[key] as? String {
        return info
    }
    return ""
}

func getTimestampFromJSON(_ data: NSDictionary, key: String) -> Double {
    // The following helper function retrieves a string from within a JSON object
    
    if let info = data[key] as? Double {
        return info
    }
    return 0
}


extension Date {
    func daysFrom(_ date:Date) -> Int{
        // This extension function allows the NSDate function to return the time remaining as days.
        return (Calendar.current as NSCalendar).components(.day, from: date, to: self, options: []).day!
    }
    func hoursFrom(_ date:Date) -> Int{
        // This extension function allows the NSDate function to return the time remaining as hours.
        return (Calendar.current as NSCalendar).components(.hour, from: date, to: self, options: []).hour!
    }
    func minutesFrom(_ date:Date) -> Int{
        // This extension function allows the NSDate function to return the time remaining as minutes.
        return (Calendar.current as NSCalendar).components(.minute, from: date, to: self, options: []).minute!
    }
    func secondsFrom(_ date:Date) -> Int{
        // This extension function allows the NSDate function to return the time remaining as seconds.
        return (Calendar.current as NSCalendar).components(.second, from: date, to: self, options: []).second!
    }
}
