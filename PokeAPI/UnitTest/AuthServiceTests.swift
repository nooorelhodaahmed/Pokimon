//
//  AuthServiceTests.swift
//  PokeAPITests
//
//  Created by norelhoda on 04/11/2023.
//

import XCTest


class AuthServiceTests: XCTestCase {

    var sut: AuthService!
    
    override func setUp(){
        super.setUp()
        sut = AuthService()
    }
   
    override func tearDown(){
        sut = nil
        super.tearDown()
    }
    
    func getPokimonTest(){
        let promise = XCTestExpectation(description: "fetch pokimon data completed")
        var responseError : Error?
        var reponsePokimon : PokimonData?
        
        guard let bundle = Bundle.unitTest.path(forResource: "stub", ofType: "json") else {
            XCTFail("Error Content not found")
            return
        }
        
        sut.getPokimon(url: URL(fileURLWithPath: bundle) { pokimon,error in
            responseError = error
            reponsePokimon = pokimon
            promise.fulfill()
        })
        wait(for: promise, timeout: 1)
        XCTAssertNil(responseError)
        XCTAssertNotNil(reponsePokimon)
        
    }
}
