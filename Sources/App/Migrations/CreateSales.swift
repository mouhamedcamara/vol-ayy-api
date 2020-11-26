//
//  File.swift
//  
//
//  Created by Mouhamed Camara on 11/3/20.
//

import Fluent


struct CreateSales: Migration {
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema(Sale.schema)
        .id()
        .field("user_id", .uuid)
        .foreignKey("user_id", references: "users", "id", onDelete: .cascade, onUpdate: .cascade)
        .field("box_id", .uuid)
        .foreignKey("box_id", references: "boxes", "id", onDelete: .cascade, onUpdate: .cascade)
        .field("client_name", .string, .required)
        .field("client_number", .int)
        .field("quantity", .int, .required)
        .field("unit_price", .int, .required)
        .field("total_price", .int, .required)
        .field("location", .string, .required)
        .field("status", .bool, .required)
        .field("created_at", .datetime, .required)
        .create()
  }

  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema(Sale.schema).delete()
  }
}
