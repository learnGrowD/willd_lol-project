//
//  SearchRepository.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/24.
//

import Foundation
import RxCocoa
import RxSwift

struct SearchRepository {
    private let disposeBag = DisposeBag()
    private let apiService = ApiService.instance
    
    func getUistate(searchQuery : String) -> Observable<UiState<[SearchPreview]>> {
        apiService.playerSearchPreview(searchQuery: searchQuery)
            .map { result -> UiState<[SearchPreview]> in
                guard case .success(let api) = result else {
                    return .invalid("네트워크에 문제가 발생했습니다 : )")
                }
                return .success(api)
                
            }
            .asObservable()
            .startWith(.loading)
    }
    
    
    func getSearchPreview(query : String) -> Observable<[SearchPreview]> {
        getUistate(searchQuery: query)
            .filter {
                switch $0 {
                case .success( _):
                    return true
                default:
                    return false
                }
            }
            .map { result -> [SearchPreview] in
                guard case .success(let data) = result else {
                    return []
                }
                return data
            }
    }
    
}
