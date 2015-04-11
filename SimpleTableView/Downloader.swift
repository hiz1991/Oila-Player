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
        download(q[self.pointer]["url"] as! String, q[self.pointer]["folder"] as! String)
    }
    func start(){
        
        download(q[0]["url"] as! String, q[0]["folder"] as! String)
    }
}