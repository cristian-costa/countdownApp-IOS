//
//  File.swift
//  CountdownApp
//
//  Created by Cristian Costa on 21/09/2021.
//

import UIKit
import RealmSwift

class Evento: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var date: Date?
}
