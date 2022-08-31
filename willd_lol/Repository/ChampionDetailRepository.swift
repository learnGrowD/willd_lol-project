//
//  DetailRepository.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/09.
//

import Foundation
import RxSwift
import RxCocoa
import Accessibility

struct ChampionSkinInfo : Codable {
    let championIdentity : String?
    let skinName : String?
    let skinIdentity : Int
}

struct ChampionSkill : Codable {
    let championDataKey : String? // identity key ex) 1, 2, 152 등....
    let key : String?
    let image : String?
    let name : String?
    let description : String?
}

typealias ChampionUserComment = (comment : [ChampionCommentApi.Comment], commentCount : Int)
enum ChampionDetailPageDataModel {
    case skins(_ title : String?, _ data : [ChampionSkinInfo])
    case tags(_ title : String?, _ data : [String])
    case skills(_ title : String?, _ data : [ChampionSkill])
    case lore(_ title : String?, _ data : String)
    case playerLank(_ title : String?, _ data : [ChampionGoodAtPlayerApi.Player])
    case championComment(_ title : String?, _ data : [ChampionCommentApi.Comment])
}

protocol ChampionDetailRepositoryProtocal {
    func getSkins(champion : Champion) -> Observable<[ChampionSkinInfo]>
    func getSkins(championKey : String, championName : String) -> Observable<[ChampionSkinInfo]>
    
    func getTags() -> Observable<[String]>

    func getSkills() -> Observable<[ChampionSkill]>
    
    func getLore() -> Observable<String>
    
    func getPlayerLank(champion : Champion) -> Observable<[ChampionGoodAtPlayerApi.Player]>
    func getPlayerLank(championKey : String) -> Observable<[ChampionGoodAtPlayerApi.Player]>
    
    func getComment(champion : Champion ) -> Observable<[ChampionCommentApi.Comment]>
    func getComment(championKey : String ) -> Observable<[ChampionCommentApi.Comment]>
    
    func getCommentCount(champion : Champion) -> Observable<Int>
    func getCommentCount(championKey : String) -> Observable<Int>
}

struct ChampionDetailRepository : ChampionDetailRepositoryProtocal {
    private let apiService : ApiService = ApiService.instance
    private let disposeBag = DisposeBag()
    private let championDetailResult = BehaviorSubject<ChampionDetailApi?>(value: nil)
    
    
    init(champion : Champion) {
        let _ = apiService.championDetail(championKey: champion.key)
            .map { result -> ChampionDetailApi? in
                guard case .success(let api) = result else {
                    return nil
                }
                return api
            }
            .asObservable()
            .bind(to: championDetailResult)
            .disposed(by: disposeBag)
    }
    
    init(championKey : String) {
        let _ = apiService.championDetail(championKey: championKey)
            .map { result -> ChampionDetailApi? in
                guard case .success(let api) = result else {
                    return nil
                }
                return api
            }
            .asObservable()
            .bind(to: championDetailResult)
            .disposed(by: disposeBag)
    }
    
    func getSkins(champion : Champion) -> Observable<[ChampionSkinInfo]> {
        let skins = self.championDetailResult
            .filter { $0 != nil }
            .map { api -> [ChampionDetailApi.Data.Champion.Skin] in
                guard let api = api else {
                    return []
                }
                return api.data.champion.skins.sorted {
                    $0.num ?? 0 > $1.num ?? 0
                }
            }
        return Observable
            .combineLatest(
                Observable.just(champion),
                skins) { champion, skins in
                    skins.map { skin in
                        if skin.name == "default" {
                            return ChampionSkinInfo(championIdentity : champion.key, skinName : champion.name, skinIdentity : skin.num ?? 0)
                        }else {
                            return ChampionSkinInfo(championIdentity : champion.key, skinName : skin.name, skinIdentity : skin.num ?? 0)
                        }
                    }
                }
    }
    
    func getSkins(championKey : String, championName : String) -> Observable<[ChampionSkinInfo]> {
        let skins = self.championDetailResult
            .filter { $0 != nil }
            .map { api -> [ChampionDetailApi.Data.Champion.Skin] in
                guard let api = api else {
                    return []
                }
                return api.data.champion.skins.sorted {
                    $0.num ?? 0 > $1.num ?? 0
                }
            }
        
        return Observable
            .combineLatest(
                Observable.just(championKey),
                Observable.just(championName),
                skins) { key, name, skins in
                    skins.map { skin -> ChampionSkinInfo in
                        if skin.name == "default" {
                            return ChampionSkinInfo(championIdentity : key, skinName : name, skinIdentity : skin.num ?? 0)
                        }else {
                            return ChampionSkinInfo(championIdentity : key, skinName : skin.name, skinIdentity : skin.num ?? 0)
                        }
                    }
                }
    }
    
