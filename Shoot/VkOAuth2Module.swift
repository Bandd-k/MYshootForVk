//
//  VkOAuth2Module.swift
//  Shoot
//
//  Created by Denis Karpenko on 17.03.15.
//  Copyright (c) 2015 AeroGear. All rights reserved.
//

import Foundation
import AeroGearOAuth2
import AeroGearHttp
import UIKit

public class VkOAuth2Module : OAuth2Module {
    override public func extractCode(notification: NSNotification, completionHandler: (AnyObject?, NSError?) -> Void) {
        let url: NSURL? = (notification.userInfo as [String: AnyObject])[UIApplicationLaunchOptionsURLKey] as? NSURL
        
        // extract the code from the URL
        let url2 = ChangeUrl(url!)
        let code = self.parametersFromQueryString(url2)["code"]
        println(code)
        // if exists perform the exchange
        if (code != nil) {
            self.exchangeAuthorizationCodeForAccessToken(code!, completionHandler: completionHandler)
            // update state
            state = .AuthorizationStateApproved
        } else {
            
            let error = NSError(domain:AGAuthzErrorDomain, code:0, userInfo:["NSLocalizedDescriptionKey": "User cancelled authorization."])
            completionHandler(nil, error)
        }
        // finally, unregister
        self.stopObserving()
    }
    
    func ChangeUrl(url: NSURL) -> String?{
        var strUrl = url.absoluteString
        var final : String?
        final = ""
        var flag : Bool = false
        for Character in strUrl! {
            if flag {
                final = final! + "\(Character)"
            }
            if Character == "#"{
                flag = true
            }
            
        }
        return final
}
}
