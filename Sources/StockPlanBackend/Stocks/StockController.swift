import Vapor
import Foundation

struct StockController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        routes.get("stocks", use: getStocks)
        routes.get("stocks/:ticker", use: getStockByTicker)
        routes.get("stocks/:id", use: getStock)
        routes.post("stocks", use: createStock)
        routes.delete("stocks/:ticker", use: deleteStockByTicker)
        routes.delete("stocks/:id", use: deleteStock)
        routes.put("stock/:ticker", use: updateStock)
        routes.get("stock/:ticker/history", use: getStockHistory)
        routes.get("stock/:ticker/news", use: getStockNews)
        routes.get("stock/:ticker/chart", use: getStockChart)
    }
    
    @Sendable
    func getStocks(req: Request) async throws -> [Stock] {
        return []
    }
     
    @Sendable
    func getStockByTicker(req: Request) async throws -> Stock {
        return Stock()
    }
    
    @Sendable
    func getStock(req: Request) async throws -> Stock {
        return Stock()
    }
    
    @Sendable
    func createStock(req: Request) async throws -> Stock {
        return Stock()
    }
    
    @Sendable
    func deleteStockByTicker(req: Request) async throws -> HTTPStatus {
        return .ok
    }
    
    @Sendable
    func deleteStock(req: Request) async throws -> HTTPStatus {
        return .ok
    }
    
    @Sendable
    func updateStock(req: Request) async throws -> Stock {
       return Stock()
    }
    
    @Sendable
    func getStockHistory(req: Request) async throws -> [StockHistory] {
        return []
    }
    
    @Sendable
    func getStockNews(req: Request) async throws -> [StockNews] {
        return []
    }
    
    @Sendable
    func getStockChart(req: Request) async throws -> String {
        return ""
    }
    
}



