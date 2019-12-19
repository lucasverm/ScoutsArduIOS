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

class WinkelwagenItemAantal: Codable {
    var id: Int = 0
    var item: WinkelwagenItem?
    var aantal: Int! = 0
    var short: [String: Any] { return [
        "item": self.item!.short,
        "aantal": String(self.aantal)
        ] }

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case item = "item"
        case aantal = "aantal"
    }

    init() {

    }

    init(id: Int, aantal: Int, item: WinkelwagenItem) {
        self.id = id
        self.aantal = aantal
        self.item = item
    }
}

class WinkelwagenItem: Codable {
    var id: Int = 0
    var naam: String!
    var prijs: Float!
    var short: [String: String] { return ["id": String(self.id)] }
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case naam = "naam"
        case prijs = "prijs"
    }

    init() {

    }

    init(id: Int, naam: String, prijs: Float) {
        self.naam = naam
        self.id = id
        self.prijs = prijs
    }
}

class Winkelwagen: Codable {
    var id: Int = 0
    var items: [WinkelwagenItemAantal] = []
    var betaald: Bool = false
    var datum: Date = Date()
    var gebruiker: Gebruiker?
    var datumDag: Int = 0
    var datumMaand: Int = 0
    var datumJaar: Int = 0
    var datumUur: Int = 0
    var datumMinuten: Int = 0
    var short: [String: Any] {
        var items: [Any] = []
        for item in self.items {
            items.append(item.short)
        }
        var uitvoer: [String: Any] = [:]
        uitvoer["items"] = items
        uitvoer["betaald"] = betaald
        return uitvoer
    }

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case items = "items"
        case gebruiker = "gebruiker"
        case datumDag = "datumDag"
        case datumMaand = "datumMaand"
        case datumJaar = "datumJaar"
        case datumUur = "datumUur"
        case datumMinuten = "datumMinuten"
    }

    func totaalPrijs() -> Float {
        var som: Float = 0
        for item in items {
            som += Float(item.aantal) * item.item!.prijs
        }
        return (som * 1000).rounded() / 1000
    }

    func getFormattedDate() -> String {
        return addAdditionalZero(getal: datumDag) + "/" + addAdditionalZero(getal: datumMaand) + "/" + addAdditionalZero(getal: datumJaar)
    }

    func getFormattedTime() -> String {
        return addAdditionalZero(getal: datumUur) + ":" + addAdditionalZero(getal: datumMinuten)
    }
    
    func addAdditionalZero(getal:Int) -> String {
        var uitvoer:String = String(getal)
        if (uitvoer.count == 1){
            uitvoer = "0" + uitvoer
        }
        return uitvoer
    }

    init() {
    }
}


class Gebruiker: Codable {
    var voornaam: String = ""
    var achternaam: String = ""
    //var foto: String = ""
    var email: String = ""
    var telefoonNummer: String = ""
    //var isFacebookUser: Boolean = false
    // gebruikerType: GebruikerType = GebruikerType.Undefined
    var winkelwagens: [Winkelwagen] = []

    enum CodingKeys: String, CodingKey {
        case voornaam = "voornaam"
        case achternaam = "achternaam"
        //case foto = "foto"
        case email = "email"
        case telefoonNummer = "telNr"
        //case gebruikerType = "type"
        //case isFacebookUser = "
    }

    init() {

    }

    init(voornaam: String, achternaam: String, email: String) {
        self.voornaam = voornaam
        self.achternaam = achternaam
        self.email = email
        //self.foto = foto
        self.winkelwagens = []
    }

}

enum GebruikerType {
    case undefined
    case leiding
    case stam
    case admin
}



