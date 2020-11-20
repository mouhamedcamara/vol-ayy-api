import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }
    
    try app.register(collection: UserController())
    try app.register(collection: BoxController())
    try app.register(collection: SaleController())
    try app.register(collection: ExpenseController())
    try app.register(collection: DeathController())
    
}
