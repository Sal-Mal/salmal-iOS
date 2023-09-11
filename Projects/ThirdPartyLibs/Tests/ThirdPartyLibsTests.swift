import Foundation
import XCTest

@testable import ThirdPartyLibs

final class ThirdPartyLibsTests: XCTestCase {

  func test_twoPlusTwo_isFour() {
    XCTAssertEqual(2+2, 4)
  }
}

