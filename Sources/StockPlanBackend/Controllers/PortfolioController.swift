import Vapor
import Foundation

struct PortfolioController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let portfolio = routes.grouped("portfolio")
        portfolio.get("summary", use: summary)
        portfolio.get("performance", use: performance)

        routes.get("transactions", use: transactions)
        routes.get("lots", use: lots)
        routes.get("pnl", use: pnl)
    }

    @Sendable
    func summary(req: Request) async throws -> PortfolioSummaryResponse {
        PortfolioSummaryResponse(
            baseCurrency: "USD",
            totalValue: 0,
            totalCost: 0,
            unrealizedPnl: 0,
            realizedPnl: 0,
            allocation: []
        )
    }

    @Sendable
    func performance(req: Request) async throws -> PortfolioPerformanceResponse {
        PortfolioPerformanceResponse(baseCurrency: "USD", points: [])
    }

    @Sendable
    func transactions(req: Request) async throws -> [TransactionResponse] {
        []
    }

    @Sendable
    func lots(req: Request) async throws -> [LotResponse] {
        []
    }

    @Sendable
    func pnl(req: Request) async throws -> PnlResponse {
        PnlResponse(baseCurrency: "USD", items: [])
    }
}
