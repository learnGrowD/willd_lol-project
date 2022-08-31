//
//  TierTagViewModel.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/18.
//

import Foundation
import RxCocoa
import RxSwift




struct TierTagViewModel {
    let disposeBag = DisposeBag()
    
    let tier : Driver<RankTier>
    let playerLane : Driver<PlayerLane>
    let info : Driver<(tier : RankTier, lane : PlayerLane)>
    
    init() {
        let tierValue : RankTier = [
            RankTier.etc,
            RankTier.platinum,
            RankTier.diamond,
            RankTier.master
        ].randomElement() ?? .etc
        
        
        self.tier = Observable<RankTier>.just(tierValue)
            .asDriver(onErrorDriveWith: .empty())
        
        let playerLaneValue : PlayerLane = [
            PlayerLane.top,
            PlayerLane.jungle,
            PlayerLane.mid,
            PlayerLane.bottom,
            PlayerLane.supporter
        ].randomElement() ?? .mid
            
    
        self.playerLane = Observable<PlayerLane>.just(playerLaneValue)
            .asDriver(onErrorDriveWith: .empty())
        
        
        self.info = Observable
            .combineLatest(
                tier.asObservable(),
                playerLane.asObservable()) {
                    (tier : $0, lane : $1)
                }
                .asDriver(onErrorDriveWith: .empty())
    }
}
