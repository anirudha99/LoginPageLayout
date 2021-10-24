//
//  LoginPageLayoutTests.swift
//  LoginPageLayoutTests
//
//  Created by Anirudha SM on 21/10/21.
//

import XCTest

@testable import LoginPageLayout

class LoginPageLayoutTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testEmailValidationEmptyStringIsInvalid(){
        let result = Utilities.isEmailValid("")
        XCTAssertFalse(result)
    }
    
    func testEmailValidationWithoutComIsInvalid(){
        let result = Utilities.isEmailValid("anirudha.mayya@gmail")
        XCTAssertFalse(result)
    }
    
    
    func testEmailValidationWithoutAtTheRateIsInvalid(){
        let result = Utilities.isEmailValid("anirudha.mayyagmail.com")
        XCTAssertFalse(result)
    }
    
    func testEmailValidationWithoutDotIsInvalid(){
        let result = Utilities.isEmailValid("anirudha.mayya@gmailcom")
        XCTAssertFalse(result)
    }
    
    func testEmailValidationIsValid(){
        let result = Utilities.isEmailValid("anirudha.mayya@gmail.com")
        XCTAssertTrue(result)
    }

}
