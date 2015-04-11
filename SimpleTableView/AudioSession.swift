//
//  AudioSession.swift
//  SimpleTableView
//
//  Created by MacBook on 28/03/2015.
//  Copyright (c) 2015 Andrei Puni. All rights reserved.
//

import Foundation
import AVFoundation
public class AudioSession{
    public init(){
        
        var activeError: NSError? = nil
        AVAudioSession.sharedInstance().setActive(true, error: &activeError)
        
        if let actError = activeError {
            NSLog("Error setting audio active: \(actError.code)")
        }
        
        var categoryError: NSError? = nil
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: &categoryError)
        
        if let catError = categoryError {
            NSLog("Error setting audio category: \(catError.code)")
        }
    }
}