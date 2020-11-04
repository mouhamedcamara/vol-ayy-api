//
//  File.swift
//  
//
//  Created by Mouhamed Camara on 11/3/20.
//

import Fluent
import Vapor

struct CreateUser: Migration {
    var name: String { "CreateUser" }

    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users")
            .id()
            .field("name", .string, .required)
            .field("phone", .string, .required)
            .unique(on: "phone")
            .field("email", .string, .required)
            .field("password", .string, .required)
            .field("created_at", .datetime, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users").delete()
    }
}
