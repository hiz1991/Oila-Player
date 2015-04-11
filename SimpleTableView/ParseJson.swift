//
//  ParseJson.swift
//  Oila Player
//
//  Created by MacBook on 10/04/2015.
//  Copyright (c) 2015 Andrei Puni. All rights reserved.
//

import Foundation
public func parseJSON(inputData: NSData) -> NSDictionary{
    var error: NSError?
    var boardsDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
    return boardsDictionary
}