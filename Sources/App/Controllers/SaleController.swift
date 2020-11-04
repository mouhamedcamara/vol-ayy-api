//
//  SaleController.swift
//  
//
//  Created by Mouhamed Camara on 11/3/20.
//

import Fluent
import Vapor

struct SaleController: RouteCollection
{
    func boot(routes: RoutesBuilder) throws
    {
        let sales = routes.grouped("api").grouped("sale")
        sales.get(use: index)
        sales.post("create", use: create)
        sales.group(":saleID") { sale in
            sale.delete("delete", use: delete)
            sale.put("update", use: update)
            sale.get("read", use: read)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[Sale]>
    {
        return Sale.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Sale>
    {
        let sale = try req.content.decode(Sale.self)
        return sale.save(on: req.db).map { sale }
    }
    
    func read(req: Request) throws -> EventLoopFuture<Sale>
    {
        return Sale.find(req.parameters.get("saleID"), on: req.db)
                .unwrap(or: Abort(.notFound))
    }
    
    struct PatchCategoryRequestBody: Content
    {
        let name: String?
//        let activated: Bool?
    }

    func update(req: Request) throws -> EventLoopFuture<Sale>
    {
        let patchCategoryRequestBody = try req.content.decode(PatchCategoryRequestBody.self)
        
        return Sale.find(req.parameters.get("saleID"), on: req.db)
                .unwrap(or: Abort(.notFound))
                .flatMap { sale in
                    if let name = patchCategoryRequestBody.name
                    {
                        sale.client_name = name
                    }
//                    if let activated = patchCategoryRequestBody.activated
//                    {
//                        category.activated = activated
//                    }
                    return sale.update(on: req.db)
                        .transform(to: sale)
            }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus>
    {
        return Sale.find(req.parameters.get("saleID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
