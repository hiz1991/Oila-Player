//
//  RemoteViewController.swift
//  SimpleTableView
//
//  Created by MacBook on 30/03/2015.
//  Copyright (c) 2015 Andrei Puni. All rights reserved.
//
import UIKit
import Foundation
class RemoteViewController:UIViewController{
    
    var requestUrl:String!
    @IBOutlet weak var remoteBlurredView: UIVisualEffectView!
    @IBOutlet var remotView: UIView!
    var user:String!
    
    @IBOutlet weak var userHolder: UITextField!
    
    func tellRemote(command :String){
        request(.GET, requestUrl, parameters: ["set":command])
        .responseString ( completionHandler : {
            (request: NSURLRequest, response: NSHTTPURLResponse?, string: String?, error: NSError?) -> Void in
                println(string)
                if string!.rangeOfString("error") != nil{
                    self.userHolder.text = "not logged in"
                }
        })
    }
    
    @IBAction func playPauseBtn(sender: AnyObject) {
        tellRemote("playPause")
    }
    
    @IBAction func volDownBtn(sender: AnyObject) {
        tellRemote("volumeDown")
    }
    
    
    @IBAction func volUpBtn(sender: AnyObject) {
        tellRemote("volumeUp")
    }
    
    @IBAction func bcBtn(sender: AnyObject) {
        tellRemote("prev")
    }
    
    @IBAction func ffBtn(sender: AnyObject) {
        tellRemote("next")
    }
    
    @IBAction func remoteHide(sender: AnyObject) {
        
//        remoteView.center = remoteCenterPosition
//        UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
//            
////            self.remoteView.center = CGPointMake(0,self.remoteCenterPosition.y);
//            
//            }, completion: {
//                (value: Bool) in
//                self.remoteView.hidden=true
//                self.playerPanel.hidden=false
//            }
//        )
        
    }
     override func viewDidLoad() {
        super.viewDidLoad()
        
        var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        remoteBlurredView.frame = remotView.bounds
        remoteBlurredView.addSubview(visualEffectView)
        self.userHolder.text = user
    }
    
}