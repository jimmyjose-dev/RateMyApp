//
//  RateMyApp.swift
//  RateMyApp
//
//  Created by Jimmy Jose on 08/09/14.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit


class RateMyApp : UIViewController,UIAlertViewDelegate{
    
    private let appIdentifier = NSBundle.mainBundle().bundleIdentifier
    
    
    private let kTrackingAppVersion     = "kTrackingAppVersion"
    private let kFirstUseDate			= "kFirstUseDate"
    private let kAppUseCount			= "kAppUseCount"
    private let kSpecialEventCount		= "kSpecialEventCount"
    private let kCurrentVersion			= "kCurrentVersion"
    private let kDidRateVersion         = "kDidRateVersion"
    private let kRatedVersion           = "kRatedVersion"
    private let kDeclinedToRate			= "kDeclinedToRate"
    private let kDeclinedToRateVersion	= "kDeclinedToRateVersion"
    private let kRemindLater            = "kRemindLater"
    private let kRemindLaterPressedDate	= "kRemindLaterPressedDate"
    
    private var reviewURL = "itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id="
    private var reviewURLiOS7 = "itms-apps://itunes.apple.com/app/id"
    
    
    var promptAfterDays:Double = 30
    var promptAfterUses = 20
    var promptAfterCustomEventsCount = -1
    var daysBeforeReminding:Double = 1
    
    var alertTitle = ""
    var alertMessage = ""
    var alertOKTitle = ""
    var alertCancelTitle = ""
    var alertRateTitle = ""
    var alertRemindLaterTitle = ""
    var appID = ""
    
    
    class var sharedInstance : RateMyApp {
    struct Static {
        static let instance : RateMyApp = RateMyApp()
        }
        return Static.instance
    }
    
    
    private override init(){
        
        super.init()
        
        
    }
    
    internal required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    private func initAllSettings(){
        
        var prefs = NSUserDefaults.standardUserDefaults()
        
        prefs.setObject(getCurrentAppVersion(), forKey: kTrackingAppVersion)
        prefs.setObject(NSDate(), forKey: kFirstUseDate)
        prefs.setInteger(1, forKey: kAppUseCount)
        prefs.setInteger(0, forKey: kSpecialEventCount)
        prefs.setBool(false, forKey: kDidRateVersion)
        prefs.setBool(false, forKey: kDeclinedToRate)
        prefs.setBool(false, forKey: kRemindLater)
        prefs.setObject("", forKey: kDeclinedToRateVersion)
        
    }
    
    func incrementEventUsage(){
        
        var prefs = NSUserDefaults.standardUserDefaults()
        var currentCount = prefs.integerForKey(kSpecialEventCount)
        prefs.setInteger(currentCount+1, forKey: kSpecialEventCount)
        
    }
    
    func incrementAppUsage(){
        
        var prefs = NSUserDefaults.standardUserDefaults()
        var currentCount = prefs.integerForKey(kAppUseCount)
        prefs.setInteger(currentCount+1, forKey: kAppUseCount)
        
    }
    
    
    func trackAppUseage(){
        
        var prefs = NSUserDefaults.standardUserDefaults()
        
        var trackingAppVersion = prefs.objectForKey(kTrackingAppVersion) as? NSString
        
        
        if((trackingAppVersion == nil) || !(getCurrentAppVersion().isEqualToString(trackingAppVersion))){
            
            initAllSettings()
            
        }
        
        if(shouldShowAlert()){
            showRatingAlert()
        }
        
    }
    
    private func shouldShowAlert() -> Bool{
        
        var prefs = NSUserDefaults.standardUserDefaults()
        
        var usageCount = prefs.integerForKey(kAppUseCount)
        
        var firstUse = prefs.objectForKey(kFirstUseDate) as NSDate
        
        var timeInterval = NSDate().timeIntervalSinceDate(firstUse)
        
        var daysCount = ((timeInterval / 3600) / 24)
        
        var hasRateCurrentVersion = prefs.boolForKey(kDidRateVersion)
        
        var hasDeclinedToRate = prefs.boolForKey(kDeclinedToRate)
        
        var hasChosenRemindLater = prefs.boolForKey(kRemindLater)
        
        if(hasDeclinedToRate){
            
            return false
            
        }
        
        
        if(hasRateCurrentVersion)
        {
            
            return true
        }
        
        
        var eventsCount = prefs.integerForKey(kAppUseCount)
        
        if(usageCount >= promptAfterUses){
            
            return true
            
        }
        
        if(daysCount >= promptAfterDays){
            
            return true
        }
        
        if(eventsCount >= eventsCount){
            
            return true
            
        }
        
        if(hasChosenRemindLater){
            
            var remindLaterDate = prefs.objectForKey(kFirstUseDate) as NSDate
            
            var timeInterval = NSDate().timeIntervalSinceDate(remindLaterDate)
            
            var remindLaterDaysCount = ((timeInterval / 3600) / 24)
            
            if(remindLaterDaysCount >= daysBeforeReminding){
                
                return true
            }
            
        }
        
        return false
        
    }
    
    
    private func showRatingAlert(){
        
        
        if(!hasOS8()) {
            let alert = UIAlertView()
            alert.title = alertTitle
            alert.message = alertMessage
            alert.addButtonWithTitle(alertOKTitle)
            alert.addButtonWithTitle(alertCancelTitle)
            alert.addButtonWithTitle(alertRemindLaterTitle)
            alert.show()
            alert.delegate = self
        }else{
            var alert : UIAlertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: alertOKTitle, style:.Destructive, handler: { alertAction in
                self.okButtonPressed()
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            alert.addAction(UIAlertAction(title: alertCancelTitle, style:.Cancel, handler:{ alertAction in
                self.cancelButtonPressed()
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            alert.addAction(UIAlertAction(title: alertRemindLaterTitle, style:.Default, handler: { alertAction in
                self.remindLaterButtonPressed()
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    internal func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
        
        println(buttonIndex)
        
        if(buttonIndex == 0){
            
            okButtonPressed()
        }else if(buttonIndex == 1){
            
            cancelButtonPressed()
        }else if(buttonIndex == 2){
            
            remindLaterButtonPressed()
        }
        alertView.dismissWithClickedButtonIndex(buttonIndex, animated: true)
        
    }
    
    private func deviceOSVersion() -> Float{
        
        var device : UIDevice = UIDevice.currentDevice()!;
        var systemVersion = device.systemVersion;
        var iOSVerion : Float = (systemVersion as NSString).floatValue
        
        return iOSVerion
        
        
    }
    
    private func hasOS8()->Bool{
        
        if(deviceOSVersion() < 8.0) {
            
            return false
        }
        
        return true
        
    }
    
    private func okButtonPressed(){
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: kDidRateVersion)
        
        var appStoreURL = NSURL.URLWithString(reviewURLiOS7+appID)
        
        UIApplication.sharedApplication().openURL(appStoreURL)
        
    }
    
    private func cancelButtonPressed(){
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: kDeclinedToRate)
        
    }
    
    private func remindLaterButtonPressed(){
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: kRemindLater)
        NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: kRemindLaterPressedDate)
        
    }
    
    private func getCurrentAppVersion()->NSString{
        
        return (NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as NSString)
        
    }
    
    
    
}