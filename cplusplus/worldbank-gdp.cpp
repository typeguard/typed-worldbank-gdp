//  To parse this JSON data, first install
// 
//      Boost     http://www.boost.org
//      json.hpp  https://github.com/nlohmann/json
// 
//  Then include this file, and then do
// 
//     Gdp data = nlohmann::json::parse(jsonString);

#include <boost/variant.hpp>
#include "json.hpp"

namespace quicktype {
    using nlohmann::json;

    enum class Id { CN, NY_GDP_MKTP_CD, US };

    enum class Value { CHINA, GDP_CURRENT_US, UNITED_STATES };

    struct Country {
        Id id;
        Value value;
    };

    enum class Decimal { THE_0 };

    struct PurpleGDP {
        struct Country indicator;
        struct Country country;
        std::unique_ptr<std::string> value;
        Decimal decimal;
        std::string date;
    };

    struct FluffyGDP {
        int64_t page;
        int64_t pages;
        std::string per_page;
        int64_t total;
    };

    typedef boost::variant<struct FluffyGDP, std::vector<struct PurpleGDP>> GdpUnion;

    typedef std::vector<GdpUnion> Gdp;
    
    inline json get_untyped(const json &j, const char *property) {
        if (j.find(property) != j.end()) {
            return j.at(property).get<json>();
        }
        return json();
    }
    
    template <typename T>
    inline std::unique_ptr<T> get_optional(const json &j, const char *property) {
        if (j.find(property) != j.end())
            return j.at(property).get<std::unique_ptr<T>>();
        return std::unique_ptr<T>();
    }
}

namespace nlohmann {
    template <typename T>
    struct adl_serializer<std::unique_ptr<T>> {
        static void to_json(json& j, const std::unique_ptr<T>& opt) {
            if (!opt)
                j = nullptr;
            else
                j = *opt;
        }

        static std::unique_ptr<T> from_json(const json& j) {
            if (j.is_null())
                return std::unique_ptr<T>();
            else
                return std::unique_ptr<T>(new T(j.get<T>()));
        }
    };

    inline void from_json(const json& _j, struct quicktype::Country& _x) {
        _x.id = _j.at("id").get<quicktype::Id>();
        _x.value = _j.at("value").get<quicktype::Value>();
    }

    inline void to_json(json& _j, const struct quicktype::Country& _x) {
        _j = json::object();
        _j["id"] = _x.id;
        _j["value"] = _x.value;
    }

    inline void from_json(const json& _j, struct quicktype::PurpleGDP& _x) {
        _x.indicator = _j.at("indicator").get<struct quicktype::Country>();
        _x.country = _j.at("country").get<struct quicktype::Country>();
        _x.value = quicktype::get_optional<std::string>(_j, "value");
        _x.decimal = _j.at("decimal").get<quicktype::Decimal>();
        _x.date = _j.at("date").get<std::string>();
    }

    inline void to_json(json& _j, const struct quicktype::PurpleGDP& _x) {
        _j = json::object();
        _j["indicator"] = _x.indicator;
        _j["country"] = _x.country;
        _j["value"] = _x.value;
        _j["decimal"] = _x.decimal;
        _j["date"] = _x.date;
    }

    inline void from_json(const json& _j, struct quicktype::FluffyGDP& _x) {
        _x.page = _j.at("page").get<int64_t>();
        _x.pages = _j.at("pages").get<int64_t>();
        _x.per_page = _j.at("per_page").get<std::string>();
        _x.total = _j.at("total").get<int64_t>();
    }

    inline void to_json(json& _j, const struct quicktype::FluffyGDP& _x) {
        _j = json::object();
        _j["page"] = _x.page;
        _j["pages"] = _x.pages;
        _j["per_page"] = _x.per_page;
        _j["total"] = _x.total;
    }

    inline void from_json(const json& _j, quicktype::Id& _x) {
        if (_j == "CN") _x = quicktype::Id::CN;
        else if (_j == "NY.GDP.MKTP.CD") _x = quicktype::Id::NY_GDP_MKTP_CD;
        else if (_j == "US") _x = quicktype::Id::US;
        else throw "Input JSON does not conform to schema";
    }

    inline void to_json(json& _j, const quicktype::Id& _x) {
        switch (_x) {
            case quicktype::Id::CN: _j = "CN"; break;
            case quicktype::Id::NY_GDP_MKTP_CD: _j = "NY.GDP.MKTP.CD"; break;
            case quicktype::Id::US: _j = "US"; break;
            default: throw "This should not happen";
        }
    }

    inline void from_json(const json& _j, quicktype::Value& _x) {
        if (_j == "China") _x = quicktype::Value::CHINA;
        else if (_j == "GDP (current US$)") _x = quicktype::Value::GDP_CURRENT_US;
        else if (_j == "United States") _x = quicktype::Value::UNITED_STATES;
        else throw "Input JSON does not conform to schema";
    }

    inline void to_json(json& _j, const quicktype::Value& _x) {
        switch (_x) {
            case quicktype::Value::CHINA: _j = "China"; break;
            case quicktype::Value::GDP_CURRENT_US: _j = "GDP (current US$)"; break;
            case quicktype::Value::UNITED_STATES: _j = "United States"; break;
            default: throw "This should not happen";
        }
    }

    inline void from_json(const json& _j, quicktype::Decimal& _x) {
        if (_j == "0") _x = quicktype::Decimal::THE_0;
        else throw "Input JSON does not conform to schema";
    }

    inline void to_json(json& _j, const quicktype::Decimal& _x) {
        switch (_x) {
            case quicktype::Decimal::THE_0: _j = "0"; break;
            default: throw "This should not happen";
        }
    }

    inline void from_json(const json& _j, boost::variant<struct quicktype::FluffyGDP, std::vector<struct quicktype::PurpleGDP>>& _x) {
        if (_j.is_object())
            _x = _j.get<struct quicktype::FluffyGDP>();
        else if (_j.is_array())
            _x = _j.get<std::vector<struct quicktype::PurpleGDP>>();
        else throw "Could not deserialize";
    }

    inline void to_json(json& _j, const boost::variant<struct quicktype::FluffyGDP, std::vector<struct quicktype::PurpleGDP>>& _x) {
        switch (_x.which()) {
            case 0:
                _j = boost::get<struct quicktype::FluffyGDP>(_x);
                break;
            case 1:
                _j = boost::get<std::vector<struct quicktype::PurpleGDP>>(_x);
                break;
            default: throw "Input JSON does not conform to schema";
        }
    }
}
