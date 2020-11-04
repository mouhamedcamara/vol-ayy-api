//
//  File.swift
//  
//
//  Created by Mouhamed Camara on 11/4/20.
//


import Fluent
import Vapor

struct ExpenseController: RouteCollection
{
    func boot(routes: RoutesBuilder) throws
    {
        let expenses = routes.grouped("api").grouped("expenses")
        expenses.get(use: index)
        expenses.post("create", use: create)
        expenses.group(":expenseID") { expense in
            expense.delete("delete", use: delete)
            expense.put("update", use: update)
            expense.get("read", use: read)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[Expense]>
    {
        return Expense.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Expense>
    {
        let expense = try req.content.decode(Expense.self)
        return expense.save(on: req.db).map { expense }
    }
    
    func read(req: Request) throws -> EventLoopFuture<Expense>
    {
        return Expense.find(req.parameters.get("expenseID"), on: req.db)
                .unwrap(or: Abort(.notFound))
    }
    
    struct PatchExpenseRequestBody: Content
    {
        let amount: Int?
        let description: String?
    }

    func update(req: Request) throws -> EventLoopFuture<Expense>
    {
        let patchExpenseRequestBody = try req.content.decode(PatchExpenseRequestBody.self)
        
        return Expense.find(req.parameters.get("expenseID"), on: req.db)
                .unwrap(or: Abort(.notFound))
                .flatMap { expense in
                    if let description = patchExpenseRequestBody.description
                    {
                        expense.$description.value = description
                    }
                    if let amount = patchExpenseRequestBody.amount
                    {
                        expense.amount = amount
//                        expense.$task.id = task_id
                    }
                    return expense.update(on: req.db)
                        .transform(to: expense)
            }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus>
    {
        return Expense.find(req.parameters.get("expenseID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
