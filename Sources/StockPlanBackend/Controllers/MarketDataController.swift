import Vapor
import Foundation

struct MarketDataController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        routes.get("quote", ":symbol", use: quote)
        routes.get("history", ":symbol", use: history)
        routes.get("search", use: search)
        routes.get("fx", use: fx)
    }

    @Sendable
    func quote(req: Request) async throws -> QuoteResponse {
        let symbol = req.parameters.get("symbol") ?? "UNKNOWN"
        return QuoteResponse(symbol: symbol, price: 0, currency: "USD", asOf: "1970-01-01")
    }

    @Sendable
    func history(req: Request) async throws -> HistoryResponse {
        let symbol = req.parameters.get("symbol") ?? "UNKNOWN"
        return HistoryResponse(symbol: symbol, currency: "USD", bars: [])
    }

    @Sendable
    func search(req: Request) async throws -> [SearchResultResponse] {
        _ = req.query[String.self, at: "q"]
        return []
    }

    @Sendable
    func fx(req: Request) async throws -> FxRateResponse {
        let pairRaw = (req.query[String.self, at: "pair"] ?? "EURUSD").replacingOccurrences(of: "/", with: "")
        let base = String(pairRaw.prefix(3))
        let quote = String(pairRaw.suffix(3))
        return FxRateResponse(base: base, quote: quote, rate: 1.0, date: "1970-01-01")
    }
}
