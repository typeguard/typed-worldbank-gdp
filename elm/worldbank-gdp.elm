-- To decode the JSON data, add this file to your project, run
--
--     elm-package install NoRedInk/elm-decode-pipeline
--
-- add these imports
--
--     import Json.Decode exposing (decodeString)`);
--     import QuickType exposing (gdp)
--
-- and you're off to the races with
--
--     decodeString gdp myJsonString

module QuickType exposing
    ( Gdp
    , gdpToString
    , gdp
    , PurpleGDP
    , Country
    , FluffyGDP
    , ID(..)
    , Value(..)
    , GDPUnion(..)
    )

import Json.Decode as Jdec
import Json.Decode.Pipeline as Jpipe
import Json.Encode as Jenc
import Dict exposing (Dict, map, toList)
import Array exposing (Array, map)

type alias Gdp = Array GDPUnion

type GDPUnion
    = FluffyGDPInGDPUnion FluffyGDP
    | PurpleGDPArrayInGDPUnion (Array PurpleGDP)

type alias PurpleGDP =
    { indicator : Country
    , country : Country
    , value : String
    , decimal : String
    , date : String
    }

type alias Country =
    { id : ID
    , value : Value
    }

type ID
    = CN
    | NyGdpMktpCD
    | Us

type Value
    = China
    | GDPCurrentUS
    | UnitedStates

type alias FluffyGDP =
    { page : Int
    , pages : Int
    , perPage : String
    , total : Int
    }

-- decoders and encoders

gdp : Jdec.Decoder Gdp
gdp = Jdec.array gdpUnion

gdpToString : Gdp -> String
gdpToString r = Jenc.encode 0 (makeArrayEncoder encodeGDPUnion r)

gdpUnion : Jdec.Decoder GDPUnion
gdpUnion =
    Jdec.oneOf
        [ Jdec.map PurpleGDPArrayInGDPUnion (Jdec.array purpleGDP)
        , Jdec.map FluffyGDPInGDPUnion fluffyGDP
        ]

encodeGDPUnion : GDPUnion -> Jenc.Value
encodeGDPUnion x = case x of
    PurpleGDPArrayInGDPUnion y -> makeArrayEncoder encodePurpleGDP y
    FluffyGDPInGDPUnion y -> encodeFluffyGDP y

purpleGDP : Jdec.Decoder PurpleGDP
purpleGDP =
    Jpipe.decode PurpleGDP
        |> Jpipe.required "indicator" country
        |> Jpipe.required "country" country
        |> Jpipe.required "value" Jdec.string
        |> Jpipe.required "decimal" Jdec.string
        |> Jpipe.required "date" Jdec.string

encodePurpleGDP : PurpleGDP -> Jenc.Value
encodePurpleGDP x =
    Jenc.object
        [ ("indicator", encodeCountry x.indicator)
        , ("country", encodeCountry x.country)
        , ("value", Jenc.string x.value)
        , ("decimal", Jenc.string x.decimal)
        , ("date", Jenc.string x.date)
        ]

country : Jdec.Decoder Country
country =
    Jpipe.decode Country
        |> Jpipe.required "id" id
        |> Jpipe.required "value" value

encodeCountry : Country -> Jenc.Value
encodeCountry x =
    Jenc.object
        [ ("id", encodeID x.id)
        , ("value", encodeValue x.value)
        ]

id : Jdec.Decoder ID
id =
    Jdec.string
        |> Jdec.andThen (\str ->
            case str of
                "CN" -> Jdec.succeed CN
                "NY.GDP.MKTP.CD" -> Jdec.succeed NyGdpMktpCD
                "US" -> Jdec.succeed Us
                somethingElse -> Jdec.fail <| "Invalid ID: " ++ somethingElse
        )

encodeID : ID -> Jenc.Value
encodeID x = case x of
    CN -> Jenc.string "CN"
    NyGdpMktpCD -> Jenc.string "NY.GDP.MKTP.CD"
    Us -> Jenc.string "US"

value : Jdec.Decoder Value
value =
    Jdec.string
        |> Jdec.andThen (\str ->
            case str of
                "China" -> Jdec.succeed China
                "GDP (current US$)" -> Jdec.succeed GDPCurrentUS
                "United States" -> Jdec.succeed UnitedStates
                somethingElse -> Jdec.fail <| "Invalid Value: " ++ somethingElse
        )

encodeValue : Value -> Jenc.Value
encodeValue x = case x of
    China -> Jenc.string "China"
    GDPCurrentUS -> Jenc.string "GDP (current US$)"
    UnitedStates -> Jenc.string "United States"

fluffyGDP : Jdec.Decoder FluffyGDP
fluffyGDP =
    Jpipe.decode FluffyGDP
        |> Jpipe.required "page" Jdec.int
        |> Jpipe.required "pages" Jdec.int
        |> Jpipe.required "per_page" Jdec.string
        |> Jpipe.required "total" Jdec.int

encodeFluffyGDP : FluffyGDP -> Jenc.Value
encodeFluffyGDP x =
    Jenc.object
        [ ("page", Jenc.int x.page)
        , ("pages", Jenc.int x.pages)
        , ("per_page", Jenc.string x.perPage)
        , ("total", Jenc.int x.total)
        ]

--- encoder helpers

makeArrayEncoder : (a -> Jenc.Value) -> Array a -> Jenc.Value
makeArrayEncoder f arr =
    Jenc.array (Array.map f arr)

makeDictEncoder : (a -> Jenc.Value) -> Dict String a -> Jenc.Value
makeDictEncoder f dict =
    Jenc.object (toList (Dict.map (\k -> f) dict))

makeNullableEncoder : (a -> Jenc.Value) -> Maybe a -> Jenc.Value
makeNullableEncoder f m =
    case m of
    Just x -> f x
    Nothing -> Jenc.null
