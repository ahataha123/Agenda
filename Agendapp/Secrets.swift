import Foundation

enum Secrets {
    static var newsApiKey: String {
        guard let key = Bundle.main
            .object(forInfoDictionaryKey: "NEWS_API_KEY") as? String,
              !key.isEmpty else {
            fatalError("NEWS_API_KEY not found. Check Secrets.xcconfig + Info.plist")
        }
        return key
    }
}
