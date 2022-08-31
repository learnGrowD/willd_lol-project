//
//  SearchBarViewModel.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/24.
//

import Foundation
import RxCocoa
import RxSwift



struct SearchBarViewModel {
    let query = PublishRelay<String?>()
    let tap = PublishRelay<Void>()
    let shouldLoadResult : Observable<String>

    
    init() {
        self.shouldLoadResult = tap
            .withLatestFrom(query) { $1 ?? ""}
            .filter { !$0.isEmpty }
        
    }
}
