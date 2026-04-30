@testable import BeerHopper
import XCTest

final class BeerHopperDeepLinkParserTests: XCTestCase {
    private var parser: BeerHopperDeepLinkParser!

    override func setUp() {
        super.setUp()
        self.parser = BeerHopperDeepLinkParser()
    }

    override func tearDown() {
        self.parser = nil
        super.tearDown()
    }

    func testParsesSearchAcrossSupportedHosts() throws {
        let hosts = [
            "beerhopper.com",
            "www.beerhopper.com",
            "beerhopper.me",
            "www.beerhopper.me"
        ]

        for host in hosts {
            let route = self.parser.parse(try XCTUnwrap(URL(string: "https://\(host)/search?q=ipa")))
            XCTAssertEqual(route, .search(query: "ipa"))
        }
    }

    func testRejectsUnsupportedHosts() throws {
        let route = self.parser.parse(try XCTUnwrap(URL(string: "https://example.com/search?q=ipa")))

        XCTAssertNil(route)
    }

    func testParsesBreweryProfileSlugRoute() throws {
        let route = self.parser.parse(try XCTUnwrap(URL(string: "https://www.beerhopper.com/wa/seattle/pike-brewing")))

        XCTAssertEqual(route, .brewerySlug(state: "wa", city: "seattle", slug: "pike-brewing"))
    }

    func testParsesNativeSchemeLogin() throws {
        let route = self.parser.parse(try XCTUnwrap(URL(string: "beerhopper://login")))

        XCTAssertEqual(route, .login)
    }
}
