//
//  HomeViewModel.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/10.
//

import Foundation
import RxCocoa
import RxSwift



struct HomeViewModel {
    let disposeBag = DisposeBag()
    
    let searchViewModel = SearchCollectionViewModel()
    let recommendViewModel = RecommendViewModel()
    let tierTagsViewModel = TierTagViewModel()
    let tierListViewModel = TierListViewModel()
    let playerLankViewModel = PlayerLankViewModel()
    let homeData : Driver<[HomePageData]>

    init(_ mainRepository : MainRepository = MainRepository.instance) {
        
        self.tierTagsViewModel.info
            .asObservable()
            .bind(to: tierListViewModel.info)
            .disposed(by: disposeBag)
            
        
        
        self.homeData = Observable
            .zip(
                recommendViewModel.championRecommendList.asObservable(),
                tierListViewModel.tierList.asObservable(),
                playerLankViewModel.playerRankList.asObservable()) { recommendList, tierList, playerLankList -> [HomePageData] in
                    let result : [HomePageData] = [
                        .summonerSearch,
                        .championRecommend("Recommend", recommendList),
                        .championTags("ChampionTier"),
                        .championTier("ChampionTier", tierList),
                        .playerLank("PalyerRank", playerLankList)
                    ]
                    if recommendList.isEmpty || tierList.isEmpty || playerLankList.isEmpty {
                        return []
                    } else {
                        return result
                    }
                    
                }
                .asDriver(onErrorDriveWith: .empty())
        
    }
    
}
