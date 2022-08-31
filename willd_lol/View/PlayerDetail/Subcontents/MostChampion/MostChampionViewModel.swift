//
//  MostChampionViewModel.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/22.
//

import Foundation
import RxCocoa
import RxSwift

class MostChampionViewModel {
    let disposeBag = DisposeBag()
    
    let mostChampionData = BehaviorRelay<[PlayerDetailApi.MostChampion.Item]>(value: [])
    
    var championImageUrl : Driver<URL?>?
    var championName : Driver<String>?
    var winRate : Driver<String>?

    func bind(index : IndexPath) {
        
        let mostChampion = mostChampionData
            .map {
                $0[index.row]
            }
        
        championImageUrl = mostChampion
            .map {
                UrlConverter.convertChampionImgUrl(type: .small, championKey: $0.championKey ?? "")
            }
            .asDriver(onErrorDriveWith: .empty())
        
        championName = mostChampion
            .map {
                $0.championKey ?? ""
            }
            .asDriver(onErrorDriveWith: .empty())
        
        
        winRate = mostChampion
            .map {
                "승률 \(Int($0.winRate!))% (\($0.matchCount ?? 0)경기)"
            }
            .asDriver(onErrorDriveWith: .empty())
        
    }
}
