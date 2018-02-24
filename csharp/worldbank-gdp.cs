// To parse this JSON data, add NuGet 'Newtonsoft.Json' then do:
//
//    using QuickType;
//
//    var gdp = Gdp.FromJson(jsonString);

namespace QuickType
{
    using System;
    using System.Collections.Generic;
    using System.Net;

    using System.Globalization;
    using Newtonsoft.Json;
    using Newtonsoft.Json.Converters;

    public partial class GdpElement
    {
        [JsonProperty("indicator")]
        public Country Indicator { get; set; }

        [JsonProperty("country")]
        public Country Country { get; set; }

        [JsonProperty("value")]
        public string Value { get; set; }

        [JsonProperty("decimal")]
        public Decimal Decimal { get; set; }

        [JsonProperty("date")]
        public string Date { get; set; }
    }

    public partial class Country
    {
        [JsonProperty("id")]
        public Id Id { get; set; }

        [JsonProperty("value")]
        public Value Value { get; set; }
    }

    public partial class PurpleGdp
    {
        [JsonProperty("page")]
        public long Page { get; set; }

        [JsonProperty("pages")]
        public long Pages { get; set; }

        [JsonProperty("per_page")]
        public string PerPage { get; set; }

        [JsonProperty("total")]
        public long Total { get; set; }
    }

    public enum Id { Cn, NyGdpMktpCd, Us };

    public enum Value { China, GdpCurrentUs, UnitedStates };

    public enum Decimal { The0 };

    public partial struct Gdp
    {
        public GdpElement[] GdpElementArray;
        public PurpleGdp PurpleGdp;
    }

    public partial struct Gdp
    {
        public static Gdp[] FromJson(string json) => JsonConvert.DeserializeObject<Gdp[]>(json, QuickType.Converter.Settings);
    }

    static class IdExtensions
    {
        public static Id? ValueForString(string str)
        {
            switch (str)
            {
                case "CN": return Id.Cn;
                case "NY.GDP.MKTP.CD": return Id.NyGdpMktpCd;
                case "US": return Id.Us;
                default: return null;
            }
        }

        public static Id ReadJson(JsonReader reader, JsonSerializer serializer)
        {
            var str = serializer.Deserialize<string>(reader);
            var maybeValue = ValueForString(str);
            if (maybeValue.HasValue) return maybeValue.Value;
            throw new Exception("Unknown enum case " + str);
        }

        public static void WriteJson(this Id value, JsonWriter writer, JsonSerializer serializer)
        {
            switch (value)
            {
                case Id.Cn: serializer.Serialize(writer, "CN"); break;
                case Id.NyGdpMktpCd: serializer.Serialize(writer, "NY.GDP.MKTP.CD"); break;
                case Id.Us: serializer.Serialize(writer, "US"); break;
            }
        }
    }

    static class ValueExtensions
    {
        public static Value? ValueForString(string str)
        {
            switch (str)
            {
                case "China": return Value.China;
                case "GDP (current US$)": return Value.GdpCurrentUs;
                case "United States": return Value.UnitedStates;
                default: return null;
            }
        }

        public static Value ReadJson(JsonReader reader, JsonSerializer serializer)
        {
            var str = serializer.Deserialize<string>(reader);
            var maybeValue = ValueForString(str);
            if (maybeValue.HasValue) return maybeValue.Value;
            throw new Exception("Unknown enum case " + str);
        }

        public static void WriteJson(this Value value, JsonWriter writer, JsonSerializer serializer)
        {
            switch (value)
            {
                case Value.China: serializer.Serialize(writer, "China"); break;
                case Value.GdpCurrentUs: serializer.Serialize(writer, "GDP (current US$)"); break;
                case Value.UnitedStates: serializer.Serialize(writer, "United States"); break;
            }
        }
    }

    static class DecimalExtensions
    {
        public static Decimal? ValueForString(string str)
        {
            switch (str)
            {
                case "0": return Decimal.The0;
                default: return null;
            }
        }

