// To parse this JSON data, do
//
//     final gdp = gdpFromJson(jsonString);

import 'dart:convert';

List<dynamic> gdpFromJson(String str) {
    final jsonData = json.decode(str);
    return new List<dynamic>.from(jsonData.map((x) => x));
}

String gdpToJson(List<dynamic> data) {
    final dyn = new List<dynamic>.from(data.map((x) => x));
    return json.encode(dyn);
}

class GdpElement {
    Country indicator;
    Country country;
    String value;
    String decimal;
    String date;

    GdpElement({
        this.indicator,
        this.country,
        this.value,
        this.decimal,
        this.date,
    });

    factory GdpElement.fromJson(Map<String, dynamic> json) => new GdpElement(
        indicator: Country.fromJson(json["indicator"]),
        country: Country.fromJson(json["country"]),
        value: json["value"],
        decimal: json["decimal"],
        date: json["date"],
    );

    Map<String, dynamic> toJson() => {
        "indicator": indicator.toJson(),
        "country": country.toJson(),
        "value": value,
        "decimal": decimal,
        "date": date,
    };
}

class Country {
    Id id;
    Value value;

    Country({
        this.id,
        this.value,
    });

    factory Country.fromJson(Map<String, dynamic> json) => new Country(
        id: idValues.map[json["id"]],
        value: valueValues.map[json["value"]],
    );

    Map<String, dynamic> toJson() => {
        "id": idValues.reverse[id],
        "value": valueValues.reverse[value],
    };
}

enum Id { CN, US, NY_GDP_MKTP_CD }

final idValues = new EnumValues({
    "CN": Id.CN,
    "NY.GDP.MKTP.CD": Id.NY_GDP_MKTP_CD,
    "US": Id.US
});

enum Value { CHINA, UNITED_STATES, GDP_CURRENT_US }

final valueValues = new EnumValues({
    "China": Value.CHINA,
    "GDP (current US\u0024)": Value.GDP_CURRENT_US,
    "United States": Value.UNITED_STATES
});

class PurpleGdp {
    int page;
    int pages;
    String perPage;
    int total;

    PurpleGdp({
        this.page,
        this.pages,
        this.perPage,
        this.total,
    });

    factory PurpleGdp.fromJson(Map<String, dynamic> json) => new PurpleGdp(
        page: json["page"],
        pages: json["pages"],
        perPage: json["per_page"],
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "page": page,
        "pages": pages,
        "per_page": perPage,
        "total": total,
    };
}

class EnumValues<T> {
    Map<String, T> map;
    Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        if (reverseMap == null) {
            reverseMap = map.map((k, v) => new MapEntry(v, k));
        }
        return reverseMap;
    }
}
