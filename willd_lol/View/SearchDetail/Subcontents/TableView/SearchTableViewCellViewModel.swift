//
//  SearchListViewCellViewModel.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/24.
//

import Foundation
import RxCocoa
import RxSwift



class SearchTableViewCellViewModel  {
    let searchListData = BehaviorRelay<[SearchPreview]>(value: [])
    
    var profileImageUrl : Driver<URL?>?
    var summonerName : Driver<String>?
    var summonerTier : Driver<String>?
    
    func bind(index : IndexPath) {
    
        let cellData = searchListData
            .map { [index] data -> SearchPreview in
                print("\(index.row)***************************************************************************************************")
                return data[index.row]
            }
        
        profileImageUrl = cellData
            .map {
                UrlConverter.convertImgUrl($0.imageUrl)
            }
            .asDriver(onErrorDriveWith: .empty())

        summonerName = cellData
            .map {
                $0.name ?? ""
            }
            .asDriver(onErrorDriveWith: .empty())

        summonerTier = cellData
            .map {
                "\($0.tier ?? "")\($0.division ?? "") (\($0.lp ?? 0))"
            }
            .asDriver(onErrorDriveWith: .empty())
        
    }
}
