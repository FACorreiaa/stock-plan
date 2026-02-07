import Fluent
import Foundation
import Vapor

protocol StocksRepository: Sendable {
    func list(userId: UUID, on db: any Database) async throws -> [Stock]
    func find(id: UUID, userId: UUID, on db: any Database) async throws -> Stock?
    func find(symbol: String, userId: UUID, on db: any Database) async throws -> Stock?
    func create(payload: StockRequest, userId: UUID, on db: any Database) async throws -> Stock
    func update(id: UUID, payload: StockRequest, userId: UUID, on db: any Database) async throws -> Stock?
    func delete(id: UUID, userId: UUID, on db: any Database) async throws -> Bool
}

struct DatabaseStocksRepository: StocksRepository {
    func list(userId: UUID, on db: any Database) async throws -> [Stock] {
        try await Stock.query(on: db)
            .filter(\.$userId == userId)
            .sort(\.$createdAt, .descending)
            .all()
    }

    func find(id: UUID, userId: UUID, on db: any Database) async throws -> Stock? {
        try await Stock.query(on: db)
            .filter(\.$id == id)
            .filter(\.$userId == userId)
            .first()
    }

    func find(symbol: String, userId: UUID, on db: any Database) async throws -> Stock? {
        let normalizedSymbol = normalizeSymbol(symbol)
        return try await Stock.query(on: db)
            .filter(\.$userId == userId)
            .filter(\.$symbol == normalizedSymbol)
            .first()
    }

    func create(payload: StockRequest, userId: UUID, on db: any Database) async throws -> Stock {
        let buyDate = try parseISODateOnly(payload.buyDate)
        let stock = Stock(
            userId: userId,
            symbol: normalizeSymbol(payload.symbol),
            shares: payload.shares,
            buyPrice: payload.buyPrice,
            buyDate: buyDate,
            notes: payload.notes
        )
        try await stock.save(on: db)
        return stock
    }

    func update(id: UUID, payload: StockRequest, userId: UUID, on db: any Database) async throws -> Stock? {
        guard let stock = try await find(id: id, userId: userId, on: db) else {
            return nil
        }
        stock.symbol = normalizeSymbol(payload.symbol)
        stock.shares = payload.shares
        stock.buyPrice = payload.buyPrice
        stock.buyDate = try parseISODateOnly(payload.buyDate)
        stock.notes = payload.notes
        try await stock.save(on: db)
        return stock
    }

    func delete(id: UUID, userId: UUID, on db: any Database) async throws -> Bool {
        guard let stock = try await find(id: id, userId: userId, on: db) else {
            return false
        }
        try await stock.delete(on: db)
        return true
    }

    private func parseISODateOnly(_ raw: String) throws -> Date {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: raw) else {
            throw Abort(.badRequest, reason: "Invalid buyDate. Expected YYYY-MM-DD.")
        }
        return date
    }

    private func normalizeSymbol(_ raw: String) -> String {
        raw.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    }
}
