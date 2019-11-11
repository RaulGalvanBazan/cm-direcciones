//
//  model.swift
//  cm-direcciones
//
//  Created by user160539 on 11/10/19.
//  Copyright © 2019 UltraCode. All rights reserved.
//

import UIKit

struct Resultado: Codable {
    var results: [Localidad]
}

struct Localidad: Codable{
    var title: String
    var subtitle : String
    var lat: Double
    var long: Double
}
