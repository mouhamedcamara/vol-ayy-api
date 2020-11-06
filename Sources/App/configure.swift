import Fluent
//import FluentMySQLDriver
import FluentPostgresDriver

import Vapor

// configures your application

extension Application {
    static let databaseUrl = URL(string: "    postgres://uwbpgxavmthxuy:5fbf6d0993c02a226514172b1875ecd9822fa7b89562f33ce6f200f1830ac2aa@ec2-54-76-215-139.eu-west-1.compute.amazonaws.com:5432/d8es0n4g3380id")
}

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
    
//    app.databases.use(try .postgres(url: "    postgres://uwbpgxavmthxuy:5fbf6d0993c02a226514172b1875ecd9822fa7b89562f33ce6f200f1830ac2aa@ec2-54-76-215-139.eu-west-1.compute.amazonaws.com:5432/d8es0n4g3380id"), as: .psql)
    
//    try app.databases.use(.postgres(url: Application.databaseUrl!), as: .psql)
    
    let databaseURL = "postgres://uwbpgxavmthxuy:5fbf6d0993c02a226514172b1875ecd9822fa7b89562f33ce6f200f1830ac2aa@ec2-54-76-215-139.eu-west-1.compute.amazonaws.com:5432/d8es0n4g3380id"
    
    var postgresConfig = PostgresConfiguration(url: databaseURL)
    postgresConfig?.tlsConfiguration = .forClient(certificateVerification: .none)
    app.databases.use(.postgres(
        configuration: postgresConfig!
    ), as: .psql)
    
    //Initiate
        
//        let rassoul = User(name: "Mouhamed Camara", phone: "77 577 93 93", email: "mhrassoul.camara@gmail.com", password: "muqtafina@9")
//        let ba = User(name: "Alioune Khaly Ba", phone: "77 288 28 59", email: "baaliounekhaly@gmail.com", password: "testeur")
//        let testeur = User(name: "Amina", phone: "771000000", email: "amina@gmail.com", password: "testeur")

//        try testeur.create(on: app.db).wait()
    
    app.migrations.add(CreateUser())
    app.migrations.add(CreateTokens())
    app.migrations.add(CreateBoxes())
    app.migrations.add(CreateSales())
    app.migrations.add(CreateExpense())
    
    try app.autoMigrate().wait()
    
    // register routes
    try routes(app)
}
