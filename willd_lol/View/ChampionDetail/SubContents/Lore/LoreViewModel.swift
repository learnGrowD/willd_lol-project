//
//  LoreViewModel.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/13.
//

import Foundation
import RxCocoa
import RxSwift


struct LoreViewModel {
    let disposeBag = DisposeBag()
    let lore = BehaviorRelay<String>(value: "")
    

}
