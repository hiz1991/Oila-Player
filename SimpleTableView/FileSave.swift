    var task: NSURLSessionDownloadTask!
    let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
    var documentsURL:NSURL =  paths[0] as! NSURL
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
    public func download(urlPath:String, folder:String){
        //check if exists
        documentsURL =  paths[0] as! NSURL
        
        var error : NSError?
        
        if !folder.isEmpty {
            
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
    let url = NSURL(string: urlPath.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!)
    let session = NSURLSession.sharedSession()
    task = session.downloadTaskWithRequest(NSURLRequest(URL: url!), completionHandler: { (data, response, error) -> Void in
        println("Task completed")
        if(error != nil) {
            // If there is an error in the web request, print it to the console
            println(error.localizedDescription)
        }
        dispatch_async(dispatch_get_main_queue(), {
            save(data, url!.lastPathComponent!, folder)
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
            println("File is \(fileList[i])")
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
                if url.rangeOfString("http") != nil{
                    
                    playerItem = NSURL(string: url.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!)!
                    
                }else{
                    playerItem = NSURL(string: (site+"/"+url).stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!)!
                }
            }
    
        return playerItem
    }
