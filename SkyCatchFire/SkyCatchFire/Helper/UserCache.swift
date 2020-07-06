//
//  UserCache.swift
//  MyChevroletConnect
//
//  Created by Raymond Barrinuevo on 26/11/2019.
//  Copyright © 2019 michael.p.siapno. All rights reserved.
//

import Foundation
import RxSwift

final class UserCache {
    static let shared = UserCache()
    private init() {
    }
    var userName = ""
    let theme: Themable = AppTheme.none

}
