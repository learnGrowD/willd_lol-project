//
//  ChampionRecommend.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/07.
//

import Foundation


struct ChampionRecommendApi : Codable {
    let total : Int?
    let nextPage : String?
    let results : [Result]
    
    enum CodingKeys : String, CodingKey {
        case results
        case nextPage = "next"
        case total = "count"
    }
    
    struct Result : Codable {
        let champion : Champion
        let desc : String?
        let lane : String?
        let info : FetchInfo
        
        struct Champion : Codable {
            let championKey : String?
            let dataKey : Int?
            let name : String?
            
            enum CodingKeys : String, CodingKey {
                case name
                case championKey = "data_id"
                case dataKey = "data_key"
            }
        }
        
        struct FetchInfo : Codable {
            let before : Specific
            let diff : Specific // version is nil...
            let now : Specific
            
            struct Specific : Codable {
                let banRate : Double?
                let pickRate : Double?
                let version : String?
                let winRate : Double?
                
                enum CodingKeys : String, CodingKey {
                    case version
                    case banRate = "ban_rate"
                    case pickRate = "pick_rate"
                    case winRate = "win_rate"
                }
            }
        }
    }

}
