//
//  ApiService.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/06.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

enum NetworkError : Error {
    case networkError
}


class ApiService {
    static let instance = ApiService()
    private init() {}
    private static let scheme = "https://"
    private static let riotHost = "ddragon.leagueoflegends.com"
    private static let riotPath = "/cdn/\(Configure.version)/data/ko_KR/"
    
    private static let opGgHost = "www.op.gg"
    private static let opGgPath = "/api/"
    
    private static let yourGgHost = "api.your.gg"
    private static let youtGgPath = "/kr/api/"
    
    private static let psHost = "lol.ps/"
    
    
    func championDetail(championKey : String?) -> Single<Result<ChampionDetailApi, NetworkError>> {
        Observable.just(
            ApiService.scheme
            + ApiService.riotHost
            + ApiService.riotPath
            + "champion/\(championKey ?? "").json"
        )
        .flatMap { url -> Observable<Data> in
            AF.request(
                url,
                method: .get,
                parameters: nil,
                encoding: URLEncoding.default,
                headers: ["Content-Type":"application/json"]
            )
            .rx.data()
        }
        .map { data -> String in
            return String(decoding: data, as: UTF8.self)
        }
        .map { oldJsondStr -> String in
            oldJsondStr.replacingOccurrences(of: "\"\(championKey ?? "")\":{", with: "\"champion\":{")
        }
        .map { newJsonStr -> Data? in
            newJsonStr.data(using: .utf8)
        }
        .map { newData in
            let api = try JSONDecoder().decode(ChampionDetailApi.self, from: newData ?? Data())
            return .success(api)
        }
        .catch { _ in
            return .just(.failure(.networkError))
        }
        .asSingle()
    }
    
    func championList() -> Single<Result<ChampionListApi, NetworkError>> {
        Observable.just(
            ApiService.scheme
            + ApiService.opGgHost
            + ApiService.opGgPath
            + "meta/champions"
        )
        .flatMap { url -> Observable<Data> in
            let params = [
                "hl" : "ko_KR"
            ]
            return AF.request(
                url,
                method: .get,
                parameters: params,
                encoding: URLEncoding.default,
                headers: ["Content-Type":"application/json"]
            )
            .rx.data()
        }
        .map { data in
            
            let api = try JSONDecoder().decode(ChampionListApi.self, from: data)
            return .success(api)
        }
        .catch { _ in
            .just(.failure(.networkError))
        }
        .asSingle()
    }
    
    
    func championCommentCount(championKey : String?) -> Single<Result<ChampionCommentCountApi, NetworkError>> {
        Observable.just(
            ApiService.scheme
            + ApiService.opGgHost
            + ApiService.opGgPath
            + "champions/\(championKey ?? "")/comments/count"
        )
        .flatMap { url -> Observable<Data> in
            AF.request(
                url,
                method: .get,
                parameters: nil,
                encoding: URLEncoding.default,
                headers: ["Content-Type":"application/json"]
            )
            .rx.data()
        }
        .map { data in
            let api = try JSONDecoder().decode(ChampionCommentCountApi.self, from: data)
            return .success(api)
        }
        .catch { _ in
            .just(.failure(.networkError))
        }
        .asSingle()
    }
    
    func championComment(
        championKey : String?,
        sort : ChampionComment = .popular,
        page : Int = 1,
        listCount : Int = 5) -> Single<Result<ChampionCommentApi, NetworkError>> {
            Observable.just(
                ApiService.scheme
                + ApiService.opGgHost
                + ApiService.opGgPath
                + "champions/\(championKey ?? "")/comments"
            )
            .flatMap { url -> Observable<Data> in
                let params = [
                    "sort" : sort.rawValue,
                    "page" : "\(page)",
                    "limit" : "\(listCount)",
                    "is_latest_version" : "\(false)"
                ]
                return AF.request(
                    url,
                    method: .get,
                    parameters: params,
                    encoding: URLEncoding.default,
                    headers: ["Content-Type":"application/json"]
                )
                .rx.data()
            }
            .map { data in
                let api = try JSONDecoder().decode(ChampionCommentApi.self, from: data)
                return .success(api)
            }
            .catch { _ in
                .just(.failure(.networkError))
            }
            .asSingle()
    }
    
    func championGoodAtPlayerRank(
        championKey : String?,
        limit : Int = 5) -> Single<Result<ChampionGoodAtPlayerApi, NetworkError>> {
            
            Observable.just(
                ApiService.scheme
                + ApiService.opGgHost
                + ApiService.opGgPath
                + "rankings/champions/\(championKey ?? "")"
            )
            .flatMap { url -> Observable<Data> in
                let params = [
                    "region" : "kr",
                    "limit" : "\(limit)"
                ]
                return AF.request(
                    url,
                    method: .get,
                    parameters: params,
                    encoding: URLEncoding.default,
                    headers: ["Content-Type":"application/json"]
                )
                .rx.data()
            }
            .map { data in
                let api = try JSONDecoder().decode(ChampionGoodAtPlayerApi.self, from: data)
                return .success(api)
            }
            .catch { e in
                print(e.localizedDescription)
                return .just(.failure(.networkError))
            }
            .asSingle()

    }
    