        public static Decimal ReadJson(JsonReader reader, JsonSerializer serializer)
        {
            var str = serializer.Deserialize<string>(reader);
            var maybeValue = ValueForString(str);
            if (maybeValue.HasValue) return maybeValue.Value;
            throw new Exception("Unknown enum case " + str);
        }

        public static void WriteJson(this Decimal value, JsonWriter writer, JsonSerializer serializer)
        {
            switch (value)
            {
                case Decimal.The0: serializer.Serialize(writer, "0"); break;
            }
        }
    }

    public partial struct Gdp
    {
        public Gdp(JsonReader reader, JsonSerializer serializer)
        {
            GdpElementArray = null;
            PurpleGdp = null;

            switch (reader.TokenType)
            {
                case JsonToken.StartArray:
                    GdpElementArray = serializer.Deserialize<GdpElement[]>(reader);
                    return;
                case JsonToken.StartObject:
                    PurpleGdp = serializer.Deserialize<PurpleGdp>(reader);
                    return;
            }
            throw new Exception("Cannot convert Gdp");
        }

        public void WriteJson(JsonWriter writer, JsonSerializer serializer)
        {
            if (GdpElementArray != null)
            {
                serializer.Serialize(writer, GdpElementArray);
                return;
            }
            if (PurpleGdp != null)
            {
                serializer.Serialize(writer, PurpleGdp);
                return;
            }
            throw new Exception("Union must not be null");
        }
    }

    public static class Serialize
    {
        public static string ToJson(this Gdp[] self) => JsonConvert.SerializeObject(self, QuickType.Converter.Settings);
    }

    internal class Converter: JsonConverter
    {
        public override bool CanConvert(Type t) => t == typeof(Id) || t == typeof(Value) || t == typeof(Decimal) || t == typeof(Gdp) || t == typeof(Id?) || t == typeof(Value?) || t == typeof(Decimal?);

        public override object ReadJson(JsonReader reader, Type t, object existingValue, JsonSerializer serializer)
        {
            if (t == typeof(Id))
                return IdExtensions.ReadJson(reader, serializer);
            if (t == typeof(Value))
                return ValueExtensions.ReadJson(reader, serializer);
            if (t == typeof(Decimal))
                return DecimalExtensions.ReadJson(reader, serializer);
            if (t == typeof(Id?))
            {
                if (reader.TokenType == JsonToken.Null) return null;
                return IdExtensions.ReadJson(reader, serializer);
            }
            if (t == typeof(Value?))
            {
                if (reader.TokenType == JsonToken.Null) return null;
                return ValueExtensions.ReadJson(reader, serializer);
            }
            if (t == typeof(Decimal?))
            {
                if (reader.TokenType == JsonToken.Null) return null;
                return DecimalExtensions.ReadJson(reader, serializer);
            }
            if (t == typeof(Gdp))
                return new Gdp(reader, serializer);
            throw new Exception("Unknown type");
        }

        public override void WriteJson(JsonWriter writer, object value, JsonSerializer serializer)
        {
            var t = value.GetType();
            if (t == typeof(Id))
            {
                ((Id)value).WriteJson(writer, serializer);
                return;
            }
            if (t == typeof(Value))
            {
                ((Value)value).WriteJson(writer, serializer);
                return;
            }
            if (t == typeof(Decimal))
            {
                ((Decimal)value).WriteJson(writer, serializer);
                return;
            }
            if (t == typeof(Gdp))
            {
                ((Gdp)value).WriteJson(writer, serializer);
                return;
            }
            throw new Exception("Unknown type");
        }

        public static readonly JsonSerializerSettings Settings = new JsonSerializerSettings
        {
            MetadataPropertyHandling = MetadataPropertyHandling.Ignore,
            DateParseHandling = DateParseHandling.None,
            Converters = { 
                new Converter(),
                new IsoDateTimeConverter()
                {
                    DateTimeStyles = DateTimeStyles.AssumeUniversal,
                },
            },
        };
    }
}
