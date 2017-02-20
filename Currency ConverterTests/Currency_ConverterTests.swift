//
//  Currency_ConverterTests.swift
//  Currency ConverterTests
//
//  Created by Robert King on 2/17/17.
//  Copyright © 2017 robbyking. All rights reserved.
//

import XCTest
@testable import Currency_Converter

class Currency_ConverterTests: XCTestCase {
    
    var homescreenViewController: HomescreenViewController?
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Homescreen", bundle: Bundle.main)
        homescreenViewController = storyboard.instantiateInitialViewController() as? HomescreenViewController
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    //TODO: Write tests. 
}
