//
//  Petition.swift
//  WhitehousePetition
//
//  Created by Andrei Korikov on 21.10.2021.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
