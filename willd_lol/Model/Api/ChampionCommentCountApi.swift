//
//  ChampionCountApi.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/07.
//

import Foundation


struct ChampionCommentCountApi : Codable {
    let data : Data
    
    struct Data : Codable {
        let count : Int?
        
    }

    
}
