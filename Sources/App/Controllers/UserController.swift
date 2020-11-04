////
////  File.swift
////
////
////  Created by Mouhamed Camara on 11/3/20.
////
//


import Fluent
import Vapor

/// Creates new users and logs them in.
struct UserController: RouteCollection {

    func boot(routes: RoutesBuilder) throws
    {
        let users = routes.grouped("api").grouped("auth")
        users.post("create", use: create)
        
        let passwordProtected = users.grouped(User.authenticator())
        passwordProtected.post("login", use: login)
        
        let tokenProtected = users.grouped(Token.authenticator())
        tokenProtected.get("user", use: user)
    }

    func create(req: Request) throws -> EventLoopFuture<User> {
        
        try User.Create.validate(content: req)
        let create = try req.content.decode(User.Create.self)
        guard create.password == create.confirmPassword else {
            throw Abort(.badRequest, reason: "Passwords did not match")
        }
        let user = try User(
            name: create.name,
            phone: create.phone,
            email: create.email,
            password: Bcrypt.hash(create.password)
        )
        return user.save(on: req.db)
            .map { user }
    }
    
    func login(req: Request) throws -> EventLoopFuture<Token> {
        let user = try req.auth.require(User.self)
        let token = try user.generateToken()
        return token.save(on: req.db)
            .map { token }
    }
    
    func user(req: Request) throws -> User
    {
        try req.auth.require(User.self)
    }
}
