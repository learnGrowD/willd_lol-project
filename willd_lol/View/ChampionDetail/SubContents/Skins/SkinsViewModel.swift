//
//  SkinViewModel.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/13.
//

import Foundation
import RxSwift
import RxCocoa


struct SkinsViewModel {
    let disPoseBag = DisposeBag()
    let skins = BehaviorRelay<[ChampionSkinInfo]>(value: [])
}

