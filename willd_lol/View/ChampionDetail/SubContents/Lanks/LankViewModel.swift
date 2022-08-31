//
//  LankViewModel.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/13.
//

import Foundation
import RxCocoa
import RxSwift


struct LankViewModel {
    let disposeBag = DisposeBag()
    let lank = BehaviorRelay<[ChampionGoodAtPlayerApi.Player]>(value: [])
    

}

