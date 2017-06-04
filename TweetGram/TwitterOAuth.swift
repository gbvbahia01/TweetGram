//
//  TwitterOAuth.swift
//  TweetGram
//
//  Created by Guilherme B V Bahia on 03/06/17.
//  Copyright © 2017 Planet Bang. All rights reserved.
//

import Foundation
import Cocoa
import OAuthSwift

class TwiiterOAuth {
   
   static var FOLLOWERS : String = "FOLLOWERS"
   static var ACCOUNT_SETINGS : String = "ACCOUNT_SETINGS"
   static var STATUSES_HOME_TIME_LINE : String = "STATUSES_HOME_TIME_LINE"
   static var LOGIN : String = "LOGIN"
   static var LOGOUT : String = "LOGOUT"
   
   var resultAsyncCaller : ResultAsync? = nil
   var isLogged = false
   
   let  oauthswift = OAuth1Swift(
      consumerKey:    "******", // <- Put your app consumerKey at: https://apps.twitter.com (Details)
      consumerSecret: "******", // <- Put your app consumerSecret at: https://apps.twitter.com (Details)
      requestTokenUrl: "https://api.twitter.com/oauth/request_token",
      authorizeUrl:    "https://api.twitter.com/oauth/authorize",
      accessTokenUrl:  "https://api.twitter.com/oauth/access_token"
   )
   
   init(caller: ResultAsync) {
      self.resultAsyncCaller = caller
   }
   
   func checklogged()  {
      if let oauthToken = UserDefaults.standard.string(forKey: "oauthTokenTwitter") {
         if let oauthTokenSecret = UserDefaults.standard.string(forKey: "oauthTokenSecretTwitter") {
            oauthswift.client.credential.oauthToken = oauthToken
            oauthswift.client.credential.oauthTokenSecret = oauthTokenSecret
            isLogged = true;
            self.resultAsyncCaller?.resultFor(type: TwiiterOAuth.LOGIN, result: Data())
            self.getStatusesHomeTimeLine()
            return;
         }
      }
      isLogged = false;
      self.resultAsyncCaller?.resultFor(type: TwiiterOAuth.LOGOUT, result: Data())
   }
   
   func login () {
      
      checklogged()
      
      if isLogged {
         return
      }
      
      let _ = oauthswift.authorize(
         withCallbackURL: URL(string: "TweetGram://oauth-callback/twitter")!,
         success: { credential, response, parameters in
            UserDefaults.standard.set(credential.oauthToken, forKey: "oauthTokenTwitter")
            UserDefaults.standard.set(credential.oauthTokenSecret, forKey: "oauthTokenSecretTwitter")
            UserDefaults.standard.synchronize()
            self.isLogged = true;
            self.resultAsyncCaller?.resultFor(type: TwiiterOAuth.LOGIN, result: Data())
            self.getStatusesHomeTimeLine()
      },
         failure: { error in
            self.isLogged = false;
            self.resultAsyncCaller?.resultFor(type: TwiiterOAuth.LOGOUT, result: Data())
            print(error.localizedDescription)
      }
      )
   }
   
   func logout() {
      UserDefaults.standard.removeObject(forKey: "oauthTokenTwitter")
      UserDefaults.standard.removeObject(forKey: "oauthTokenSecretTwitter")
      UserDefaults.standard.synchronize()
      isLogged = false
      self.resultAsyncCaller?.resultFor(type: TwiiterOAuth.LOGOUT, result: Data())
   }
   
   func getFollowers() {
      executeGet(urlString: "https://api.twitter.com/1.1/followers/list.json", resultType: TwiiterOAuth.FOLLOWERS)
   }
   
   func getAccountSetings() {
      executeGet(urlString: "https://api.twitter.com/1.1/account/settings.json", resultType: TwiiterOAuth.ACCOUNT_SETINGS)
   }
   
   func getStatusesHomeTimeLine() {
      executeGetWithParameters(urlString: "https://api.twitter.com/1.1/statuses/home_timeline.json",
                               parameters: ["tweet_mode":"extended", "count":200],
                               resultType: TwiiterOAuth.STATUSES_HOME_TIME_LINE)
   }
   
   private func executeGet(urlString: String, resultType: String) {
      let _ = oauthswift.client.get(urlString,
                                    success: { response in
                                          self.resultAsyncCaller?.resultFor(type: resultType, result: response.data)
                                          
                                       
      }, failure: { error in
         print(error)
      })
   }
   
   private func executeGetWithParameters(urlString: String, parameters: OAuthSwift.Parameters = [:], resultType: String) {
      let _ = oauthswift.client.get(urlString, parameters: parameters,
                                    success: { response in
                                          self.resultAsyncCaller?.resultFor(type: resultType, result: response.data)
                                       
      }, failure: { error in
         print(error)
      })
   }
   
}
