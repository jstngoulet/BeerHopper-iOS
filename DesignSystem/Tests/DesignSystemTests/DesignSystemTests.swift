import XCTest
@testable import DesignSystem

final class DesignSystemTests: XCTestCase {
    func testColumnSizeClassBreakpoints() {
        XCTAssertEqual(BHColumnSizeClass(width: 320), .compact)
        XCTAssertEqual(BHColumnSizeClass(width: 700), .regular)
        XCTAssertEqual(BHColumnSizeClass(width: 1_024), .expanded)
    }
}
