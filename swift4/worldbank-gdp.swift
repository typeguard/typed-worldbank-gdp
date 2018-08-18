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
        if let x = try? container.decode([PurpleGDP].self) {
            self = .purpleGDPArray(x)
            return
        }
        if let x = try? container.decode(FluffyGDP.self) {
            self = .fluffyGDP(x)
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
    let value, decimal, date: String
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

// MARK: Convenience initializers and mutators

extension PurpleGDP {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PurpleGDP.self, from: data)
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

    func with(
        indicator: Country? = nil,
        country: Country? = nil,
        value: String? = nil,
        decimal: String? = nil,
        date: String? = nil
    ) -> PurpleGDP {
        return PurpleGDP(
            indicator: indicator ?? self.indicator,
            country: country ?? self.country,
            value: value ?? self.value,
            decimal: decimal ?? self.decimal,
            date: date ?? self.date
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Country {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Country.self, from: data)
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

    func with(
        id: ID? = nil,
        value: Value? = nil
    ) -> Country {
        return Country(
            id: id ?? self.id,
            value: value ?? self.value
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension FluffyGDP {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(FluffyGDP.self, from: data)
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

    func with(
        page: Int? = nil,
        pages: Int? = nil,
        perPage: String? = nil,
        total: Int? = nil
    ) -> FluffyGDP {
        return FluffyGDP(
            page: page ?? self.page,
            pages: pages ?? self.pages,
            perPage: perPage ?? self.perPage,
            total: total ?? self.total
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Array where Element == Gdp.Element {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Gdp.self, from: data)
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
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
