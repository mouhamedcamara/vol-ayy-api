//
//  File.swift
//  
//
//  Created by Mouhamed Camara on 11/3/20.
//

import Fluent

struct CreateBoxes: Migration {
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema(Box.schema)
        .id()
        .field("user_id", .uuid)
        .foreignKey("user_id", references: "users", "id", onDelete: .cascade, onUpdate: .cascade)
        .field("name", .string, .required)
        .field("number", .int, .required)
        .field("expense", .int, .required)
        .field("death", .int, .required)
        .field("age", .int, .required)
        .field("vendu", .int, .required)
        .field("revenu", .int, .required)
        .field("created_at", .datetime, .required)
        .create()
  }

  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema(Box.schema).delete()
  }
}