    func selectedPlayerMmrRank() -> Single<Result<PlayerMmrRankApi, NetworkError>> {
        Observable.just(
            ApiService.scheme
            + ApiService.yourGgHost
            + ApiService.youtGgPath
            + "named-summoners/ranking"
        )
        .flatMap { url -> Observable<Data> in
            let params = [
                "lang" : "ko",
            ]
            return AF.request(
                url,
                method: .get,
                parameters: params,
                encoding: URLEncoding.default,
                headers: ["Content-Type":"application/json"]
            )
            .rx.data()
        }
        .map { data in
            let api = try JSONDecoder().decode(PlayerMmrRankApi.self, from: data)
            return .success(api)
        }
        .catch { e in
            print(e.localizedDescription)
            return .just(.failure(.networkError))
        }
        .asSingle()
    }
    
    func playerDetail(playerName : String) -> Single<Result<PlayerDetailApi, NetworkError>> {
        Observable.just(
            ApiService.scheme
            + ApiService.yourGgHost
            + ApiService.youtGgPath
            + "profile/\(playerName)"
        )
        .map {
            $0.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        }
        .flatMap { url -> Observable<Data> in
            let params = [
                "lang" : "ko",
                "matchCategory" : "SoloRank",
                "listMatchCategory" : ""
            ]
            return AF.request(
                url ?? "",
                method: .get,
                parameters: params,
                encoding: URLEncoding.default,
                headers: ["Content-Type":"application/json"]
            )
            .rx.data()
        }
        .map { data in
            let api = try JSONDecoder().decode(PlayerDetailApi.self, from: data)
            return .success(api)
        }
        .catch { _ in
            return .just(.failure(.networkError))
        }
        .asSingle()
    }
    
    
    
    func matchInfo(matchIdentity : Int) -> Single<Result<MatchInfoApi, NetworkError>> {
        Observable.just(
            ApiService.scheme
            + ApiService.yourGgHost
            + ApiService.youtGgPath
            + "match/\(matchIdentity)"
        )
        .flatMap { url -> Observable<Data> in
            let params = [
                "lang" : "ko"
            ]
            return AF.request(
                url,
                method: .get,
                parameters: params,
                encoding: URLEncoding.default,
                headers: ["Content-Type":"application/json"]
            )
            .rx.data()
        }
        .map { data in
            let api = try JSONDecoder().decode(MatchInfoApi.self, from: data)
            return .success(api)
        }
        .catch { _ in
            return .just(.failure(.networkError))
        }
        .asSingle()
        
    }
    
    func playerSearchPreview(searchQuery : String) -> Single<Result<[SearchPreview], NetworkError>> {
        Observable.just(
            ApiService.scheme
            + ApiService.yourGgHost
            + ApiService.youtGgPath
            + "search/summoners"
        )
        .flatMap { url -> Observable<Data> in
            let params = [
                "lang" : "ko",
                "q" : searchQuery
            ]
            return AF.request(
                url,
                method: .get,
                parameters: params,
                encoding: URLEncoding.default,
                headers: ["Content-Type":"application/json"]
            )
            .rx.data()
        }
        .map { data in
            let api = try JSONDecoder().decode([SearchPreview].self, from: data)
            return .success(api)
        }
        .catch { _ in
            return .just(.failure(.networkError))
        }
        .asSingle()
    }
    
    func championRecommend() -> Single<Result<ChampionRecommendApi, NetworkError>> {
        Observable.just(
            ApiService.scheme
            + ApiService.psHost
            + "index_champ"
            
        )
        .flatMap { url -> Observable<Data> in
            return AF.request(
                url,
                method: .get,
                parameters: nil,
                encoding: URLEncoding.default,
                headers: ["Content-Type":"application/json"]
            )
            .rx.data()
        }
        .map { data in
            let api = try JSONDecoder().decode(ChampionRecommendApi.self, from: data)
            return .success(api)
        }
        .catch { e in
            print(e.localizedDescription)
            return .just(.failure(.networkError))
        }
        .asSingle()
    }
    
    func championTierList(
        tier : RankTier = .etc,
        lane : PlayerLane = .top,
        orderby : ChampionTierOrderBy = .topScore,
        listCount : Int = 10) -> Single<Result<ChampionTierListApi, NetworkError>> {
            Observable.just(
                ApiService.scheme
                + ApiService.psHost
                + "lol/get_lane_champion_tier_list"
            )
            .flatMap { url -> Observable<Data> in
                let params = [
                    "tier" : "\(tier.rawValue)",
                    "lane" : "\(lane.rawValue)",
                    "order_by" : orderby.rawValue,
                    "region" : "0",
                    "count" : "\(listCount)"
                ]
                return AF.request(
                    url,
                    method: .get,
                    parameters: params,
                    encoding: URLEncoding.default,
                    headers: ["Content-Type":"application/json"]
                )
                .rx.data()
            }
            .map { data in
                let api = try JSONDecoder().decode(ChampionTierListApi.self, from: data)
                return .success(api)
            }
            .catch { e in
                print(e.localizedDescription)
                return .just(.failure(.networkError))
            }
            .asSingle()
        }

}

enum PlayerLane : Int {
    case top = 0
    case jungle = 1
    case mid = 2
    case bottom = 3
    case supporter = 4
}

enum ChampionComment : String {
    case popular = "popular"
    case recent = "recent"
}

enum RankTier : Int {
    case etc = 1 // 브, 실, 골
    case platinum = 2
    case diamond = 13
    case master = 3
}

enum ChampionTierOrderBy : String {
    case topScore = "-op_score"
    case rowScore = "op_score"
    case topWinRate = "-win_rate"
    case rowWinRate = "win_rate"
    case topPickRate = "-pick_rate"
    case rowPickRate = "pick_rate"
    case topBanRate = "-ban_rate"
    case rowBanRate = "ban_rate"
    
}
