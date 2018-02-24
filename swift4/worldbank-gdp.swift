// To parse the JSON, add this file to your project and do:
//
//   let gdp = try Gdp(json)

import Foundation

typealias Gdp = [GDPUnion]

enum GDPUnion: Codable {
    case fluffyGDP(FluffyGDP)
    case purpleGDPArray([PurpleGDP])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(FluffyGDP.self) {
            self = .fluffyGDP(x)
            return
        }
        if let x = try? container.decode([PurpleGDP].self) {
            self = .purpleGDPArray(x)
            return
        }
        throw DecodingError.typeMismatch(GDPUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for GDPUnion"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .fluffyGDP(let x):
            try container.encode(x)
        case .purpleGDPArray(let x):
            try container.encode(x)
        }
    }
}

struct PurpleGDP: Codable {
    let indicator, country: Country
    let value: String?
    let decimal: Decimal
    let date: String
}

struct Country: Codable {
    let id: ID
    let value: Value
}

enum ID: String, Codable {
    case cn = "CN"
    case nyGdpMktpCD = "NY.GDP.MKTP.CD"
    case us = "US"
}

enum Value: String, Codable {
    case china = "China"
    case gdpCurrentUS = "GDP (current US$)"
    case unitedStates = "United States"
}

enum Decimal: String, Codable {
    case the0 = "0"
}

struct FluffyGDP: Codable {
    let page, pages: Int
    let perPage: String
    let total: Int

    enum CodingKeys: String, CodingKey {
        case page, pages
        case perPage = "per_page"
        case total
    }
}

// MARK: Convenience initializers

extension PurpleGDP {
    init(data: Data) throws {
        self = try JSONDecoder().decode(PurpleGDP.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Country {
    init(data: Data) throws {
        self = try JSONDecoder().decode(Country.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension FluffyGDP {
    init(data: Data) throws {
        self = try JSONDecoder().decode(FluffyGDP.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Array where Element == Gdp.Element {
    init(data: Data) throws {
        self = try JSONDecoder().decode(Gdp.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
