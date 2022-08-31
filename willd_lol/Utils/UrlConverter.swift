//
//  Converter.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/08.
//

import Foundation


enum ChampionImgType {
    case full
    case middle
    case small
}


struct UrlConverter {
    private static let baseUrl = "https://ddragon.leagueoflegends.com"
    private static let championFullImgPath   = UrlConverter.baseUrl + "/cdn/img/champion/splash/"
    private static let championMiddleImgPath = UrlConverter.baseUrl + "/cdn/img/champion/loading/"
    private static let championSmallImgPath  = UrlConverter.baseUrl + "/cdn/\(Configure.version)/img/champion/"
    private static let passiveImgPath        = UrlConverter.baseUrl + "/cdn/\(Configure.version)/img/passive/"
    private static let spellImgPath          = UrlConverter.baseUrl + "/cdn/\(Configure.version)/img/spell/"
    
    static func convertChampionImgUrl(
        type : ChampionImgType,
        championKey : String?,
        skinIdentity : Int? = nil) -> URL? { // 0은 Default Champion Image...
            switch type {
            case .full:
                return URL(string: championFullImgPath + "\(championKey ?? "")_\(skinIdentity ?? 0).jpg")
            case .middle:
                return URL(string: championMiddleImgPath + "\(championKey ?? "")_\(skinIdentity ?? 0).jpg")
            case .small:
                return URL(string: championSmallImgPath + "\(championKey ?? "").png")
            }
    }
    
    static func convertPassiveImgUrl(passiveIdentity : String?) -> URL? {
        URL(string: passiveImgPath + (passiveIdentity ?? ""))
    }
    
    static func convertSpellImgUrl(spellIdentity : String?) -> URL? {
        URL(string: spellImgPath + (spellIdentity ?? ""))
    }
    
    
    static func convertImgUrl(_ imgPath : String?) -> URL? {
        URL(string: imgPath ?? "")
    }
    
    static func convertVideoURl(championKey : String?, of skillKey : String) -> URL? {
        var championKey = "\(championKey ?? "")"
        (0...3).forEach { _ in
            if championKey.count > 3 {
                return
            }
            championKey = "0" + championKey
        }
        let baseVedioUrl = "https://d28xe8vt774jo5.cloudfront.net/champion-abilities/\(championKey)/ability_\(championKey)_\(skillKey)1.mp4"
        
        return URL(string: baseVedioUrl)
    }
}
