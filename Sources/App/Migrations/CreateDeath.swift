//
//  CreateExpense.swift
//  
//
//  Created by Mouhamed Camara on 11/4/20.
//


import Fluent


struct CreateDeath: Migration {
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema(Death.schema)
        .id()
        .field("box_id", .uuid)
        .foreignKey("box_id", references: "boxes", "id", onDelete: .cascade, onUpdate: .cascade)
        .field("number", .int, .required)
        .field("created_at", .datetime, .required)
        .create()
  }

  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema(Death.schema).delete()
  }
}
