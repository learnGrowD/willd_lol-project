//
//  SkillDetailViewModel.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/21.
//

import Foundation
import RxSwift
import RxCocoa
import Then


struct SkillDetailViewModel {
    let skillImage : Driver<URL?>
    let skillKey : Driver<String>
    let skillName : Driver<String>
    let description : Driver<String>
    let skillVideo : Driver<(dataKey : String, skillKey : String)>
    
    init(skill : ChampionSkill) {
        let skill = Observable.just(skill)
        
        skillImage = skill
            .map {
                if $0.key == "P" {
                    return UrlConverter.convertPassiveImgUrl(passiveIdentity: $0.image ?? "")
                } else {
                    return UrlConverter.convertSpellImgUrl(spellIdentity: $0.image ?? "")
                }
            }
            .asDriver(onErrorDriveWith: .empty())
        
        skillKey = skill
            .map {
                if $0.key == "P" {
                    return "Passive"
                } else {
                    return $0.key ?? ""
                }
            }
            .asDriver(onErrorDriveWith: .empty())
        
        skillName = skill
            .map {
                $0.name ?? ""
            }
            .asDriver(onErrorDriveWith: .empty())
        
        description = skill
            .map {
                $0.description ?? ""
            }
            .asDriver(onErrorDriveWith: .empty())
        
        
        skillVideo = skill
            .map {
                ($0.championDataKey ?? "", $0.key ?? "")
            }
            .asDriver(onErrorDriveWith: .empty())
            
    }
    
}
