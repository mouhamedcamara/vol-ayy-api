//
//  File.swift
//  
//
//  Created by Mouhamed Camara on 24/11/2020.
//


import Fluent
import Vapor

struct AccountController: RouteCollection
{
    func boot(routes: RoutesBuilder) throws
    {
        let amount = routes.grouped("api").grouped("amount")
        amount.get(use: index)
        amount.post("create", use: create)
        amount.group(":accountID") { box in
            amount.put("update", use: update)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[Account]>
    {
        return Account.query(on: req.db).all()
    }
    
    func create(req: Request) throws -> EventLoopFuture<Account>
    {
        let amount = try req.content.decode(Account.self)
        return amount.save(on: req.db).map { amount }
    }
    
    struct PatchAccountRequestBody: Content
    {
        let amount: Int?
    }

    func update(req: Request) throws -> EventLoopFuture<Account>
    {
        let patchAccountRequestBody = try req.content.decode(PatchAccountRequestBody.self)
        
        return Account.find(req.parameters.get("accountID"), on: req.db)
                .unwrap(or: Abort(.notFound))
                .flatMap { account in
                    if let amount = patchAccountRequestBody.amount
                    {
                        account.amount = amount
                    }
                    return account.update(on: req.db)
                        .transform(to: account)
            }
    }
}
