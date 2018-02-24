// To parse this data:
//
//   import { Convert } from "./file";
//
//   const gdp = Convert.toGdp(json);
//
// These functions will throw an error if the JSON doesn't
// match the expected interface, even if the JSON is valid.

export interface GDPElement {
    indicator: Country;
    country:   Country;
    value?:    string;
    decimal:   Decimal;
    date:      string;
}

export interface Country {
    id:    ID;
    value: Value;
}

export enum ID {
    CN = "CN",
    NyGdpMktpCD = "NY.GDP.MKTP.CD",
    Us = "US",
}

export enum Value {
    China = "China",
    GDPCurrentUS = "GDP (current US$)",
    UnitedStates = "United States",
}

export enum Decimal {
    The0 = "0",
}

export interface Gdp1 {
    page:     number;
    pages:    number;
    per_page: string;
    total:    number;
}

// Converts JSON strings to/from your types
// and asserts the results of JSON.parse at runtime
export module Convert {
    export function toGdp(json: string): Array<GDPElement[] | Gdp1> {
        return cast(JSON.parse(json), a(u(a(o("GDPElement")), o("Gdp1"))));
    }

    export function gdpToJson(value: Array<GDPElement[] | Gdp1>): string {
        return JSON.stringify(value, null, 2);
    }
    
    function cast<T>(obj: any, typ: any): T {
        if (!isValid(typ, obj)) {
            throw `Invalid value`;
        }
        return obj;
    }

    function isValid(typ: any, val: any): boolean {
        if (typ === undefined) return true;
        if (typ === null) return val === null || val === undefined;
        return typ.isUnion  ? isValidUnion(typ.typs, val)
                : typ.isArray  ? isValidArray(typ.typ, val)
                : typ.isMap    ? isValidMap(typ.typ, val)
                : typ.isEnum   ? isValidEnum(typ.name, val)
                : typ.isObject ? isValidObject(typ.cls, val)
                :                isValidPrimitive(typ, val);
    }

    function isValidPrimitive(typ: string, val: any) {
        return typeof typ === typeof val;
    }

    function isValidUnion(typs: any[], val: any): boolean {
        // val must validate against one typ in typs
        return typs.find(typ => isValid(typ, val)) !== undefined;
    }

    function isValidEnum(enumName: string, val: any): boolean {
        const cases = typeMap[enumName];
        return cases.indexOf(val) !== -1;
    }

    function isValidArray(typ: any, val: any): boolean {
        // val must be an array with no invalid elements
        return Array.isArray(val) && val.every(element => {
            return isValid(typ, element);
        });
    }

    function isValidMap(typ: any, val: any): boolean {
        if (val === null || typeof val !== "object" || Array.isArray(val)) return false;
        // all values in the map must be typ
        return Object.keys(val).every(prop => {
            if (!Object.prototype.hasOwnProperty.call(val, prop)) return true;
            return isValid(typ, val[prop]);
        });
    }

    function isValidObject(className: string, val: any): boolean {
        if (val === null || typeof val !== "object" || Array.isArray(val)) return false;
        let typeRep = typeMap[className];
        return Object.keys(typeRep).every(prop => {
            if (!Object.prototype.hasOwnProperty.call(typeRep, prop)) return true;
            return isValid(typeRep[prop], val[prop]);
        });
    }

    function a(typ: any) {
        return { typ, isArray: true };
    }

    function e(name: string) {
        return { name, isEnum: true };
    }

    function u(...typs: any[]) {
        return { typs, isUnion: true };
    }

    function m(typ: any) {
        return { typ, isMap: true };
    }

    function o(className: string) {
        return { cls: className, isObject: true };
    }

    const typeMap: any = {
        "GDPElement": {
            indicator: o("Country"),
            country: o("Country"),
            value: u(null, ""),
            decimal: e("Decimal"),
            date: "",
        },
        "Country": {
            id: e("ID"),
            value: e("Value"),
        },
        "Gdp1": {
            page: 0,
            pages: 0,
            per_page: "",
            total: 0,
        },
        "ID": [
            "CN",
            "NY.GDP.MKTP.CD",
            "US",
        ],
        "Value": [
            "China",
            "GDP (current US$)",
            "United States",
        ],
        "Decimal": [
            "0",
        ],
    };
}
