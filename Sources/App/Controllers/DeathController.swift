//
//  File.swift
//  
//
//  Created by Mouhamed Camara on 11/4/20.
//


import Fluent
import Vapor

struct DeathController: RouteCollection
{
    func boot(routes: RoutesBuilder) throws
    {
        let deaths = routes.grouped("api").grouped("death")
        deaths.get(use: index)
        deaths.post("create", use: create)
        
    }

    func index(req: Request) throws -> EventLoopFuture<[Death]>
    {
        return Death.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Death>
    {
        let death = try req.content.decode(Death.self)
        return death.save(on: req.db).map { death }
    }
}
