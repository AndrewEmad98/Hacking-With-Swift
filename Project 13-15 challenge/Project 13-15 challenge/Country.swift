//
//  Country.swift
//  Project 13-15 challenge
//
//  Created by Andrew Emad on 19/07/2022.
//

import Foundation


struct Country : Codable{
    var name : String
    var capital : String
    var region : String
    var population : Int
    var currencies : [Currencies]
    var languages : [Languages]
    
}

struct Currencies : Codable {
    var name : String
}

struct Languages : Codable {
    var name : String
}

