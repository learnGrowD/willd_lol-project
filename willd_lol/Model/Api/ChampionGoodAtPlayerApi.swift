//
//  ChampionGoodAtPlayerApi.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/07.
//

import Foundation

struct ChampionGoodAtPlayerApi : Codable {
    let data : [Player]
    
    struct Player : Codable {
        let rank : Int?
        let summoner : Summoner
        
        struct Summoner : Codable {
            let id : Int?
            let name : String?
            let profileImageUrl : String?
            let level : Int?
            let leagueStats : [LeagueState]
            
            
            enum CodingKeys : String, CodingKey {
                case id, name, level
                case profileImageUrl = "profile_image_url"
                case leagueStats = "league_stats"
            }
            
            
            struct LeagueState : Codable {
                let tierInfo : TierInfo
                let win : Int?
                let lose : Int?
                
                enum CodingKeys : String, CodingKey {
                    case tierInfo = "tier_info"
                    case win, lose
                    
                }
                
                struct TierInfo : Codable {
                    let tier : String?
                    let tierImageUrl : String?
                    let borderImageUrl : String?
                    
                    
                    enum CodingKeys : String ,CodingKey {
                        case tier
                        case tierImageUrl = "tier_image_url"
                        case borderImageUrl = "border_image_url"
                    }
                    
                }
                

            }
            
        }
    }
}
