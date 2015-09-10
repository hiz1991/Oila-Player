//
//  Downloader.swift
//  Oila Player
//
//  Created by MacBook on 10/04/2015.
//  Copyright (c) 2015 Andrei Puni. All rights reserved.
//

import Foundation
public class Downloader{
    //    weak var delegate : PlayerDelegate?
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var pointer = 0
    var q: [NSDictionary] = []
    
    public init(){
        pointer = 0
        q = []
    }
    
    func add(url:String, folder:String){
        q.append(["url":url, "folder":folder])
    }
    func next(){
        if self.pointer == q.count - 1{return}
        self.pointer++
        download(q[self.pointer]["url"] as! String, folder: q[self.pointer]["folder"] as! String)
    }
    func start(){
        
        download(q[0]["url"] as! String, folder: q[0]["folder"] as! String)
    }
    
    var task: NSURLSessionDownloadTask!
    
    let fileManager:NSFileManager = NSFileManager.defaultManager()
    var customAllowedSet =  NSCharacterSet.URLQueryAllowedCharacterSet()
    
    public func listFilesFromDocumentsFolder(dir:NSSearchPathDirectory = NSSearchPathDirectory.DocumentDirectory) -> [String]
    {
        var theError = NSErrorPointer()
        let dirs = NSSearchPathForDirectoriesInDomains(dir, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
        if dirs != nil {
            let dir = dirs![0]
            let fileList = NSFileManager.defaultManager().contentsOfDirectoryAtPath(dir, error: theError)
            return fileList as! [String]
        }else{
            let fileList = [""]
            return fileList
        }
    }
    public func download(urlPathReceivedLet:String, folder:String){
        //handle vk
        let originalUrl = addHttp(urlPathReceivedLet, site: site)
        var urlPathReceived = originalUrl
        if urlPathReceived.rangeOfString("?extra") != nil {
            println(urlPathReceived)
            var temp = split(urlPathReceived) {$0 == "?"}
            urlPathReceived = temp[0]
            
        }
        var urlPath = urlPathReceived
        //check if exists
        documentsURL =  paths[0] as! NSURL
        
        var error : NSError?
        
        if !folder.isEmpty {
            println(folder)
            
            documentsURL = documentsURL.URLByAppendingPathComponent(folder)
        }
        
        let finalFile = documentsURL.URLByAppendingPathComponent(urlPath.lastPathComponent)
        
        if let path = finalFile.path {
            if fileManager.fileExistsAtPath(path) {
                println("file exists")
                dl.next()
                return
                //                fileManager.removeItemAtURL(finalFile, error: nil);
            }
        }
        

        //check if file exists
        let url = NSURL(string: originalUrl.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!)
        let session = NSURLSession.sharedSession()
        task = session.downloadTaskWithRequest(NSURLRequest(URL: url!), completionHandler: { (data, response, error) -> Void in
            println("Task completed")
            if(error != nil) {
                // If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.save(data, lastcomp: NSURL(string: urlPath.stringByAddingPercentEncodingWithAllowedCharacters(self.customAllowedSet)!)!.lastPathComponent!, folder: folder)
                println(data)
                dl.next()
            })
        })
        
        task.resume()
        
        
        var fileList = listFilesFromDocumentsFolder(dir: NSSearchPathDirectory.DocumentDirectory)
        
        let count = fileList.count
        var isDir:Bool = true;
        
        for var i:Int = 0; i < count; i++
        {
            if fileManager.fileExistsAtPath(fileList[i]) != true
            {
//                println("File is \(fileList[i])")
            }
        }
    }
    func save(tempLoc:NSURL, lastcomp:String, folder:String){
        
        var error : NSError?
        var success = fileManager.copyItemAtURL(tempLoc, toURL: documentsURL.URLByAppendingPathComponent(lastcomp), error: &error)
        var removal  = fileManager.removeItemAtPath(tempLoc.path!, error: nil)
        
        //        println(finalFile)
        
        if (!success) {
            if let actualError = error {
                println("An Error Occurred: \(actualError)")
            }
            
        }
    }
    
    func resolvePath(url:String, folder:String, site:String) -> NSURL{
        documentsURL =  paths[0] as! NSURL
        if !folder.isEmpty {
            documentsURL = documentsURL.URLByAppendingPathComponent(folder)
        }
        var playerItem :NSURL
        playerItem = NSURL(string: (site+"/"+url).stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!)!
        let lastComp = playerItem.lastPathComponent
        //                println(lastComp)
        println(documentsURL.URLByAppendingPathComponent(lastComp!).path!)
        if fileManager.fileExistsAtPath(documentsURL.URLByAppendingPathComponent(lastComp!).path!) {
            println("have "+documentsURL.URLByAppendingPathComponent(lastComp!).path!)
            playerItem = NSURL(string: ("file://" + documentsURL.URLByAppendingPathComponent(lastComp!).path!).stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!)!
        }else{
            playerItem = NSURL(string: addHttp(url, site: site).stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!)!
        }
        
        return playerItem
    }
    
    func addHttp(url:String, site:String) -> String{
        var returned:String!
        if url.rangeOfString("http") != nil{
            
            returned = url
            
        }else{
            returned = site+"/"+url
        }
        return returned
    }

}