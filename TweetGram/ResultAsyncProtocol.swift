//
//  ResultAsyncProtocol.swift
//  TweetGram
//
//  Created by Guilherme B V Bahia on 03/06/17.
//  Copyright © 2017 Planet Bang. All rights reserved.
//

import Foundation

protocol ResultAsync {
   
   func resultFor(type: String, result: Data)
}
