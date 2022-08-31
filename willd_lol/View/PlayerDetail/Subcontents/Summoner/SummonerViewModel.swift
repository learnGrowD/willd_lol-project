//
//  SummonerViewModel.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/20.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit




struct SummonerViewModel {
    let disposeBag = DisposeBag()
    let summonerData = BehaviorRelay<(summoner : PlayerDetailApi.Summoner, stats : PlayerDetailApi.Summary)?>(value: nil)
    
    let profileImageUrl : Driver<URL?>
    let playerName : Driver<String>
    let rank  : Driver<String>
    let tier : Driver<String>
    let lp : Driver<String>
    let rate : Driver<String>
    let kda : Driver<String>
    let tierImageUrl : Driver<UIImage?>
    
    init() {        
        profileImageUrl = summonerData
            .filter { $0 != nil }
            .map {
                UrlConverter.convertImgUrl($0?.summoner.profileImage)
            }
            .asDriver(onErrorDriveWith: .empty())
        
        playerName = summonerData
            .filter { $0 != nil }
            .map {
                $0?.summoner.name ?? ""
            }
            .asDriver(onErrorDriveWith: .empty())
        
        rank = Observable.just("솔로랭크")
            .asDriver(onErrorDriveWith: .empty())
        
        tier = summonerData
            .filter { $0 != nil }
            .map {
                $0?.summoner.rank.soloRank
            }
            .map {
                "\($0?.tier ?? "") \($0?.division ?? "1")"
            }
            .asDriver(onErrorDriveWith: .empty())
        
        lp = summonerData
            .filter { $0 != nil }
            .map {
                $0?.summoner.rank.soloRank
            }
            .map {
                "\($0?.lp ?? 0) LP"
            }
            .asDriver(onErrorDriveWith: .empty())
        
        rate = summonerData
            .filter { $0 != nil }
            .map {
                $0?.summoner.rank.soloRank
            }
            .map {
                var total = ($0?.win ?? 0) + ($0?.lose ?? 0)
                if total == 0 {
                    total = 1
                }
                let winRate = ($0?.win ?? 0) * 100 / total
                return "\(winRate)% (\($0?.win ?? 0)승 \($0?.lose ?? 0)패)"
            }
            .asDriver(onErrorDriveWith: .empty())
        
        kda = summonerData
            .filter { $0 != nil }
            .map {
                $0?.stats
            }
            .map {
                "KDA : \($0?.kda ?? 0.0) (\($0?.kills ?? 0.0) / \($0?.deaths ?? 0.0) / \($0?.assists ?? 0.0)"
            }
            .asDriver(onErrorDriveWith: .empty())
        
        tierImageUrl = summonerData
            .filter { $0 != nil }
            .map {
                $0?.summoner.rank.soloRank
            }
            .map {
                $0?.tier ?? ""
            }
            .map {
                switch $0 {
                case "Iron":
                    return UIImage(named: "Emblem_Iron")
                case "Bronze":
                    return UIImage(named: "Emblem_Bronze")
                case "Silver":
                    return UIImage(named: "Emblem_Silver")
                case "Gold":
                    return UIImage(named: "Emblem_Gold")
                case "Platinum":
                    return UIImage(named: "Emblem_Platinum")
                case "Diamond":
                    return UIImage(named: "Emblem_Diamond")
                case "Master":
                    return UIImage(named: "Emblem_Master")
                case "Grandmaster":
                    return UIImage(named: "Emblem_Grandmaster")
                case "Challenger":
                    return UIImage(named: "Emblem_Challenger")
                default:
                    return UIImage(named: "Emblem_Iron")
                }
            }
            .asDriver(onErrorDriveWith: .empty())
            
        
        
        
        
        
        
    }
    

    
}
