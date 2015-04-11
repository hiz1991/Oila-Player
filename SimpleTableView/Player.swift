//
//  Player.swift
//  SimpleTableView
//
//  Created by MacBook on 28/03/2015.
//  Copyright (c) 2015 Andrei Puni. All rights reserved.
//
import AVFoundation
import Foundation
import MediaPlayer
//protocol PlayerDelegate : class {
//    func soundFinished(sender : AnyObject)
//}

public class Player{
//    weak var delegate : PlayerDelegate?
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    let events = EventManager();
//          self.events.trigger("meow", information: "The cat is hungry!");
//    cat.events.listenTo("meow", action: {
//    println("Human: Awww, what a cute kitty *pets cat*");
//    });
    var avPlayer:AVPlayer!
    var volume:Float = 1.0;
    var current:Int = 0
    var urls:[String]=[]
    var circle:AnyObject!
    var site:String!
    var not:NSNotification!
    var customAllowedSet =  NSCharacterSet.URLQueryAllowedCharacterSet()
    var delegate:ViewController!
    public init(url:String, urlsReceived:[String], siteReceived:String, delReceived:AnyObject!){
        println(site)
        let urlrec = NSURL(string: (siteReceived+"/"+url).stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!)
        avPlayer = AVPlayer.playerWithURL(urlrec) as! AVPlayer
        delegate = delReceived as! ViewController
//        delegate.playAtIndex(0, fromTable: false)
//        self.pause()
        urls = urlsReceived
        site = siteReceived
        delegate.activateTimer()
        let time = NSTimer.scheduledTimerWithTimeInterval(2, target:delegate, selector: Selector("updateNowPlaying"), userInfo: nil, repeats: false)

        let sess = AVAudioSession.sharedInstance()
        sess.setCategory(AVAudioSessionCategoryPlayback, withOptions: nil, error: nil)
        sess.setActive(false, withOptions: nil, error: nil)
    
    }
    func playUrl(url: String)
    {
        if url == urls[current] && self.avPlayer != nil{
            self.avPlayer.play()
        } else{
            delegate.circle.startAnimating()
            delegate.playPauseView.hidden = true
            
            var error: NSError?
            //        let fileURL:NSURL = NSBundle.mainBundle().URLForResource("Oath", withExtension: "mp3")!
            var playerItem :NSURL = resolvePath(url, "mp3", site)
            
            
            //        avPlayer = AVPlayer(playerItem:playerItem)
            avPlayer = AVPlayer.playerWithURL(playerItem) as! AVPlayer//(URL: playerItem)
            //            self.player = AVAudioPlayer(contentsOfURL: playerItem.relativeString , error: nil)
            //            self.player.prepareToPlay()
            
            if self.avPlayer == nil {
                if let e = error {
                    println(e.localizedDescription)
                }
            }
            self.avPlayer.volume=self.volume
            //            println(self.avPlayer.status)
            
            self.play()
            self.avPlayer.currentItem
//            self.avPlayer.currentItem.
//            var imm = UIImage(named: "01")!
//            var img:UIImage = MPMediaItemArtwork(image: UIImage(named: "01")!)

//            delegate.titles[current]
            //            self.player.play()
//                   let tim = NSTimer.scheduledTimerWithTimeInterval(1, target:delegate, selector: Selector("activateTimer"), userInfo: nil, repeats: false)
            delegate.activateTimer()
        }
    }
    func play(){
        self.avPlayer.play()
        delegate.playButton.hidden=true
        delegate.pauseButton.hidden=false
    }
    func pause(){
       self.avPlayer.pause()
        delegate.playButton.hidden=false
        delegate.pauseButton.hidden=true
    }
    func next(){
        //check if progress full
        println(delegate.progressView.progress)
        println("next")
        if current == delegate.urls.count-1 {
            delegate.playAtIndex(0)
        }else{
            delegate.playAtIndex(current+1)
        }
    }
    func isPlaying() -> Bool{
        var result:Bool!
        if self.avPlayer.rate == 1.0 {
            result =  true
        } else {
            if self.avPlayer.rate == 0.0 {
                result =  false
            }
        }
        return result
    }
    func previous(){
        println("next")
        if current == 0  {
            delegate.playAtIndex(delegate.urls.count-1)
        }else{
            delegate.playAtIndex(current-1)
        }
    }
    

}
