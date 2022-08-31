//
//  CommentViewModel.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/13.
//

import Foundation
import RxCocoa
import RxSwift




struct CommentViewModel {
    let disposeBag = DisposeBag()
    let comment = BehaviorRelay<[ChampionCommentApi.Comment]>(value: [])
    
}


