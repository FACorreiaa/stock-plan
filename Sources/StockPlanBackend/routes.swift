import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    try app.register(collection: AuthController())
    try app.register(collection: StocksController())
    try app.register(collection: MarketDataController())
    try app.register(collection: PortfolioController())
    try app.register(collection: BrokerController())
}
