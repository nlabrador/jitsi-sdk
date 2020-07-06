//
//  StringDataResponse.swift
//  MVVM-C
//
//  Created by michael.p.siapno on 14/09/2019.
//  Copyright © 2019 michael.p.siapno. All rights reserved.
//

import Foundation

public struct StringDataResponse: Codable {
    public let message: String
}

extension StringDataResponse {
    init(_ string: String) {
        message = string
    }
}
