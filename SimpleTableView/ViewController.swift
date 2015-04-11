import UIKit
import AVFoundation
import Foundation
import MediaPlayer
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,SideBarDelegate
{
    var sideBar:SideBar = SideBar()
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var remoteView: UIView!
    
    @IBOutlet weak var circle: UIActivityIndicatorView!
    
    @IBOutlet weak var playPauseView: UIView!
    
    
    @IBOutlet weak var remoteBlurredView: UIVisualEffectView!
    @IBOutlet var playerPaneBlurredView: UIView!
    

    @IBOutlet weak var nameHolder: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var tableView: UITableView!
    
    var idsBU: [String] = []
    var itemsBU: [String] = []
    var urlsBU: [String] = []
    var imagesBU: [String] = []
    var artistsBU: [String] = []
    var titlesBU: [String] = []
    var playlistsBU:[String]=[]
    var uiimagesBU:[AnyObject] = []
    
    var ids: [String] = []
    var items: [String] = []
    var urls: [String] = []
    var images: [String] = []
    var artists: [String] = []
    var titles: [String] = []
    var playlists:[String]=[]
    var uiimages:[AnyObject] = []
    var playlDict:NSDictionary!
    var playlistObject:NSDictionary!
    var seekEnabled = true
    var imgCached:UIImage!
    var loadObs:Seekable =  Seekable()
//    var json:JSON!
    var jsonObject:NSDictionary!
    var site: String = "http://10.118.194.176:8888/"//http://localhost:8888/"
    var customAllowedSet =  NSCharacterSet.URLQueryAllowedCharacterSet()
    var timer = NSTimer()
    var remoteCenterPosition = CGPointMake(0.0, 0.0)
    var artworkPosition = CGPointMake(0.0, 0.0)
    var player :Player!
    let cellHeight:Int = 60
    
    let imagePlaceHolder:UIImage = UIImage(named: "imagePlaceHolder")!
    let mpic = MPNowPlayingInfoCenter.defaultCenter()

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var seekerBar: UISlider!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var playerPanel: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playing: UILabel!
    
    @IBOutlet weak var backgroundImageViewer: UIImageView!
    @IBOutlet weak var imageViewer: UIImageView!
   
    
    @IBAction func pauseButtonClicked(sender: AnyObject) {
        player.pause();
    }
    
    @IBAction func playButtonClicked(sender: AnyObject) {
        player.play()
    }
    

    @IBAction func slider(sender: UISlider) {
        println(player.avPlayer.status);
        player.avPlayer.volume=Float(sender.value)/100;
        player.volume = Float(sender.value)/100
//        }
    }
    
    @IBAction func seekerBarAction(sender: UISlider) {
//        timer.invalidate()
    }
    
    @IBAction func seekStart(sender: UISlider) {
        println("seekStart")
        seekEnabled = false
//        timer.invalidate()
        
    }

    @IBAction func seekStartDrag(sender: AnyObject) {
        println("seekStartDrag")
        seekEnabled = false
//        timer.invalidate()
    }

    @IBAction func seekTouchUp(sender: UISlider) {
              println("seekTouchUp")
        dragEndAction(sender)
    }
    
    @IBAction func seekDragEnd(sender: UISlider) {
        println("seekDragEnd")
         dragEndAction(sender)
    }
    
    func dragEndAction(sender: UISlider){
        if player.avPlayer == nil{
            playButtonClicked([])
        }
        if player.avPlayer.currentItem != nil{
            if sender.value == 1.0 {
                player.next()
            }else{
                var val:Float;
                println(sender.value)
                if(sender.value>0.0){val=sender.value}else{val=0.0}
                var dur:Float = Float(CMTimeGetSeconds(player.avPlayer.currentItem.asset.duration));
                //        println(dur)
                var timmm = Float(dur * Float(val ))
                //        println(timmm)
                var time:CMTime = CMTimeMakeWithSeconds(Float64(timmm),10000000);
                player.avPlayer.seekToTime(time);
                mpic.nowPlayingInfo.updateValue(timmm, forKey: MPNowPlayingInfoPropertyElapsedPlaybackTime)
                //seekToTime(dur*(val/100))
                var end: AnyObject = player.avPlayer.currentItem.loadedTimeRanges
                
    //            timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("updateSeek"), userInfo: nil, repeats: true)
                player.play()
            }
        }
        seekEnabled = true
    }
    
    func populate(json:NSDictionary) -> Void
    {

        setImage(json["Songs"]![0]!["urlOfArt"] as! String!, anim: false)
//        println(jsn?["Songs"]!);
        nameHolder.text=json["User"]![0]!["email"] as! String!;
        let len:Int = json["Songs"]!.count;
        println(len)
        var str: String
//        let songs:NSDictionary = json["Songs"]! as NSDictionary
        for(var i=0; i<len; i++)
        {
            let imgUrl = json["Songs"]![i]!["urlOfArt"] as! String!
//            println(imgUrl)
            str = json["Songs"]![i]!["title"]! as! String!
            self.items.append(str)
            self.urls.append(json["Songs"]![i]!["url"]! as! String!)
            self.images.append(imgUrl)
            self.artists.append(json["Songs"]![i]!["artist"]! as! String!)
            self.titles.append(str)
            self.ids.append(json["Songs"]![i]!["id"]!  as! String!)
//            println(self.titles[i])
            
            
            
            var urlu=site+"/"+imgUrl
            println(urlu)
            let newStr = urlu.stringByReplacingOccurrencesOfString("artwork/", withString: "artwork/thumb/", options: NSStringCompareOptions.allZeros, range: nil)
            urlu = newStr
            println(urlu)
            let urlrec = json["Songs"]![i]!["urlOfArt"]! as! String!
            let urlns = resolvePath(urlu, "thumbs", site)//NSURL(string: urlu.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!)
            let data = NSData(contentsOfURL: urlns) //make sure your image in this url does exist, otherwise unwrap in a if let check
            if data != nil{
                let img =  UIImage(data: data!)
                    uiimages.append(img!)
            } else{
                    uiimages.append([])
            }
//            uiimages.append(imagePlaceHolder)
            
            dl.add(site+images[i], folder:"artwork")
            dl.add(urlu, folder: "thumbs")

        }
//        println(json["Playlists"])
//        let dict = json["Playlists"][0].asDictionary!
        playlistObject = json["Playlists"]![0]! as! NSDictionary
//        scrollView.contentSize = tableView
        playlists = playlistObject.allKeys as! [String]
        playlists.insert("All Music", atIndex: 0)
        renderData()
        
//                let account = DBAccountManager.sharedManager().linkedAccount
//        println(account)
//        
//                if account == nil {
//                    DBAccountManager.sharedManager().linkFromController(self)
//                    println(account)
//                }else{
//                    let files:DBFilesystem = DBFilesystem(account: account)
//                    DBFilesystem.setSharedFilesystem(files)
//                    let path:DBPath = DBPath.root()
//                    println(files.listFolder(path, error: nil))
//                    println(files)
//                }
        
         idsBU = ids
         itemsBU = items
         urlsBU = urls
         imagesBU  = images
         artistsBU = artists
         titlesBU  = titles
         uiimagesBU  = uiimages
        
        dl.start()
        
    }

    func sideBarDidSelectButtonAtIndex(index: Int) {
        player.pause()
        if index == 0{
            clearCurrentData()
            ids = idsBU
            items = itemsBU
            urls = urlsBU
            images  = imagesBU
            artists = artistsBU
            titles  = titlesBU
            uiimages  = uiimagesBU
            renderData()
            sideBar.showSideBar(false)
            return
            
        }
//        println(playlistObject[playlists[index]].asArray!)
        let pl:String = playlists[index]
        if playlistObject[pl] == nil {println("Empty")}
        var playLIds:[String] = []
        println("started")
        var plIds = playlistObject[pl] as! [String]
        for n in plIds {
            playLIds.append(n as String!)
        }
        println("finished")
//        println(_stdlib_getTypeName(playLIds))
        if playLIds.count > 0  {
            println(playLIds)
        }else{
            items=[]
            self.tableView.reloadData()
//            player = nil
            return
        }
        
        clearCurrentData()
        
//        println(idsBU)
        
        
        for( var i:Int = 0;i < idsBU.count ; i++){
            for(var x:Int=0; x < playLIds.count; x++){
//                println("/(i)","/( x)")
                var str1:String = idsBU[i] as String
                var str2:String = playLIds[x]
                if  str1 == str2{
                    urls.append(urlsBU[i])
                    ids.append(idsBU[i])
                    images.append(imagesBU[i])
                    titles.append(titlesBU[i])
                    artists.append(artistsBU[i])
                    uiimages.append(uiimagesBU[i])
                    items.append(itemsBU[i])
                }
            }
        }
        
        sideBar.showSideBar(false)
        renderData()
    
    }

    func renderData()
    {
        println("populated")
        playerPanel.hidden=false
        playing.text=titles[0]
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        scrollView.addSubview(tableView)
        self.tableView.reloadData()
        selectTableRow(0)
        let tim = NSTimer.scheduledTimerWithTimeInterval(0, target:self, selector: Selector("setFirstItem"), userInfo: nil, repeats: false)
    }
    
    func setFirstItem(){
        player = Player(url: self.urls[0], urlsReceived: self.urls, siteReceived:self.site, delReceived:self)
        setImage(images[0], anim : false)
    }
//    @IBAction func buttonClicked(sender: AnyObject) {
//        println("clicked")
//    }
//    @IBOutlet var button: UIView!
    override func viewDidLoad() {
        self.tableView.addPullToRefreshWithAction {
            self.refreshJson()
        }
        
        super.viewDidLoad()
//        self.tableView.contentOffset = CGPointMake(0, 0 - self.tableView.contentInset.top + 44);
        
        let accountManager = DBAccountManager(appKey: "zobcoa1m8tlc4nq", secret: "4vakr15wygayg4v")
        DBAccountManager.setSharedManager(accountManager)
        
        let account = DBAccountManager.sharedManager().linkedAccount
        
//        if let account = account? {
//            // Use Dropbox datastores
//            DBDatastoreManager.setSharedManager(DBDatastoreManager(forAccount:account))
//        } else {
//            // Use local datastores
//            DBDatastoreManager.setSharedManager(DBDatastoreManager.localManagerForAccountManager(DBAccountManager.sharedManager()))
//        }

//        self.passwordHolder.delegate = sel
//        mainView.bringSubviewToFront(loginPanel)
        self.tableView.backgroundView = UIImageView(image:UIImage(named: "01"))
//        loginButton([])
        seekerBar.setThumbImage(UIImage(named: "thumb"), forState: .Normal)
        seekerBar.setThumbImage(UIImage(named: "thumb"), forState: .Selected)
        seekerBar.setThumbImage(UIImage(named: "thumb"), forState: .Highlighted)
        seekerBar.setMaximumTrackImage(UIImage(named: "transp"), forState: .Normal)
        seekerBar.setMinimumTrackImage(UIImage(named: "transp"), forState: .Normal)
        seekerBar.sizeToFit()
        volumeSlider.setThumbImage(UIImage(named: "thumb"), forState: .Normal)
        volumeSlider.setThumbImage(UIImage(named: "thumb"), forState: .Selected)
        volumeSlider.setThumbImage(UIImage(named: "thumb"), forState: .Highlighted)
        
        remoteCenterPosition = remoteView.center
        artworkPosition = imageViewer.center
        
        var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        remoteBlurredView.frame = remoteView.bounds
        remoteBlurredView.addSubview(visualEffectView)
        
        var visualEffectViewPlayer = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        playerPaneBlurredView.frame = playerPaneBlurredView.bounds
        playerPaneBlurredView.addSubview(visualEffectViewPlayer)

        populate(jsonObject)

        sideBar = SideBar(sourceView: self.view, menuItems: playlists)
        sideBar.delegate = self
        
        self.becomeFirstResponder()
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "songEndDetected", name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
    }
    
    func clearCurrentData(){
        ids = []
        items = []
        urls = []
        images = []
        artists = []
        titles = []
        uiimages = []
        seekEnabled = true
    }
    
    func refreshJson(){
         clearCurrentData()
        request(.POST, self.site+"getJson.php")
        .responseString (completionHandler:{ (_, _, string, _) in
                self.jsonObject = parseJSON(string!.dataUsingEncoding(NSUTF8StringEncoding)!)
                self.populate(self.jsonObject)
                self.tableView.stopPullToRefresh()
                //                            self.populate(json)
                //                            println("reached")
        })

    }

    func selectTableRow(index:Int){
        let rowToSelect:NSIndexPath = NSIndexPath(forRow: index, inSection: 0);  //slecting 0th row with 0th section
        self.tableView.selectRowAtIndexPath(rowToSelect, animated: true, scrollPosition: UITableViewScrollPosition.None);
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell

            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle,
                reuseIdentifier: "cell")

        if(indexPath.row % 2==0)
        {
            cell.backgroundColor = UIColor.clearColor()
        }
        else
        {
            cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
        }
        cell.textLabel?.text = self.items[indexPath.row]
        cell.detailTextLabel?.text = self.artists[indexPath.row]
        cell.textLabel?.highlightedTextColor = UIColor.whiteColor()
        cell.detailTextLabel?.highlightedTextColor = UIColor.whiteColor()
        
//        if uiimages[indexPath.row].size != nil{
            cell.imageView?.layer.cornerRadius = CGFloat(cellHeight) / 2;
            cell.imageView?.clipsToBounds = true;
            cell.imageView?.layer.masksToBounds = true
            cell.imageView?.layer.opaque = false;
            cell.imageView?.frame = CGRectMake(0,0, 20, 20);
            cell.imageView?.bounds = CGRectMake(0,0, 20,20);
            cell.imageView?.image = uiimages[indexPath.row] as? UIImage
//        }
        let selectedView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width  , height: cell.frame.size.height ))
        selectedView.backgroundColor = getHexColor("#007CD0").colorWithAlphaComponent(0.6)
        
        cell.selectedBackgroundView = selectedView
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        playAtIndex(indexPath.row, fromTable:true)
    }
    
    func setImage( url:String, anim : Bool){
        let urlu=site+"/"+url
        println(urlu)
//        let urlrec = self.json["Songs"][index]["urlOfArt"].asString!
        let urlns = resolvePath(urlu, "artwork", site)
        let data = NSData(contentsOfURL: urlns) //make sure your image in this url does exist, otherwise unwrap in a if let check
//        if data != nil{
//            imgCached = imagePlaceHolder
//        }else{
            imgCached = UIImage(data: data!)!
//        }
        
        backgroundImageViewer.image = imgCached
        
        //move background image to right of the pane
        backgroundImageViewer.center = CGPointMake(self.artworkPosition.x + self.backgroundImageViewer.frame.width ,self.artworkPosition.y);
        //end
        
        if anim {
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
                self.imageViewer.center = CGPointMake(self.artworkPosition.x - self.imageViewer.frame.width ,self.artworkPosition.y);
                
                //move backg image in
                self.backgroundImageViewer.center = self.artworkPosition
                
                }, completion: {
                    (value: Bool) in
                    self.imageViewer.center = self.artworkPosition
                     self.imageViewer.image = UIImage(data: data!)
                }
            )
        } else{
            self.imageViewer.image = UIImage(data: data!)
        }

        
    }
    
    func playAtIndex(index:Int, fromTable:Bool = false){
        //        println("You selected cell #\(indexPath.row)!")
        if index == player.current {
            player.play()
            return
        }
        if !fromTable {
            selectTableRow(index)
        }
        player.playUrl(urls[index])
        //        println(images[indexPath.row])
        setImage(images[index], anim : true)
        playing.text=artists[index]+" - "+titles[index]
        player.current=index
        
        let sess = AVAudioSession.sharedInstance()
        sess.setCategory(AVAudioSessionCategoryPlayback, withOptions: nil, error: nil)
        sess.setActive(false, withOptions: nil, error: nil)
        
        let time = NSTimer.scheduledTimerWithTimeInterval(2, target:self, selector: Selector("updateNowPlaying"), userInfo: nil, repeats: false)
    

    }
    func updateNowPlaying(){
        var durt:Float?
        if player.avPlayer.currentItem != nil{
            durt =  Float(CMTimeGetSeconds(player.avPlayer.currentItem.duration))
        }else{
            durt = 0.0
        }
        mpic.nowPlayingInfo = [
            MPMediaItemPropertyTitle:titles[player.current],
            MPMediaItemPropertyArtist:artists[player.current],
            MPMediaItemPropertyArtwork:MPMediaItemArtwork(image: imgCached)
//            MPMediaItemPropertyPlaybackDuration: durt!
        ]
        if durt > 0.0 {mpic.nowPlayingInfo.updateValue(durt!, forKey: MPMediaItemPropertyPlaybackDuration)}

    }
    
    func updateSeek(){
//        player.avPlayer.play()

        if player.avPlayer.currentItem != nil {//song started loading
            let durRaw = player.avPlayer.currentItem.duration;
            let curRaw = player.avPlayer.currentTime();
            //        println(player.avPlayer.currentItem.duration.value, "  ", player.avPlayer.currentTime().value)
            //        if(sender.value>0.0){val=sender.value}else{val=0.0}
            var dur:Float = 0.0
            
             circle.stopAnimating()
             playPauseView.hidden = false
            dur = Float(CMTimeGetSeconds(durRaw));
            let current = Float(CMTimeGetSeconds(curRaw))
            if seekEnabled {seekerBar.setValue(current / dur, animated: true)}

            var progressInPercent = Seekable.dur(player.avPlayer)
            if !progressInPercent.isNaN {
                let decim:Float = Float(progressInPercent)
                self.progressView.setProgress( decim / 100 , animated: true)
            }
        }
    }
    
    func activateTimer(){
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("updateSeek"), userInfo: nil, repeats: true)
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    override func remoteControlReceivedWithEvent(event: UIEvent) {
        let rc = event.subtype
//        let p = self.player.player
        println("received remote control \(rc.rawValue)") // 101 = pause, 100 = play
        switch rc {
        case .RemoteControlTogglePlayPause:
            if player.isPlaying() { player.pause() } else { player.play() }
            println("play pauser \(rc.rawValue)")
        case .RemoteControlPlay:
//            p.play()
            player.play()
            
        case .RemoteControlPause:
           player.pause()
        case .RemoteControlNextTrack:
            player.next()
//        case MotionShake
//        case RemoteControlPlay
//        case RemoteControlPause
//        case RemoteControlStop
//        case RemoteControlTogglePlayPause
//        case RemoteControlNextTrack
        case .RemoteControlPreviousTrack:
            player.previous()
//        case RemoteControlBeginSeekingBackward
//        case RemoteControlEndSeekingBackward
//        case RemoteControlBeginSeekingForward
//        case RemoteControlEndSeekingForward
        default:break
        }
        
    }
    func songEndDetected(){
//        if progressView.progress < 0.7 {return}
        println("songEndDetected()")
        timer.invalidate()
        progressView.setProgress(0.0, animated: true)
        player.next()
    }
    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
