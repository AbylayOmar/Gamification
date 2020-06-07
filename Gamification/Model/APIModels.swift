//
//  APIModels.swift
//  Gamification
//
//  Created by Nurbek on 4/26/20.
//  Copyright © 2020 Nurbek. All rights reserved.
//

struct task: Decodable, Hashable {
    let id: Int
    var name: String?
    var link: String?
    
}

struct challenge: Decodable {
    var id: Int
    var name: String
    var price: Int
    var state: String
    var image_url: String?
    var url: String?
}
struct user: Decodable {
    var percent: Int
    var finished: Int
    var all: Int
}

struct postTasksModel: Encodable {
    var id: Int
    var result: Bool
}
