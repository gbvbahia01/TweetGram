//
//  TwitterData.swift
//  TweetGram
//
//  Created by Guilherme B V Bahia on 03/06/17.
//  Copyright © 2017 Planet Bang. All rights reserved.
//

import Foundation

class TwitterData {
   
   var urlImg : String? = nil
   var urlTweet : String? = nil;
   
   init(urlImg : String, urlTweet :String) {
      self.urlImg = urlImg;
      self.urlTweet = urlTweet
   }
}
