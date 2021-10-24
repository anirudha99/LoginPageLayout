//
//  passwordValidation.swift
//  LoginPageLayoutTests
//
//  Created by Anirudha SM on 21/10/21.
//

import XCTest
@testable import LoginPageLayout

class passwordValidation: XCTestCase {

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
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testPasswordValidationEmptyStringIsInvalid(){
        let result = Utilities.isPasswordValid("")
        XCTAssertFalse(result)
    }
    
    func testPasswordValidationLessThanEightCharactersIsInvalid(){
        let result = Utilities.isPasswordValid("aBc@12")
        XCTAssertFalse(result)
    }
    
    func testPasswordValidationNoSpecialCharacterIsInvalid(){
        let result = Utilities.isPasswordValid("Asdfg1234")
        XCTAssertFalse(result)
    }
    
    func testPasswordValidationNoNumbersIsInvalid(){
        let result = Utilities.isPasswordValid("qwertyuiop@*")
        XCTAssertFalse(result)
    }
    
    func testPasswordValidationNoCapsIsInvalid(){
        let result = Utilities.isPasswordValid("qwertyui@12")
        XCTAssertFalse(result)
    }
    
    func testPasswordValidationForValidCase(){
        let result = Utilities.isPasswordValid("Qwerty@123")
        XCTAssertTrue(result)
    }

}
