//
//  SearchViewModel.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/24.
//

import Foundation
import RxCocoa
import RxSwift


class SearchDetailViewModel {
    let disposeBag = DisposeBag()
    let repository = SearchRepository()
    
    let searchBarViewModel = SearchBarViewModel()
    let searchTableViewCellViewModel = SearchTableViewCellViewModel()

    var uiState : Driver<UiState<[SearchPreview]>>?
    
    func bind() {
        
        
        self.uiState = searchBarViewModel.query
            .flatMap { [weak self] query in
                self?.repository.getUistate(searchQuery: query ?? "") ?? .empty()
            }
            .asDriver(onErrorDriveWith: .empty())
        
        
        
        searchBarViewModel.query
            .flatMap { [weak self] query in
                self?.repository.getSearchPreview(query: query ?? "") ?? .empty()
            }
            .bind(to: searchTableViewCellViewModel.searchListData)
            .disposed(by: disposeBag)
        
            
    }

    
}
