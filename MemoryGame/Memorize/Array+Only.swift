//
//  Array+Only.swift
//  Memorize
//
//  Created by Muhammad Aqib on 18/11/2020.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
