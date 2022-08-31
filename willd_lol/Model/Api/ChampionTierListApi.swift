//
//  ChampionTierListApi.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/07.
//

import Foundation


struct ChampionTierListApi : Codable {
    let results : [Champion]
    
    struct Champion : Codable {
        let banRate : String?
        let championKey : String?
        let championDataKey : Int?
        let championName : String?
        let count : Int?
        let isOp : Bool?
        let laneLaneNameKr : String?
        let opScore : String?
        let opTier : Int?
        let pickRate : String?
        let winRate : String?
        
        enum CodingKeys : String, CodingKey {
            case count
            case banRate = "ban_rate"
            case championKey = "champion__data_id"
            case championDataKey = "champion__data_key"
            case championName = "champion__name"
            case isOp = "is_op"
            case laneLaneNameKr = "lane__lane_name_kr"
            case opScore = "op_score"
            case opTier = "op_tier"
            case pickRate = "pick_rate"
            case winRate = "win_rate"
        }
    }
}
