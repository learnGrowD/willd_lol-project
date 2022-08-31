//
//  RxExtension.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/11.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Kingfisher
import Then

extension Reactive where Base : UIViewController {
    var translateChampionDetailScreen : Binder<Champion> {
        return Binder(base) { base, data in
            let detailVc = ChampionDetailViewController().then { cotroller in
                let viewModel = ChampionDetailViewModel(champion: data)
                cotroller.hidesBottomBarWhenPushed = true
                cotroller.bind(viewModel)
                cotroller.view.backgroundColor = .willdBlack
                cotroller.title = data.name
            }
            base.show(detailVc, sender: nil)
        }
    }
}

extension Reactive where Base : UIImageView {
    var setImage : Binder<URL?> {
        return Binder(base) { base, data in
            base.kf.setImage(with: data)
        }
    }
}
