//
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient, withOptions: nil, error: nil)
        
        // deliberate leak here
        
        NSNotificationCenter.defaultCenter().addObserverForName(
            AVAudioSessionRouteChangeNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: {
                (note:NSNotification!) in
                println("change route \(note.userInfo)")
                println("current route \(AVAudioSession.sharedInstance().currentRoute)")
        })
        // properly, if the route changes from some kind of Headphones to Built-In Speaker,
        // we should pause our sound (doesn't happen automatically)
        
        NSNotificationCenter.defaultCenter().addObserverForName(
            AVAudioSessionInterruptionNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: {
                (note:NSNotification!) in
                let why : AnyObject? = note.userInfo?[AVAudioSessionInterruptionTypeKey]
                if let why = why as? UInt {
                    if let why = AVAudioSessionInterruptionType(rawValue: why) {
                        if why == .Began {
                            println("interruption began:\n\(note.userInfo!)")
                        } else {
                            println("interruption ended:\n\(note.userInfo!)")
                            let opt : AnyObject? = note.userInfo![AVAudioSessionInterruptionOptionKey]
                            if let opt = opt as? UInt {
                                let opts = AVAudioSessionInterruptionOptions(opt)
                                if opts == .OptionShouldResume {
                                    println("should resume")
                                } else {
                                    println("not should resume")
                                }
                            }
                        }
                    }
                }
        })
        
        // use control center to test, e.g. start and stop a Music song
        
        NSNotificationCenter.defaultCenter().addObserverForName(
            AVAudioSessionSilenceSecondaryAudioHintNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: {
                (note:NSNotification!) in
                let why : AnyObject? = note.userInfo?[AVAudioSessionSilenceSecondaryAudioHintTypeKey]
                if let why = why as? UInt {
                    if let why = AVAudioSessionSilenceSecondaryAudioHintType(rawValue:why) {
                        if why == .Begin {
                            println("silence hint begin:\n\(note.userInfo!)")
                        } else {
                            println("silence hint end:\n\(note.userInfo!)")
                        }
                    }
                }
        })
        
         NSNotificationCenter.defaultCenter().addObserverForName(
            AVPlayerItemDidPlayToEndTimeNotification, object:nil,queue: NSOperationQueue.mainQueue(), usingBlock: {
                (note:NSNotification!) in
                println(note)
         })
        return true
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        println("app became active")
        AVAudioSession.sharedInstance().setActive(true, withOptions: nil, error: nil)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }


    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        let action = url.lastPathComponent
        
        if action == "connect" {
            // Account linked to Dropbox -- db-gmd9bz0ihf8t30o://1/connect
            let account = DBAccountManager.sharedManager().handleOpenURL(url)
            
            if let account = account {
                // App linked successfully!
                
                // Migrate any local datastores to Dropbox
                let localDatastoreManager = DBDatastoreManager.localManagerForAccountManager(DBAccountManager.sharedManager())
                localDatastoreManager.migrateToAccount(account, error: nil)
                
                // Use Dropbox datastores
                DBDatastoreManager.setSharedManager(DBDatastoreManager(forAccount:account))
                
                return true
            }
        } else if action == "cancel" {
            // Do nothing if user cancels login
        } else {
            // Shared datastore -- Lists://
            let datastoreId = url.host
            
            println("Opening datastore ID: " + datastoreId!)
            
            // Return to root view controller
            let navigationController = self.window?.rootViewController as! UINavigationController;
            navigationController.popToRootViewControllerAnimated(false)
            
            let account = DBAccountManager.sharedManager().linkedAccount
            
            if let account = account {
                // Go to the shared list (will open the list)
                if DBDatastore.isValidShareableId(datastoreId) {
                    
//                    let viewController = storyboard?.instantiateViewControllerWithIdentifier("ListViewController") as ListViewController
//                    viewController.datastoreId = datastoreId!
//                    
//                    navigationController.pushViewController(viewController, animated: false)
                } else {
                    // Notify user that this isn't a valid link
                    let alertController = UIAlertController(title: "Uh oh!", message: "Invalid List link.", preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
                    window?.rootViewController!.presentViewController(alertController, animated: true, completion: nil)
                }
            } else {
                // Notify user to link with Dropbox
                let alertController = UIAlertController(title: "Link to Dropbox", message: "To accept a shared list you'll need to link to Dropbox first.", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
                window?.rootViewController!.presentViewController(alertController, animated: true, completion: nil)
            }
            
            return true
        }
        
        return  false
    }

}

