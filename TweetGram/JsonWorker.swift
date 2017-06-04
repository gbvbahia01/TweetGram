//
//  JsonWorker.swift
//  TweetGram
//
//  Created by Guilherme B V Bahia on 03/06/17.
//  Copyright © 2017 Planet Bang. All rights reserved.
//
import SwiftyJSON
import Foundation

class JsonWorker {
   
   func searchJson(data: Data, levels: [String]...) -> [String] {
      var toReturn : [String] = [];
      let json = JSON(data: data)
      
      for (_, json):(String, JSON) in json {
         
      }
      
      return toReturn
   }
}
