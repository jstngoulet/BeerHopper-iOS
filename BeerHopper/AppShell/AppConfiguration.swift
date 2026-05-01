import Foundation

struct AppConfiguration {
    let apiBaseURL: URL

    static let production = AppConfiguration(
        apiBaseURL: URL(string: "https://api.beerhopper.com/api") ?? URL(fileURLWithPath: "/")
    )
}
