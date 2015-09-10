//
//  Login.swift
//  SimpleTableView
//
//  Created by MacBook on 28/03/2015.
//  Copyright (c) 2015 Andrei Puni. All rights reserved.
//
import UIKit
import Foundation
let dl:Downloader = Downloader()
var paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask);
var documentsURL:NSURL =  paths[0] as! NSURL;

var site: String = "http://musicgo.wc.lt/" //"http://172.20.10.5:8888/"//"http://localhost:8888/" //
class Login:UIViewController,UITextFieldDelegate,  NSURLSessionDelegate  {
    @IBOutlet weak var loginErrLabel: UILabel!
    
    @IBOutlet weak var usernameHolder: UITextField!
    @IBOutlet weak var passwordHolder: UITextField!
    @IBOutlet weak var loginPanel: UIView!

    @IBOutlet weak var circle: UIActivityIndicatorView!
    var jsonObject:NSDictionary!
     var session = NSURLSession.sharedSession()
    
    @IBAction func loginButtonClicked(sender: AnyObject) {
        circle.startAnimating()
//                request(.POST, site+"login.php", parameters: ["loginUsername":usernameHolder.text ,
//                    "loginPassword" :passwordHolder.text,
//                    "json" : "enabled"
//                    ])
        request(.POST, site+"login.php", parameters: ["loginUsername":"hiz1991@mail.ru" ,
            "loginPassword" :"1991",
            "json" : "enabled"
            ])
            .responseString( completionHandler : {
                (request: NSURLRequest, response: NSHTTPURLResponse?, string: String?, error: NSError?) -> Void in
                println(string)
                if string?.rangeOfString("success") != nil{
                    self.loadData()
                }
                else{
                    if string?.rangeOfString("fail") != nil{
                        self.loginErrLabel.text = "Incorrect Login or Password! try again"
                    } else{
                       self.loginErrLabel.text = "Connection error! try again"
                    }
                }
        })
    
    }
    
    func loadData(){
        request(.POST, site+"getJson.php")
            .responseString( completionHandler : { (request: NSURLRequest, response: NSHTTPURLResponse?, string: String?, error: NSError?) -> Void in
//                self.json = JSON(string!)
                let str = string! as NSString
                self.jsonObject = parseJSON(str.dataUsingEncoding(NSUTF8StringEncoding)!)
                //                            println(js["Songs"]![0])
                //                            self.populate(json)
                //                            println("reached")
                self.performSegueWithIdentifier("showPlayerSegue", sender: [])
            })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.passwordHolder.delegate = self
        let fileManager:NSFileManager = NSFileManager.defaultManager()
        var error : NSError?
        if fileManager.fileExistsAtPath(documentsURL.URLByAppendingPathComponent("mp3").path!) != true
        {
            fileManager.createDirectoryAtPath(documentsURL.URLByAppendingPathComponent("mp3").path!, withIntermediateDirectories: false, attributes: nil, error: &error)
        }
        
        if fileManager.fileExistsAtPath(documentsURL.URLByAppendingPathComponent("artwork").path!) != true
        {
            fileManager.createDirectoryAtPath(documentsURL.URLByAppendingPathComponent("artwork").path!, withIntermediateDirectories: false, attributes: nil, error: &error)
        }
        
        if fileManager.fileExistsAtPath(documentsURL.URLByAppendingPathComponent("thumbs").path!) != true
        {
            fileManager.createDirectoryAtPath(documentsURL.URLByAppendingPathComponent("thumbs").path!, withIntermediateDirectories: false, attributes: nil, error: &error)
        }
        
        loginButtonClicked([])

    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var playerVC = segue.destinationViewController as! ViewController
        playerVC.site = site;
//        playerVC.json = self.json;
        playerVC.jsonObject = self.jsonObject
    }



}