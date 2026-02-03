# StockPlanBackend

A personal stock portfolio tracker backend built with Vapor (Swift). This server-side application provides RESTful APIs for managing stock holdings, tracking historical performance, and fetching real-time price data. Designed to pair with a SwiftUI mobile app for a full-stack Swift experience.

## Overview

StockPlanBackend enables you to:
- Track holdings and watchlists with buy/sell prices, dates, and notes
- Draft due diligence notes (thesis, risks, catalysts, links)
- Set base, bear, and bull targets with timeframes and rationale
- Fetch current quotes and daily historical prices from external providers
- Calculate portfolio gains/losses and performance metrics
- Store user data securely with JWT authentication
- Sync data across devices for iOS and macOS clients

## Product Name and Marketing Copy

### Product Name
StockPlan

### App Store Subtitle
Track portfolios. Draft DD. Set bull/bear targets.

### Marketing Blurb (Short)
StockPlan is built for active investors who want a clean way to follow positions, write due diligence, and set base/bear/bull targets. Connect your brokers and stay current with up-to-date performance across your watchlist.

### App Store Description (Long)
StockPlan helps active investors stay on top of their portfolios with a clear workflow for research, targets, and tracking. Build and maintain due diligence notes, define base/bear/bull scenarios for each stock, and follow performance across your watchlist in one place.

Key features:
- Portfolio tracking with broker connections
- Due diligence drafts and structured notes
- Base, bear, and bull target scenarios
- Watchlists with current pricing and performance
- Cross-device sync for iOS and macOS

### Onboarding Copy (Suggested)
1. Welcome to StockPlan
Define your investing workflow in one place.
2. Follow Your Stocks
Track positions and watchlists with current pricing.
3. Draft Your Due Diligence
Capture thesis, risks, and catalysts as you research.
4. Set Targets
Create base, bear, and bull scenarios for each stock.
5. Connect Your Brokers
Sync holdings to stay up to date across devices.

Built for deployment on budget VPS instances like Hetzner's CPX11 ($5/month), this backend is optimized for low resource usage while maintaining production-ready performance.

## Features

### Core Features (MVP)
- **Accounts and Auth**: Register/login with JWT for secure multi-device access
- **Portfolio and Watchlist**: CRUD holdings and watchlist entries
- **Due Diligence Notes**: Thesis, risks, catalysts, and reference links per stock
- **Targets**: Base/bear/bull price targets with dates and rationale
- **Market Data**: Quotes and daily history from external APIs with caching
- **Broker Sync v1**: Read-only import to seed holdings (manual/CSV fallback)
- **RESTful API**: JSON endpoints for iOS and macOS clients

### Planned Extensions
- **Real-Time Updates**: WebSocket support for live price streaming
- **Price Alerts**: Push notifications via APNS when stocks hit target prices
- **News Integration**: Pull relevant articles/RSS feeds for tracked stocks
- **Paper Trading**: Simulate trades without real money to test strategies
- **Advanced Analytics**: CAGR, volatility, Sharpe ratio, attribution
- **Expanded Broker Coverage**: More providers and optional trade execution
- **Automation**: Scheduled tasks for daily refresh and data maintenance

## Architecture

### Full-Stack Swift Benefits
- **Shared Models**: Use the same `Stock`, `Portfolio`, `User` structs on server and mobile app
- **Type Safety**: Reduce bugs with Swift's strong typing across the entire stack
- **Code Reuse**: Business logic (e.g., portfolio calculations) can be extracted to a shared Swift package

