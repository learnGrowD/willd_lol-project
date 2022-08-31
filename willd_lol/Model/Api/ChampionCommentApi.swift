//
//  ChampionCommentApi.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/07.
//

import Foundation


struct ChampionCommentApi : Codable {
    let data : [Comment]
    
    struct Comment : Codable {
        let id : Int?
        let content : String?
        let vote : Int?
        let version : String?
        let user : User
        let createdAt : String?
        
        struct User : Codable {
            let levelName : String?
            let username : String?
            
            enum Codingkeys : String, CodingKey {
                case username
                case levelName = "level_name"
            }
        }
        
        enum Codingkeys : String, CodingKey {
            case id, content, vote, version, user
            case createdAt = "created_at"
        }
        
    }
}
