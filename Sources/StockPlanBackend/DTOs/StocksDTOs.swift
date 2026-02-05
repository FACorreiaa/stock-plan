import Vapor

struct StockRequest: Content {
    let symbol: String
    let shares: Double
    let buyPrice: Double
    let buyDate: String
    let notes: String?
}

struct StockResponse: Content {
    let id: String
    let symbol: String
    let shares: Double
    let buyPrice: Double
    let buyDate: String
    let notes: String?
}

struct WatchlistItemRequest: Content {
    let symbol: String
}

struct WatchlistItemResponse: Content {
    let id: String
    let symbol: String
}

struct ResearchNoteRequest: Content {
    let symbol: String
    let title: String?
    let thesis: String
    let risks: String?
    let catalysts: String?
    let referenceLinks: [String]?
}

struct ResearchNoteResponse: Content {
    let id: String
    let symbol: String
    let title: String?
    let thesis: String
    let risks: String?
    let catalysts: String?
    let referenceLinks: [String]?
}

struct TargetRequest: Content {
    let symbol: String
    let scenario: String
    let targetPrice: Double
    let targetDate: String?
    let rationale: String?
}

struct TargetResponse: Content {
    let id: String
    let symbol: String
    let scenario: String
    let targetPrice: Double
    let targetDate: String?
    let rationale: String?
}
