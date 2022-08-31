//
//  UiState.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/07.
//

import Foundation

enum UiState<T> {
    case success(_ data : T)
    case invalid(_ msg : String)
    case loading
    case empty
}
