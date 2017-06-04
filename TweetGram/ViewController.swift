//
//  ViewController.swift
//  TweetGram
//
//  Created by Guilherme B V Bahia on 02/06/17.
//  Copyright © 2017 Planet Bang. All rights reserved.
//

import Cocoa
import SwiftyJSON
import Kingfisher

class ViewController: NSViewController, ResultAsync, NSCollectionViewDataSource, NSCollectionViewDelegate {

   var twiiterOAuth : TwiiterOAuth? = nil;
   var twitterData : [TwitterData] = []
   
   @IBOutlet weak var loginLogout: NSButton!
   @IBOutlet weak var collectionView: NSCollectionView!

   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      let layout = NSCollectionViewFlowLayout()
      layout.itemSize = NSSize(width: 300, height: 300)
      layout.sectionInset = EdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
      layout.minimumLineSpacing = 10.0
      layout.minimumInteritemSpacing = 10.0
      collectionView.collectionViewLayout = layout
      collectionView.delegate = self
      collectionView.dataSource = self
      
      twiiterOAuth = TwiiterOAuth(caller: self)
      twiiterOAuth?.checklogged()
   }

   @IBAction func loginLogOutClicked(_ sender: Any) {
      if twiiterOAuth!.isLogged {
         twiiterOAuth!.logout()
      } else {
         twiiterOAuth!.login()
      }
      
   }
   
   func resultFor(type: String, result: Data) {
      
      if TwiiterOAuth.LOGIN == type {
         loginLogout.title = "Logout"
         return
      }
      
      if TwiiterOAuth.LOGOUT == type {
         loginLogout.title = "Login"
         twitterData = []
         self.collectionView.reloadData()
         return
      }
      
      if TwiiterOAuth.STATUSES_HOME_TIME_LINE == type {
         let json = JSON(data: result)
         
         for (_, tweetJson):(String, JSON) in json {
            var retweeted = false
            
            for (_, mediaJson):(String, JSON) in tweetJson["retweeted_status"]["extended_entities"]["media"] {
               if let urlImg = mediaJson["media_url_https"].string {
                  if let urlTweet = mediaJson["expanded_url"].string {
                     twitterData.append(TwitterData(urlImg: urlImg, urlTweet: urlTweet))
                     retweeted = true
                  }
               }
            }
            
            if !retweeted {
               for (_, mediaJson):(String, JSON) in tweetJson["extended_entities"]["media"] {
                  if let urlImg = mediaJson["media_url_https"].string {
                     if let urlTweet = mediaJson["expanded_url"].string {
                        twitterData.append(TwitterData(urlImg: urlImg, urlTweet: urlTweet))
                     }
                  }
               }
            }
         }
         self.collectionView.reloadData()
      }
   }
   
   func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
      return twitterData.count;
   }
   
   func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
      let item = collectionView.makeItem(withIdentifier: "TweetViewItem", for: indexPath)
      let urlString = twitterData[indexPath.item].urlImg!
      let url = URL(string: urlString)
      item.imageView?.kf.setImage(with: url)
      return item
   }
   
   func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
      if let indexPath = indexPaths.first {
         if let urlTweet = URL(string: twitterData[indexPath.item].urlTweet!) {
            NSWorkspace.shared().open(urlTweet);
         }
      }
      collectionView.deselectAll(nil)
   }
}

