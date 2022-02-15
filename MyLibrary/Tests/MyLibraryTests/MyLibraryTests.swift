import XCTest
@testable import MyLibrary

final class MyLibraryTests: XCTestCase {
    func testWeather() throws {
        
        let myLibrary = MyLibrary()
        let expectation = XCTestExpectation(description: "We want the temperature")
        var temperature: String?

        // When
        myLibrary.getWeather(completion: { temp in
            temperature = temp
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 30)

        // Then
        //print(temperature)
        XCTAssertNotNil(temperature)
        //XCTAssert(temperature == true)
    }

    func testHello() throws {
        
        let myLibrary = MyLibrary()
        let expectation = XCTestExpectation(description: "We want a greeting")
        var greeting: String?

        // When
        myLibrary.getHello(completion: { hello in
            greeting = hello
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 30)

        // Then
        //print(greeting)
        XCTAssertNotNil(greeting)
        //XCTAssert(greeting == true)
    }

    func testGetToken() throws {
        
        let myLibrary = MyLibrary()
        let expectation = XCTestExpectation(description: "We want a token")
        var authToken: String?

        // When
        myLibrary.getToken(completion: { token in
            authToken = token
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 30)

        // Then
        //print(greeting)
        XCTAssertNotNil(authToken)
        //XCTAssert(greeting == true)
    }
}
