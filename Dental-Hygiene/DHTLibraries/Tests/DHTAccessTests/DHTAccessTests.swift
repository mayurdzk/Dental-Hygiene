import XCTest
@testable import DHTAccess

final class DHTAccessTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(DHTAccess().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
