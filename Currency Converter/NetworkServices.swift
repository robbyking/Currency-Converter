//
//  NetworkServices.swift
//  Currency Converter
//
//  Created by Robert King on 2/18/17.
//  Copyright © 2017 robbyking. All rights reserved.
//

import UIKit
import Alamofire

class NetworkServices: NSObject {

    // This is the dictionary that holds all the exchange rates. When it's updated, 
    // it posts a notification letting the view controller know it should update its
    // currency values and reload the table view.
    var exchangeRates: [String: Any]? = [String: Any]() {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "currencyRefreshed"), object: nil)
        }
    }
    
    // The request! I'm not a big fan of the nested "if let" statements, but it was the
    // most concise way to get to the nested dictionary.
    func makeRequest(forCurrency currency: String) {
        Alamofire.request("http://api.fixer.io/latest?base=\(currency)").responseJSON { response in
            // Check to see if the response was successful...
            if let json = response.result.value {
                // ...and if so, cast it as a dictionary,
                if let dictionary = json as? [String: Any] {
                    //...and retrieve the value for "rates," which itself is a dictionary.
                    self.exchangeRates = dictionary["rates"] as! [String : Any]?
                }
            }
        }
    }
}
