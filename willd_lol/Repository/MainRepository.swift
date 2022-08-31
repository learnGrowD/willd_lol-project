
import Foundation
import RxSwift


typealias Champion = ChampionListApi.Champion
typealias ChampionRecommend = ChampionRecommendApi.Result
typealias ChampionTier = ChampionTierListApi.Champion
typealias PlayerLank = PlayerMmrRankApi.PlayerInfo

enum HomePageData {
    case summonerSearch
    case championRecommend(_ title : String, _ data : [ChampionRecommend])
    case championTier(_ title : String, _ data : [ChampionTier])
    case championTags(_ title : String)
    case playerLank(_ title : String, _ data : [PlayerLank])
}

enum PlayerCategory : Int {
    case pro = 0
    case popular = 1
    case recommend = 2
}

protocol MainRepositoryProtocal {
    func getChampionListPageData() -> BehaviorSubject<UiState<[Champion]>>
}

class MainRepository {
    static let instance = MainRepository()
    private let apiService : ApiService
    private let disposeBag = DisposeBag()
    private init() {
        apiService = ApiService.instance
    }
    func getHomeRecommendChampionList() -> Observable<[ChampionRecommend]> {
        let recommendResult =
            self.apiService.championRecommend()
            .asObservable()
        
        
        return recommendResult
            .map { result -> [ChampionRecommend] in
                guard case .success(let api) = result else {
                    return []
                }
                return api.results
            }
    }
    
    func getHomeChampionTierList(info : Observable<(tier : RankTier, lane : PlayerLane)>) -> Observable<[ChampionTier]> {
        let tierListResult = info
            .flatMapLatest { [weak self] info in
                self?.apiService.championTierList(
                    tier: info.tier,
                    lane: info.lane,
                    orderby: .topScore,
                    listCount: 5
                )
                ?? .just(.failure(.networkError))
            }
            .share()
        
            
        return tierListResult
            .map { result -> [ChampionTier] in
                guard case .success(let api) = result else {
                    return []
                }
                return api.results
            }
    }
    
    func getPlayerLankList(info : Observable<(category : PlayerCategory, listCount : Int)>) -> Observable<[PlayerLank]> {
        let playerLankResult =
            self.apiService.selectedPlayerMmrRank()
            .asObservable()
        
        return Observable
            .combineLatest(
                info,
                playerLankResult) { info, result -> [PlayerLank] in
                    guard case .success(let api) = result else {
                        return [] //failur....
                    }
                    switch info.category {
                    case .pro:
                        var newValues : [PlayerLank] = []
                        api.pro
                            .enumerated()
                            .forEach { index, value in
                                if index <= info.listCount {
                                    newValues.append(value)
                                }
                            }
                        return newValues
                    case .popular:
                        var newValues : [PlayerLank] = []
                        api.named
                            .enumerated()
                            .forEach { index, value in
                                if index <= info.listCount {
                                    newValues.append(value)
                                }
                            }
                        return newValues
                    case .recommend:
                        var newValues : [PlayerLank] = []
                        api.all
                            .enumerated()
                            .forEach { index, value in
                                if index <= info.listCount {
                                    newValues.append(value)
                                }
                            }
                        return newValues
                    }
                }
    }
    
    
    
    
    
    func getChampionListPageData() -> BehaviorSubject<UiState<[Champion]>> {
        let subject = BehaviorSubject<UiState<[Champion]>>(value: UiState.loading)
        apiService.championList()
            .subscribe(onSuccess : { result in
                switch result {
                case .success(let api):
                    if api.data.isEmpty {
                        subject.onNext(.empty)
                    } else {
                        let sorListtData = api.data.sorted(by: {$0.id! > $1.id!})
                        subject.onNext(.success(sorListtData))
                    }
                case .failure(let error):
                    subject.onNext(.invalid(error.localizedDescription))
                }
            })
            .disposed(by: disposeBag)
        return subject
    }
    
}