### Tech Stack
- **Server Framework**: Vapor 4.x
- **Database**: PostgreSQL (production) or SQLite (development)
- **Authentication**: JWT tokens via Vapor's JWT package
- **External APIs**: HTTP client for stock data providers
- **Deployment**: Docker on Hetzner VPS with HTTPS (Let's Encrypt)

## API Endpoints

### Authentication
- `POST /auth/register` - Create new user account
- `POST /auth/login` - Authenticate and receive JWT token

### Stocks
- `GET /stocks` - List all stocks in user's portfolio
- `POST /stocks` - Add a new stock holding
- `GET /stocks/:id` - Get details for a specific holding
- `PUT /stocks/:id` - Update holding (e.g., add notes, adjust buy price)
- `DELETE /stocks/:id` - Remove stock from portfolio

### Watchlist
- `GET /watchlist` - List watchlist entries
- `POST /watchlist` - Add a symbol to watchlist
- `DELETE /watchlist/:id` - Remove from watchlist

### Research (Due Diligence)
- `GET /research` - List due diligence notes
- `POST /research` - Create a new note
- `GET /research/:id` - Get a specific note
- `PUT /research/:id` - Update a note
- `DELETE /research/:id` - Remove a note

### Targets
- `GET /targets?stockId=:id` - List targets for a stock
- `POST /targets` - Create a base/bear/bull target
- `PUT /targets/:id` - Update a target
- `DELETE /targets/:id` - Remove a target

### Broker Connections
- `POST /brokers/connect` - Start broker connection flow
- `GET /brokers` - List connected brokers
- `POST /brokers/import` - Import holdings (read-only)
- `GET /brokers/holdings` - List imported holdings

### Market Data
- `GET /history/:symbol` - Fetch historical prices (5/10 year time-series)
- `GET /quote/:symbol` - Get current price for a stock symbol
- `GET /search?q=:query` - Search for stock symbols/companies

### Portfolio Analytics
- `GET /portfolio/summary` - Total value, gains/losses, allocation
- `GET /portfolio/performance` - Historical performance metrics

## Getting Started

### Prerequisites
- Swift 5.9+ (included with Xcode 15+)
- PostgreSQL (optional for production) or use SQLite for local development
- External API key (e.g., free tier from Alpha Vantage)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd StockPlanBackend
```

2. Configure environment variables (create `.env.development`):
```bash
DATABASE_URL=postgres://user:password@localhost/stockplan
JWT_SECRET=your-secret-key-here
STOCK_API_KEY=your-alpha-vantage-key
```

3. Build the project:
```bash
swift build
```

4. Run database migrations:
```bash
swift run Run migrate
```

5. Start the server:
```bash
swift run
```

The server will start on `http://localhost:8080` by default.

### Development Commands

Run the server with auto-reload during development:
```bash
swift run Run serve --auto-reload
```

Execute tests:
```bash
swift test
```

Revert last database migration:
```bash
swift run Run migrate --revert
```

## Deployment

### Docker Deployment (Recommended)

1. Build the Docker image:
```bash
docker build -t stockplan-backend .
```

2. Run with environment variables:
```bash
docker run -p 8080:8080 \
  -e DATABASE_URL=postgres://... \
  -e JWT_SECRET=... \
  -e STOCK_API_KEY=... \
  stockplan-backend
```

### Hetzner VPS Setup

The backend is optimized for Hetzner's CPX11 instance (2 vCPUs, 2 GB RAM, €4.99/month):

1. **Resource Efficiency**: Vapor uses ~10-50 MB RAM idle, ~100 MB under load
2. **Storage**: Binary size ~20-50 MB, plenty of room on 40 GB SSD
3. **Network**: Handles 50-80k req/s in benchmarks, suitable for personal/small-scale use
4. **HTTPS**: Configure with Let's Encrypt for free SSL certificates

Deploy using Docker Compose with PostgreSQL:
```bash
docker-compose up -d
```

Monitor resource usage:
```bash
docker stats
```

## Performance Considerations

### Vapor vs. Go on Budget VPS
- **RAM**: Vapor uses 10-30% more than equivalent Go apps, but both fit easily in 2 GB
- **CPU**: Go is 20-50% more efficient under high load, but Vapor handles typical personal app traffic well
- **Throughput**: Vapor achieves 50-80k req/s vs. Go's 100k+, more than sufficient for <1,000 daily users
- **Binary Size**: Vapor binaries are 10-50 MB vs. Go's 5-20 MB (negligible on 40 GB disk)

**Verdict**: For this personal project, Vapor's benefits (full-stack Swift, type safety, code sharing with mobile app) outweigh Go's marginal efficiency gains. The $5 Hetzner server has plenty of headroom for both.

## Database Schema

### Users
- `id` (UUID, primary key)
- `email` (String, unique)
- `password_hash` (String)
- `created_at` (Date)

### Stocks
- `id` (UUID, primary key)
- `user_id` (UUID, foreign key)
- `symbol` (String, e.g., "AAPL")
- `shares` (Double)
- `buy_price` (Double)
- `buy_date` (Date)
- `notes` (String, optional)
- `created_at` (Date)
- `updated_at` (Date)

### Price History (Cached)
- `id` (UUID, primary key)
- `symbol` (String, indexed)
- `date` (Date, indexed)
- `open`, `high`, `low`, `close` (Double)
- `volume` (Int)

## External API Integration

The backend fetches stock data from free/freemium APIs:

### Alpha Vantage (Recommended)
- Free tier: 25 requests/day
- 5/10 year historical data via `TIME_SERIES_DAILY`
- Current quotes via `GLOBAL_QUOTE`

### Yahoo Finance (Alternative)
- Unofficial API via HTTP requests
- No key required, but rate-limited
- Broader international stock coverage

Implement caching to minimize API calls:
- Store daily prices in database
- Update once per day via scheduled Vapor task
- Serve cached data to mobile app

## Security

- **JWT Tokens**: Expire after 7 days, stored securely on mobile (Keychain)
- **Password Hashing**: Use BCrypt via Vapor's crypto utilities
- **HTTPS**: Required for production deployment
- **Rate Limiting**: Prevent abuse with Vapor middleware (e.g., 100 req/min per IP)
- **Input Validation**: Validate stock symbols, numeric fields server-side

## Mobile App Integration

This backend pairs with a SwiftUI mobile app. Shared code via Swift Package Manager:

```swift
// Shared package: StockModels
public struct Stock: Codable {
    public let id: UUID?
    public let symbol: String
    public let shares: Double
    public let buyPrice: Double
    public let buyDate: Date
    public let notes: String?
}
```

Use in both Vapor routes and SwiftUI views—no duplication, no sync issues.

## Roadmap

### Phase 1: MVP (4-6 weeks)
- [x] Basic Vapor project setup
- [ ] User authentication (register/login)
- [ ] Portfolio and watchlist CRUD endpoints
- [ ] Due diligence notes model and CRUD endpoints
- [ ] Base/bear/bull targets model and CRUD endpoints
- [ ] Market data integration (quotes + daily history) with caching
- [ ] Broker connection v1 (read-only import or CSV fallback)
- [ ] PostgreSQL/SQLite database setup

### Phase 2: Enhanced Features (1-2 weeks)
- [ ] Historical data fetching and caching
- [ ] Portfolio summary/analytics endpoints
- [ ] Scheduled tasks for daily price updates
- [ ] Docker deployment configuration

### Phase 3: Advanced Features (Ongoing)
- [ ] WebSocket support for real-time prices
- [ ] APNS integration for price alerts
- [ ] Paper trading simulator
- [ ] News/RSS feed integration
- [ ] Multi-currency support

## Resources

### Vapor
- [Vapor Documentation](https://docs.vapor.codes)
- [Vapor GitHub](https://github.com/vapor/vapor)
- [Vapor Community](https://github.com/vapor-community)

### Stock APIs
- [Alpha Vantage](https://www.alphavantage.co/documentation/)
- [Yahoo Finance (unofficial)](https://github.com/ranaroussi/yfinance)

### Deployment
- [Hetzner Cloud](https://www.hetzner.com/cloud)
- [Docker with Vapor](https://docs.vapor.codes/deploy/docker/)
- [Let's Encrypt SSL](https://letsencrypt.org/)

## License

This project is for personal use. Modify and extend as needed for your stock tracking needs.
# stock-plan