//        self.filteredCandies = self.candies.filter({( candy: Candy) -> Bool in
//            let categoryMatch = (scope == "All") || (candy.category == scope)
//            let stringMatch = candy.name.rangeOfString(searchText)
//            return categoryMatch && (stringMatch != nil)
//        })
        println(searchText)
    }
    
    func tellRemote(command :String){
        request(.GET, site+"remote.php", parameters: ["set":command])
        .responseString ( completionHandler : {
            (request: NSURLRequest, response: NSHTTPURLResponse?, string: String?, error: NSError?) -> Void in
                println(string)
                if string!.rangeOfString("error") != nil{
                    self.nameHolder.text = "not logged in"
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
    
    @IBAction func remoteShow(sender: AnyObject) {
//        playerPanel.hidden=true
        mainView.bringSubviewToFront(remoteView)
        remoteView.hidden=false
        remoteView.center = CGPointMake(0.0,remoteCenterPosition.y);
        UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            self.remoteView.center = CGPointMake(self.remoteCenterPosition.x,self.remoteCenterPosition.y);
            
            }, completion: nil)
    }
    @IBAction func remoteHide(sender: AnyObject) {
        
        remoteView.center = remoteCenterPosition
        UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            self.remoteView.center = CGPointMake(0,self.remoteCenterPosition.y);
            
            }, completion: {
                                (value: Bool) in
                                self.remoteView.hidden=true
                                self.playerPanel.hidden=false
            }
        )
        
    }

}

