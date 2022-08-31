//
//  PlayerMmrRankApi.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/07.
//

import Foundation


struct PlayerMmrRankApi : Codable {
    let pro : [PlayerInfo]
    let named : [PlayerInfo]
    let all : [PlayerInfo]
    
    enum CodingKeys : String, CodingKey {
        case pro = "Pro"
        case named = "Named"
        case all = "All"
    }
    
    struct PlayerInfo : Codable {
        let id : Int?
        let imageUrl : String?
        let lane : String?
        let lp : Int?
        let realName : String?
        let displayName : String?
        let summonerName : String?
        let region : String?
        let team : String?
        let tier : String?
        let type : String?
    }
}