    func getTags() -> Observable<[String]>{
        let tags = self.championDetailResult
            .filter { $0 != nil }
            .map { api -> [String] in
                guard let api = api else {
                    return []
                }
                var tags = api.data.champion.tags
                tags.insert(api.data.champion.title ?? "", at: 0)
                return tags
            }
        
        return tags
    }
    
    
    func getSkills() -> Observable<[ChampionSkill]> {
        return championDetailResult
            .filter { $0 != nil }
            .map { api -> [ChampionSkill] in
                guard let api = api else {
                    return []
                }
                let result : [ChampionSkill] = [
                    ChampionSkill(championDataKey : api.data.champion.key ,key: "P", image: api.data.champion.passive.image.full, name: api.data.champion.passive.name, description: api.data.champion.passive.description),
                    ChampionSkill(championDataKey : api.data.champion.key ,key: "Q", image: api.data.champion.spells[0].image.full, name: api.data.champion.spells[0].name, description: api.data.champion.spells[0].description),
                    ChampionSkill(championDataKey : api.data.champion.key ,key: "W", image: api.data.champion.spells[1].image.full, name: api.data.champion.spells[1].name, description: api.data.champion.spells[1].description),
                    ChampionSkill(championDataKey : api.data.champion.key ,key: "E", image: api.data.champion.spells[2].image.full, name: api.data.champion.spells[2].name, description: api.data.champion.spells[2].description),
                    ChampionSkill(championDataKey : api.data.champion.key ,key: "R", image: api.data.champion.spells[3].image.full, name: api.data.champion.spells[3].name, description: api.data.champion.spells[3].description)
                ]
                return result
            }
    }
    
    func getLore() -> Observable<String> {
        return self.championDetailResult
            .filter { $0 != nil }
            .map { api -> String in
                guard let api = api else {
                    return ""
                }
                return api.data.champion.lore ?? ""
            }
    }
    
    func getPlayerLank(champion : Champion) -> Observable<[ChampionGoodAtPlayerApi.Player]> {
        return apiService.championGoodAtPlayerRank(championKey: champion.key)
            .map { result ->  [ChampionGoodAtPlayerApi.Player] in
                guard case .success(let api) = result else {
                    return []
                }
                return api.data
            }
            .asObservable()
    }
    
    func getPlayerLank(championKey : String) -> Observable<[ChampionGoodAtPlayerApi.Player]> {
        return apiService.championGoodAtPlayerRank(championKey: championKey)
            .map { result ->  [ChampionGoodAtPlayerApi.Player] in
                guard case .success(let api) = result else {
                    return []
                }
                return api.data
            }
            .asObservable()
    }
    
    func getComment(champion : Champion) -> Observable<[ChampionCommentApi.Comment]> {
        return apiService.championComment(championKey: champion.key)
            .map { result -> [ChampionCommentApi.Comment] in
                guard case .success(let api) = result else {
                    return []
                }
                return api.data.sorted {
                    $0.vote ?? 0 > $1.vote ?? 0
                }
            }
            .asObservable()
    }
    
    func getComment(championKey : String) -> Observable<[ChampionCommentApi.Comment]> {
        return apiService.championComment(championKey: championKey)
            .map { result -> [ChampionCommentApi.Comment] in
                guard case .success(let api) = result else {
                    return []
                }
                return api.data.sorted {
                    $0.vote ?? 0 > $1.vote ?? 0
                }
            }
            .asObservable()
    }
    
    func getCommentCount(champion : Champion) -> Observable<Int> {
        return apiService.championCommentCount(championKey: champion.key)
            .map { result -> Int in
                guard case .success(let api) = result else {
                    return 0
                }
                return api.data.count ?? 0
            }
            .asObservable()
    }
    
    func getCommentCount(championKey : String) -> Observable<Int> {
        return apiService.championCommentCount(championKey: championKey)
            .map { result -> Int in
                guard case .success(let api) = result else {
                    return 0
                }
                return api.data.count ?? 0
            }
            .asObservable()
    }
    
}


