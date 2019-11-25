//
//  File.swift
//  ScoutsArduIOS
//
//  Created by Lucas Vermeulen on 07/11/2019.
//  Copyright © 2019 Lucas Vermeulen. All rights reserved.
//
import Foundation

struct MenuItem {
    var label: String
    var afbeelding: String
    var type: MenuEnum
}

enum MenuEnum {
    case enenDrinken
    case portefeuille
    case history
}

class WinkelwagenItem: Codable {
    var id: Int = 0
    var naam: String!
    var prijs: Float!
    var aantal: Int! = 0
    var short: [String: String] { return ["id": String(self.id), "aantal": String(self.aantal)] }

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case naam = "naam"
        case prijs = "prijs"
        case aantal = "aantal"
    }

    init() {

    }

    init(id: Int, naam: String, prijs: Float, aantal: Int) {
        self.naam = naam
        self.id = id
        self.prijs = prijs
        self.aantal = aantal

    }
}

class Winkelwagen: Codable {
    var id: Int = 0
    var items: [WinkelwagenItem] = []
    var betaald: Bool = false
    var datum: Date = Date()
    var gebruiker: Gebruiker?
    var short: [String: Any] {
        var items: [Any] = []
        for item in self.items {
            items.append(item.short)
        }
        var uitvoer: [String: Any] = [:]
        uitvoer["items"] = items
        uitvoer["betaald"] = betaald
        //uitvoer["datum"] = String(self.datum.timeIntervalSince1970)
        return uitvoer
    }

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case items = "items"
        case gebruiker = "gebruiker"
        //case datum = "datum"
    }

    func totaalPrijs() -> Float {
        var som: Float = 0
        for item in items {
            som += Float(item.aantal) * item.prijs
        }
        return (som * 1000).rounded() / 1000
    }

    func getFormattedDate() -> String {
        let datumFormatter = DateFormatter()
        datumFormatter.dateFormat = "dd/MM/yyyy"
        return datumFormatter.string(from: datum)
    }

    func getFormattedTime() -> String {
        let datumFormatter = DateFormatter()
        datumFormatter.dateFormat = "HH:mm"
        return datumFormatter.string(from: datum)
    }

    func getFormattedTimeWithSeconds() -> String {
        let datumFormatter = DateFormatter()
        datumFormatter.dateFormat = "HH:mm:ss"
        return datumFormatter.string(from: datum)
    }


    init() {
    }
}

class Gebruiker: Codable {
    var voornaam: String = ""
    var achternaam: String = ""
    var foto: String = ""
    var email: String = ""
    var telefoonNummer: String = ""
    // gebruikerType: GebruikerType = GebruikerType.Undefined
    var winkelwagens: [Winkelwagen] = []

    enum CodingKeys: String, CodingKey {
        case voornaam = "voornaam"
        case achternaam = "achternaam"
        case foto = "foto"
        case email = "email"
        case telefoonNummer = "telNr"
        //case gebruikerType = "type"
    }

    init() {

    }

    init(voornaam: String, achternaam: String, email: String, foto: String) {
        self.voornaam = voornaam
        self.achternaam = achternaam
        self.email = email
        self.foto = foto
        self.winkelwagens = []
    }

}

enum GebruikerType {
    case undefined
    case leiding
    case stam
    case admin
}
