//
//  PlayerRankViewModel.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/17.
//


import Foundation
import RxCocoa
import RxSwift



struct PlayerLankViewModel {
    let disposeBag = DisposeBag()
    let playerRankList = BehaviorRelay<[PlayerLank]>(value: [])
    
    init(_ mainRepository : MainRepository = MainRepository.instance) {
        let category = Observable<PlayerCategory>.just(.recommend)
        let listCount = Observable.just(5)
        let info = Observable
            .combineLatest(
                category,
                listCount) {
                    (category : $0, listCount : $1)
                }
        
        mainRepository.getPlayerLankList(info: info)
            .bind(to: playerRankList)
            .disposed(by: disposeBag)
    }
}
