//
//  PlayerDetailApi.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/07.
//

import Foundation


struct PlayerDetailApi : Codable {
    
    let success : Bool? 
    let summoner : Summoner?
    let mostChampions : [MostChampion]?
    let summary : Summary?
    let matches : [Match]?
    
    struct Summoner : Codable {
        let name : String?
        let profileImage : String?
        let region : String?
        let rank : Rank
        
        
        struct Rank : Codable {

            let soloRank : SoloRank
            
            struct SoloRank : Codable {
                let division : String?
                let lose : Int?
                let lp : Int?
                let matchCategory : String?
                let tier : String?
                let win : Int?
                let winRate : Double?
            }
        }
    }
    
    struct Summary : Codable {
        let assists : Double?
        let deaths : Double?
        let kda : Double?
        let kills : Double?
        let lose : Int?
        let win : Int?
        let winRate : Double?

    }

    struct MostChampion : Codable {
        let items : [Item]
        let lane : String?
        let matchCount : Int?
        let winRate : Double?

        struct Item : Codable {
            let championImage : String?
            let championKey : String?
            let matchCount : Int?
            let winRate : Double?
            let tier : String?
        }
    }


    struct Match : Codable {
        let matchId : Int?
        let matchDate : Int? // t : 24 / m : 60 / s :60 / ms : 1000
        let matchCategory : String?
        let isClassic : Bool?
        let gameTime : Int? // m : 60
        let result : String?
        let me : InGamePlayerData

    }
    
}


struct MatchInfoApi : Codable {

    let match : Match
    
    struct Match : Codable {
        let players : [InGamePlayerData]
        let teams : [TeamStatistics]
    
        struct TeamStatistics : Codable {
            let assists : Int?
            let deaths : Int?
            let dragonKills : Int?
            let gold : Int?
            let isBlue : Bool?
            let kills : Int?
            let outcome : String?
        }
    }
    
    
    
}

struct InGamePlayerData : Codable {
    let championKey : String?
    let championImage : String?
    let summonerName : String?
    let cs : Int?
    let csPerMinute : Double?
    let kda : Double?
    let kills : Int?
    let deaths : Int?
    let assists : Int?
    let killParticipation : Double?
    let lane : String?
    let isWin : Bool?
    let isMvp : Bool?
}

