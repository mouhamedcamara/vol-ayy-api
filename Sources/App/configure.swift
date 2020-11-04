import Fluent
//import FluentMySQLDriver
import FluentPostgresDriver

import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

//   app.databases.use(.mysql(
//       hostname: "localhost",
//       port: 3333,
//       username: "camou",
//       password: "camou",
//       database: "vol'ayy",
//       tlsConfiguration: nil,
//       maxConnectionsPerEventLoop: 1
//   ), as: .mysql)
    
    
    
    if let databaseURL = Environment.get("DATABASE_URL"), var postgresConfig = PostgresConfiguration(url: databaseURL) {
        postgresConfig.tlsConfiguration = .forClient(certificateVerification: .none)
        app.databases.use(.postgres(
            configuration: postgresConfig
        ), as: .psql)
    } else {
        // ...
    }
    
    

    app.migrations.add(CreateUser())
    app.migrations.add(CreateTokens())
    app.migrations.add(CreateBoxes())
    app.migrations.add(CreateSales())
    app.migrations.add(CreateExpense())
    
    try app.autoMigrate().wait()
    
    // register routes
    try routes(app)
}
