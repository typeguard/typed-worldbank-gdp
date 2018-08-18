//  To parse this JSON data, first install
//
//      Boost     http://www.boost.org
//      json.hpp  https://github.com/nlohmann/json
//
//  Then include this file, and then do
//
//     Gdp data = nlohmann::json::parse(jsonString);

#pragma once

#include <boost/variant.hpp>
#include "json.hpp"

#include <boost/optional.hpp>
#include <stdexcept>
#include <regex>
namespace nlohmann {
    template <typename T>
    struct adl_serializer<std::shared_ptr<T>> {
        static void to_json(json& j, const std::shared_ptr<T>& opt) {
            if (!opt) j = nullptr; else j = *opt;
        }

        static std::shared_ptr<T> from_json(const json& j) {
            if (j.is_null()) return std::unique_ptr<T>(); else return std::unique_ptr<T>(new T(j.get<T>()));
        }
    };
}

namespace quicktype {
    using nlohmann::json;

    inline json get_untyped(const json &j, const char *property) {
        if (j.find(property) != j.end()) {
            return j.at(property).get<json>();
        }
        return json();
    }

    template <typename T>
    inline std::shared_ptr<T> get_optional(const json &j, const char *property) {
        if (j.find(property) != j.end()) {
            return j.at(property).get<std::shared_ptr<T>>();
        }
        return std::shared_ptr<T>();
    }

    enum class Id : int { CN, NY_GDP_MKTP_CD, US };

    enum class Value : int { CHINA, GDP_CURRENT_US, UNITED_STATES };

    class Country {
        public:
        Country() = default;
        virtual ~Country() = default;

        private:
        Id id;
        Value value;

        public:
        const Id & get_id() const { return id; }
        Id & get_mutable_id() { return id; }
        void set_id(const Id& value) { this->id = value; }

        const Value & get_value() const { return value; }
        Value & get_mutable_value() { return value; }
        void set_value(const Value& value) { this->value = value; }
    };

    class PurpleGdp {
        public:
        PurpleGdp() = default;
        virtual ~PurpleGdp() = default;

        private:
        Country indicator;
        Country country;
        std::string value;
        std::string decimal;
        std::string date;

        public:
        const Country & get_indicator() const { return indicator; }
        Country & get_mutable_indicator() { return indicator; }
        void set_indicator(const Country& value) { this->indicator = value; }

        const Country & get_country() const { return country; }
        Country & get_mutable_country() { return country; }
        void set_country(const Country& value) { this->country = value; }

        const std::string & get_value() const { return value; }
        std::string & get_mutable_value() { return value; }
        void set_value(const std::string& value) { this->value = value; }

        const std::string & get_decimal() const { return decimal; }
        std::string & get_mutable_decimal() { return decimal; }
        void set_decimal(const std::string& value) { this->decimal = value; }

        const std::string & get_date() const { return date; }
        std::string & get_mutable_date() { return date; }
        void set_date(const std::string& value) { this->date = value; }
    };

    class FluffyGdp {
        public:
        FluffyGdp() = default;
        virtual ~FluffyGdp() = default;

        private:
        int64_t page;
        int64_t pages;
        std::string per_page;
        int64_t total;

        public:
        const int64_t & get_page() const { return page; }
        int64_t & get_mutable_page() { return page; }
        void set_page(const int64_t& value) { this->page = value; }

        const int64_t & get_pages() const { return pages; }
        int64_t & get_mutable_pages() { return pages; }
        void set_pages(const int64_t& value) { this->pages = value; }

        const std::string & get_per_page() const { return per_page; }
        std::string & get_mutable_per_page() { return per_page; }
        void set_per_page(const std::string& value) { this->per_page = value; }

        const int64_t & get_total() const { return total; }
        int64_t & get_mutable_total() { return total; }
        void set_total(const int64_t& value) { this->total = value; }
    };

    typedef boost::variant<std::vector<PurpleGdp>, FluffyGdp> GdpUnion;

    typedef std::vector<GdpUnion> Gdp;
}

namespace quicktype {
    typedef std::vector<GdpUnion> Gdp;
}

namespace nlohmann {
    inline void from_json(const json& _j, quicktype::Country& _x) {
        _x.set_id( _j.at("id").get<quicktype::Id>() );
        _x.set_value( _j.at("value").get<quicktype::Value>() );
    }

    inline void to_json(json& _j, const quicktype::Country& _x) {
        _j = json::object();
        _j["id"] = _x.get_id();
        _j["value"] = _x.get_value();
    }

    inline void from_json(const json& _j, quicktype::PurpleGdp& _x) {
        _x.set_indicator( _j.at("indicator").get<quicktype::Country>() );
        _x.set_country( _j.at("country").get<quicktype::Country>() );
        _x.set_value( _j.at("value").get<std::string>() );
        _x.set_decimal( _j.at("decimal").get<std::string>() );
        _x.set_date( _j.at("date").get<std::string>() );
    }

    inline void to_json(json& _j, const quicktype::PurpleGdp& _x) {
        _j = json::object();
        _j["indicator"] = _x.get_indicator();
        _j["country"] = _x.get_country();
        _j["value"] = _x.get_value();
        _j["decimal"] = _x.get_decimal();
        _j["date"] = _x.get_date();
    }

    inline void from_json(const json& _j, quicktype::FluffyGdp& _x) {
        _x.set_page( _j.at("page").get<int64_t>() );
        _x.set_pages( _j.at("pages").get<int64_t>() );
        _x.set_per_page( _j.at("per_page").get<std::string>() );
        _x.set_total( _j.at("total").get<int64_t>() );
    }

    inline void to_json(json& _j, const quicktype::FluffyGdp& _x) {
        _j = json::object();
        _j["page"] = _x.get_page();
        _j["pages"] = _x.get_pages();
        _j["per_page"] = _x.get_per_page();
        _j["total"] = _x.get_total();
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
    inline void from_json(const json& _j, boost::variant<std::vector<quicktype::PurpleGdp>, quicktype::FluffyGdp>& _x) {
        if (_j.is_object())
            _x = _j.get<quicktype::FluffyGdp>();
        else if (_j.is_array())
            _x = _j.get<std::vector<quicktype::PurpleGdp>>();
        else throw "Could not deserialize";
    }

    inline void to_json(json& _j, const boost::variant<std::vector<quicktype::PurpleGdp>, quicktype::FluffyGdp>& _x) {
        switch (_x.which()) {
            case 0:
                _j = boost::get<std::vector<quicktype::PurpleGdp>>(_x);
                break;
            case 1:
                _j = boost::get<quicktype::FluffyGdp>(_x);
                break;
            default: throw "Input JSON does not conform to schema";
        }
    }
}
