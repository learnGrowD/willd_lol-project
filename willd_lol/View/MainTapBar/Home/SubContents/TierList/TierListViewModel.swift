//
//  TierViewModel.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/17.
//

import Foundation
import RxCocoa
import RxSwift



struct TierListViewModel {
    let disposeBag = DisposeBag()
    let info = BehaviorRelay<(tier : RankTier, lane : PlayerLane)>(value: (.etc, .mid))
    let tierList = BehaviorRelay<[ChampionTier]>(value: [])
    
    init(_ mainRepository : MainRepository = MainRepository.instance) {
        
        mainRepository.getHomeChampionTierList(info: info.asObservable())
            .bind(to: tierList)
            .disposed(by: disposeBag)
        
    }
}
