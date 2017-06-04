//
//  AppDelegate.swift
//  TweetGram
//
//  Created by Guilherme B V Bahia on 02/06/17.
//  Copyright © 2017 Planet Bang. All rights reserved.
//

import Cocoa
import OAuthSwift

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
   
   
   
   func applicationDidFinishLaunching(_ aNotification: Notification) {
      NSAppleEventManager.shared().setEventHandler(self,
                                                   andSelector:#selector(AppDelegate.handleGetURL(event:withReplyEvent:)),
                                                   forEventClass: AEEventClass(kInternetEventClass),
                                                   andEventID: AEEventID(kAEGetURL))
   }
   
   func applicationWillTerminate(_ aNotification: Notification) {
      // Insert code here to tear down your application
   }
   
   func handleGetURL(event: NSAppleEventDescriptor!, withReplyEvent: NSAppleEventDescriptor!) {
      if let urlString = event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))?.stringValue,
         let url = URL(string: urlString) {
         OAuthSwift.handle(url: url)
      }
   }
   
}

