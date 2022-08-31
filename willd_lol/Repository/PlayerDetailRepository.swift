//
//  PlayerDetailRepository.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/22.
//

import Foundation
import RxCocoa
import RxSwift
import Then


enum PlayerDetailData {
    case summoner(_ title : String, _ data : (summoner : PlayerDetailApi.Summoner, stats : PlayerDetailApi.Summary)?)
    case mostChampionGuide(_ title : String, _ data : PlayerDetailApi.MostChampion?)
    case mostChampion(_ title : String, _ data : [PlayerDetailApi.MostChampion.Item])
    case match(_ title : String, _ data : [PlayerDetailApi.Match])
}



struct PlayerDetailRepository {
    private let disposeBag = DisposeBag()
    private let apiService = ApiService.instance
    private let playerDetailApi = BehaviorSubject<UiState<PlayerDetailApi>>(value: .loading)
    
    func getUiState(playerName : String) -> BehaviorSubject<UiState<PlayerDetailApi>> {
        apiService.playerDetail(playerName: playerName)
             .map { result -> UiState<PlayerDetailApi> in
                 guard case .success(let api) = result else {
                     return .invalid("네트워크 에러가 발생했습니다 : )")
                 }
                 if api.success == false {
                     return .invalid("검색 결과가 없습니다.")
                 } else {
                     return .success(api)
                 }
             }
             .asObservable()
             .bind(to: self.playerDetailApi)
             .disposed(by: disposeBag)
        
        return playerDetailApi
    }

    func getSummoner() -> Observable<(summoner : PlayerDetailApi.Summoner, stats : PlayerDetailApi.Summary)> {
        playerDetailApi
            .filter {
                switch $0 {
                case.invalid( _):
                    return false
                default:
                    return true
                }
            }
            .map { result -> PlayerDetailApi? in
                guard case .success(let api) = result else {
                    return nil
                }
                return api
            }
            .filter { $0 != nil }
            .map {
                ($0!.summoner!, $0!.summary!)
            }
            .asObservable()
    }
    
    func getMostChampion() -> Observable<PlayerDetailApi.MostChampion?> {
        playerDetailApi
            .filter {
                switch $0 {
                case.invalid( _):
                    return false
                default:
                    return true
                }
            }
            .map { result -> PlayerDetailApi? in
                guard case .success(let api) = result else {
                    return nil
                }
                return api
            }
            .filter { $0 != nil }
            .map {
                let isEmpty = $0?.mostChampions?.isEmpty ?? false
                if isEmpty {
                    return PlayerDetailApi.MostChampion.init(items: [], lane: "Mid", matchCount: 0, winRate: 0.0)
                } else {
                    return $0?.mostChampions?[0]
                }
            }
            .asObservable()
    }
    
    func getMostChampionItems() -> Observable<[PlayerDetailApi.MostChampion.Item]> {
        playerDetailApi
            .filter {
                switch $0 {
                case.invalid( _):
                    return false
                default:
                    return true
                }
            }
            .map { result -> PlayerDetailApi? in
                guard case .success(let api) = result else {
                    return nil
                }
                return api
            }
            .filter { $0 != nil }
            .map {
                var result : [PlayerDetailApi.MostChampion.Item] = []
                let isEmpty = $0?.mostChampions?.isEmpty ?? false
                if !isEmpty {
                    $0!.mostChampions?[0].items
                        .enumerated()
                        .forEach { index, item in
                            if index != 0 {
                                result.append(item)
                            }
                        }
                } else {
                    result.append(.init(championImage: "", championKey: "Teemo", matchCount: 0, winRate: 0.0, tier: ""))
                }
                return result
            }
            .asObservable()
    }
    
    func getMatches() -> Observable<[PlayerDetailApi.Match]> {
        playerDetailApi
            .filter {
                switch $0 {
                case.invalid( _):
                    return false
                default:
                    return true
                }
            }
            .map { result -> PlayerDetailApi? in
                guard case .success(let api) = result else {
                    return nil
                }
                return api
            }
            .filter { $0 != nil }
            .map {
                $0!.matches!
            }
            .asObservable()
    }
    
}
