# To use this code, make sure you
#
#     import json
#
# and then, to convert JSON from a string, do
#
#     result = gdp_from_dict(json.loads(json_string))

from enum import Enum
from typing import Any, List, Union, TypeVar, Type, cast, Callable


T = TypeVar("T")
EnumT = TypeVar("EnumT", bound=Enum)


def to_enum(c: Type[EnumT], x: Any) -> EnumT:
    assert isinstance(x, c)
    return x.value


def from_str(x: Any) -> str:
    assert isinstance(x, str)
    return x


def to_class(c: Type[T], x: Any) -> dict:
    assert isinstance(x, c)
    return cast(Any, x).to_dict()


def from_int(x: Any) -> int:
    assert isinstance(x, int) and not isinstance(x, bool)
    return x


def from_list(f: Callable[[Any], T], x: Any) -> List[T]:
    assert isinstance(x, list)
    return [f(y) for y in x]


def from_union(fs, x):
    for f in fs:
        try:
            return f(x)
        except:
            pass
    assert False


class ID(Enum):
    CN = "CN"
    NY_GDP_MKTP_CD = "NY.GDP.MKTP.CD"
    US = "US"


class Value(Enum):
    CHINA = "China"
    GDP_CURRENT_US = "GDP (current US$)"
    UNITED_STATES = "United States"


class Country:
    id: ID
    value: Value

    def __init__(self, id: ID, value: Value) -> None:
        self.id = id
        self.value = value

    @staticmethod
    def from_dict(obj: Any) -> 'Country':
        assert isinstance(obj, dict)
        id = ID(obj.get("id"))
        value = Value(obj.get("value"))
        return Country(id, value)

    def to_dict(self) -> dict:
        result: dict = {}
        result["id"] = to_enum(ID, self.id)
        result["value"] = to_enum(Value, self.value)
        return result


class PurpleGDP:
    indicator: Country
    country: Country
    value: str
    decimal: int
    date: int

    def __init__(self, indicator: Country, country: Country, value: str, decimal: int, date: int) -> None:
        self.indicator = indicator
        self.country = country
        self.value = value
        self.decimal = decimal
        self.date = date

    @staticmethod
    def from_dict(obj: Any) -> 'PurpleGDP':
        assert isinstance(obj, dict)
        indicator = Country.from_dict(obj.get("indicator"))
        country = Country.from_dict(obj.get("country"))
        value = from_str(obj.get("value"))
        decimal = int(from_str(obj.get("decimal")))
        date = int(from_str(obj.get("date")))
        return PurpleGDP(indicator, country, value, decimal, date)

    def to_dict(self) -> dict:
        result: dict = {}
        result["indicator"] = to_class(Country, self.indicator)
        result["country"] = to_class(Country, self.country)
        result["value"] = from_str(self.value)
        result["decimal"] = from_str(str(self.decimal))
        result["date"] = from_str(str(self.date))
        return result


class FluffyGDP:
    page: int
    pages: int
    per_page: int
    total: int

    def __init__(self, page: int, pages: int, per_page: int, total: int) -> None:
        self.page = page
        self.pages = pages
        self.per_page = per_page
        self.total = total

    @staticmethod
    def from_dict(obj: Any) -> 'FluffyGDP':
        assert isinstance(obj, dict)
        page = from_int(obj.get("page"))
        pages = from_int(obj.get("pages"))
        per_page = int(from_str(obj.get("per_page")))
        total = from_int(obj.get("total"))
        return FluffyGDP(page, pages, per_page, total)

    def to_dict(self) -> dict:
        result: dict = {}
        result["page"] = from_int(self.page)
        result["pages"] = from_int(self.pages)
        result["per_page"] = from_str(str(self.per_page))
        result["total"] = from_int(self.total)
        return result


def gdp_from_dict(s: Any) -> List[Union[List[PurpleGDP], FluffyGDP]]:
    return from_list(lambda x: from_union([FluffyGDP.from_dict, lambda x: from_list(PurpleGDP.from_dict, x)], x), s)


def gdp_to_dict(x: List[Union[List[PurpleGDP], FluffyGDP]]) -> Any:
    return from_list(lambda x: from_union([lambda x: to_class(FluffyGDP, x), lambda x: from_list(lambda x: to_class(PurpleGDP, x), x)], x), x)
