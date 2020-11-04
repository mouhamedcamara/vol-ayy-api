//
//  CreateExpense.swift
//  
//
//  Created by Mouhamed Camara on 11/4/20.
//


import Fluent


struct CreateExpense: Migration {
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema(Expense.schema)
        .id()
        .field("box_id", .uuid)
        .foreignKey("box_id", references: "boxes", "id", onDelete: .cascade, onUpdate: .cascade)
        .field("amount", .int, .required)
        .field("description", .string, .required)
        .field("created_at", .datetime, .required)
        .create()
  }

  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema(Expense.schema).delete()
  }
}
