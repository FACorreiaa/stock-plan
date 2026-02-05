import Vapor
import Foundation

struct BrokerController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let brokers = routes.grouped("brokers")
        brokers.get(use: listBrokers)
        brokers.get("holdings", use: listHoldings)

        brokers.post("ibkr", "sync", use: syncIbkr)
    }

    @Sendable
    func listBrokers(req: Request) async throws -> [BrokerConnectionResponse] {
        []
    }

    @Sendable
    func listHoldings(req: Request) async throws -> [BrokerHoldingResponse] {
        []
    }

    @Sendable
    func syncIbkr(req: Request) async throws -> BrokerSyncResponse {
        BrokerSyncResponse(runId: UUID().uuidString, status: "accepted")
    }
}
