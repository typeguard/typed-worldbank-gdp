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
    value:     string;
    decimal:   string;
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

export interface PurpleGDP {
    page:     number;
    pages:    number;
    per_page: string;
    total:    number;
}

// Converts JSON strings to/from your types
// and asserts the results of JSON.parse at runtime
export namespace Convert {
    export function toGdp(json: string): Array<GDPElement[] | PurpleGDP> {
        return cast(JSON.parse(json), a(u(a(r("GDPElement")), r("PurpleGDP"))));
    }

    export function gdpToJson(value: Array<GDPElement[] | PurpleGDP>): string {
        return JSON.stringify(uncast(value, a(u(a(r("GDPElement")), r("PurpleGDP")))), null, 2);
    }

    function invalidValue(typ: any, val: any): never {
        throw Error(`Invalid value ${JSON.stringify(val)} for type ${JSON.stringify(typ)}`);
    }

    function jsonToJSProps(typ: any): any {
        if (typ.jsonToJS === undefined) {
            var map: any = {};
            typ.props.forEach((p: any) => map[p.json] = { key: p.js, typ: p.typ });
            typ.jsonToJS = map;
        }
        return typ.jsonToJS;
    }

    function jsToJSONProps(typ: any): any {
        if (typ.jsToJSON === undefined) {
            var map: any = {};
            typ.props.forEach((p: any) => map[p.js] = { key: p.json, typ: p.typ });
            typ.jsToJSON = map;
        }
        return typ.jsToJSON;
    }

    function transform(val: any, typ: any, getProps: any): any {
        function transformPrimitive(typ: string, val: any): any {
            if (typeof typ === typeof val) return val;
            return invalidValue(typ, val);
        }

        function transformUnion(typs: any[], val: any): any {
            // val must validate against one typ in typs
            var l = typs.length;
            for (var i = 0; i < l; i++) {
                var typ = typs[i];
                try {
                    return transform(val, typ, getProps);
                } catch (_) {}
            }
            return invalidValue(typs, val);
        }

        function transformEnum(cases: string[], val: any): any {
            if (cases.indexOf(val) !== -1) return val;
            return invalidValue(cases, val);
        }

        function transformArray(typ: any, val: any): any {
            // val must be an array with no invalid elements
            if (!Array.isArray(val)) return invalidValue("array", val);
            return val.map(el => transform(el, typ, getProps));
        }

        function transformObject(props: { [k: string]: any }, additional: any, val: any): any {
            if (val === null || typeof val !== "object" || Array.isArray(val)) {
                return invalidValue("object", val);
            }
            var result: any = {};
            Object.getOwnPropertyNames(props).forEach(key => {
                const prop = props[key];
                const v = Object.prototype.hasOwnProperty.call(val, key) ? val[key] : undefined;
                result[prop.key] = transform(v, prop.typ, getProps);
            });
            Object.getOwnPropertyNames(val).forEach(key => {
                if (!Object.prototype.hasOwnProperty.call(props, key)) {
                    result[key] = transform(val[key], additional, getProps);
                }
            });
            return result;
        }

        if (typ === "any") return val;
        if (typ === null) {
            if (val === null) return val;
            return invalidValue(typ, val);
        }
        if (typ === false) return invalidValue(typ, val);
        while (typeof typ === "object" && typ.ref !== undefined) {
            typ = typeMap[typ.ref];
        }
        if (Array.isArray(typ)) return transformEnum(typ, val);
        if (typeof typ === "object") {
            return typ.hasOwnProperty("unionMembers") ? transformUnion(typ.unionMembers, val)
                : typ.hasOwnProperty("arrayItems")    ? transformArray(typ.arrayItems, val)
                : typ.hasOwnProperty("props")         ? transformObject(getProps(typ), typ.additional, val)
                : invalidValue(typ, val);
        }
        return transformPrimitive(typ, val);
    }

    function cast<T>(val: any, typ: any): T {
        return transform(val, typ, jsonToJSProps);
    }

    function uncast<T>(val: T, typ: any): any {
        return transform(val, typ, jsToJSONProps);
    }

    function a(typ: any) {
        return { arrayItems: typ };
    }

    function u(...typs: any[]) {
        return { unionMembers: typs };
    }

    function o(props: any[], additional: any) {
        return { props, additional };
    }

    function m(additional: any) {
        return { props: [], additional };
    }

    function r(name: string) {
        return { ref: name };
    }

    const typeMap: any = {
        "GDPElement": o([
            { json: "indicator", js: "indicator", typ: r("Country") },
            { json: "country", js: "country", typ: r("Country") },
            { json: "value", js: "value", typ: "" },
            { json: "decimal", js: "decimal", typ: "" },
            { json: "date", js: "date", typ: "" },
        ], false),
        "Country": o([
            { json: "id", js: "id", typ: r("ID") },
            { json: "value", js: "value", typ: r("Value") },
        ], false),
        "PurpleGDP": o([
            { json: "page", js: "page", typ: 0 },
            { json: "pages", js: "pages", typ: 0 },
            { json: "per_page", js: "per_page", typ: "" },
            { json: "total", js: "total", typ: 0 },
        ], false),
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
    };
}
