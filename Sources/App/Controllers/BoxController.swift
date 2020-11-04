//
//  File.swift
//  
//
//  Created by Mouhamed Camara on 11/3/20.
//

import Fluent
import Vapor

struct BoxController: RouteCollection
{
    func boot(routes: RoutesBuilder) throws
    {
        let boxes = routes.grouped("api").grouped("box")
        boxes.get(use: index)
        boxes.get("sales", ":boxID", use: sales)
        boxes.post("create", use: create)
        boxes.group(":boxID") { box in
            box.delete("delete", use: delete)
            box.put("update", use: update)
            box.get("read", use: read)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[Box]>
    {
        return Box.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Box>
    {
        let box = try req.content.decode(Box.self)
        return box.save(on: req.db).map { box }
    }
    
    func read(req: Request) throws -> EventLoopFuture<Box>
    {
        return Box.find(req.parameters.get("boxID"), on: req.db)
                .unwrap(or: Abort(.notFound))
    }
    
    struct PatchBoxRequestBody: Content
    {
        let expense: Int?
        let death: Int?
    }

    func update(req: Request) throws -> EventLoopFuture<Box>
    {
        let patchBoxRequestBody = try req.content.decode(PatchBoxRequestBody.self)
        
        return Box.find(req.parameters.get("boxID"), on: req.db)
                .unwrap(or: Abort(.notFound))
                .flatMap { box in
                    if let expense = patchBoxRequestBody.expense
                    {
                        box.expense = expense
                    }
                    if let death = patchBoxRequestBody.death
                    {
                        box.death = death
                    }
                    return box.update(on: req.db)
                        .transform(to: box)
            }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus>
    {
        return Box.find(req.parameters.get("boxID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
    func sales(req: Request) throws -> EventLoopFuture<[Sale]>
    {
        return  Sale.query(on: req.db)
                    .join(Box.self, on: \Sale.$box.$id == \Box.$id, method: .inner)
                    .filter(Box.self, \.$id == UUID(uuidString: req.parameters.get("boxID")!)!)
                    .all()
    }
}
