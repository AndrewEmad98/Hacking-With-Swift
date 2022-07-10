//
//  Petition.swift
//  Project7
//
//  Created by Andrew Emad on 07/07/2022.
//

import Foundation

struct Petitions : Codable {
    var results : [Petition]
}
struct Petition : Codable {
    var title : String
    var body : String
    var signatureCount: Int
}

