// To parse this JSON data, add NuGet 'Newtonsoft.Json' then do:
//
//    using QuickType;
//
//    var gdp = Gdp.FromJson(jsonString);

namespace QuickType
{
    using System;
    using System.Collections.Generic;

    using System.Globalization;
    using Newtonsoft.Json;
    using Newtonsoft.Json.Converters;

    public partial class PurpleGdp
    {
        [JsonProperty("indicator")]
        public Country Indicator { get; set; }

        [JsonProperty("country")]
        public Country Country { get; set; }

        [JsonProperty("value")]
        public string Value { get; set; }

        [JsonProperty("decimal")]
        [JsonConverter(typeof(ParseStringConverter))]
        public long Decimal { get; set; }

        [JsonProperty("date")]
        [JsonConverter(typeof(ParseStringConverter))]
        public long Date { get; set; }
    }

    public partial class Country
    {
        [JsonProperty("id")]
        public Id Id { get; set; }

        [JsonProperty("value")]
        public Value Value { get; set; }
    }

    public partial class FluffyGdp
    {
        [JsonProperty("page")]
        public long Page { get; set; }

        [JsonProperty("pages")]
        public long Pages { get; set; }

        [JsonProperty("per_page")]
        [JsonConverter(typeof(ParseStringConverter))]
        public long PerPage { get; set; }

        [JsonProperty("total")]
        public long Total { get; set; }
    }

    public enum Id { Cn, NyGdpMktpCd, Us };

    public enum Value { China, GdpCurrentUs, UnitedStates };

    public partial struct GdpUnion
    {
        public FluffyGdp FluffyGdp;
        public PurpleGdp[] PurpleGdpArray;

        public static implicit operator GdpUnion(FluffyGdp FluffyGdp) => new GdpUnion { FluffyGdp = FluffyGdp };
        public static implicit operator GdpUnion(PurpleGdp[] PurpleGdpArray) => new GdpUnion { PurpleGdpArray = PurpleGdpArray };
    }

    public class Gdp
    {
        public static GdpUnion[] FromJson(string json) => JsonConvert.DeserializeObject<GdpUnion[]>(json, QuickType.Converter.Settings);
    }

    public static class Serialize
    {
        public static string ToJson(this GdpUnion[] self) => JsonConvert.SerializeObject(self, QuickType.Converter.Settings);
    }

    internal static class Converter
    {
        public static readonly JsonSerializerSettings Settings = new JsonSerializerSettings
        {
            MetadataPropertyHandling = MetadataPropertyHandling.Ignore,
            DateParseHandling = DateParseHandling.None,
            Converters = {
                GdpUnionConverter.Singleton,
                IdConverter.Singleton,
                ValueConverter.Singleton,
                new IsoDateTimeConverter { DateTimeStyles = DateTimeStyles.AssumeUniversal }
            },
        };
    }

    internal class GdpUnionConverter : JsonConverter
    {
        public override bool CanConvert(Type t) => t == typeof(GdpUnion) || t == typeof(GdpUnion?);

        public override object ReadJson(JsonReader reader, Type t, object existingValue, JsonSerializer serializer)
        {
            switch (reader.TokenType)
            {
                case JsonToken.StartObject:
                    var objectValue = serializer.Deserialize<FluffyGdp>(reader);
                    return new GdpUnion { FluffyGdp = objectValue };
                case JsonToken.StartArray:
                    var arrayValue = serializer.Deserialize<PurpleGdp[]>(reader);
                    return new GdpUnion { PurpleGdpArray = arrayValue };
            }
            throw new Exception("Cannot unmarshal type GdpUnion");
        }

        public override void WriteJson(JsonWriter writer, object untypedValue, JsonSerializer serializer)
        {
            var value = (GdpUnion)untypedValue;
            if (value.PurpleGdpArray != null)
            {
                serializer.Serialize(writer, value.PurpleGdpArray);
                return;
            }
            if (value.FluffyGdp != null)
            {
                serializer.Serialize(writer, value.FluffyGdp);
                return;
            }
            throw new Exception("Cannot marshal type GdpUnion");
        }

        public static readonly GdpUnionConverter Singleton = new GdpUnionConverter();
    }

    internal class IdConverter : JsonConverter
    {
        public override bool CanConvert(Type t) => t == typeof(Id) || t == typeof(Id?);

        public override object ReadJson(JsonReader reader, Type t, object existingValue, JsonSerializer serializer)
        {
            if (reader.TokenType == JsonToken.Null) return null;
            var value = serializer.Deserialize<string>(reader);
            switch (value)
            {
                case "CN":
                    return Id.Cn;
                case "NY.GDP.MKTP.CD":
                    return Id.NyGdpMktpCd;
                case "US":
                    return Id.Us;
            }
            throw new Exception("Cannot unmarshal type Id");
        }

        public override void WriteJson(JsonWriter writer, object untypedValue, JsonSerializer serializer)
        {
            if (untypedValue == null)
            {
                serializer.Serialize(writer, null);
                return;
            }
            var value = (Id)untypedValue;
            switch (value)
            {
                case Id.Cn:
                    serializer.Serialize(writer, "CN");
                    return;
                case Id.NyGdpMktpCd:
                    serializer.Serialize(writer, "NY.GDP.MKTP.CD");
                    return;
                case Id.Us:
                    serializer.Serialize(writer, "US");
                    return;
            }
            throw new Exception("Cannot marshal type Id");
        }

        public static readonly IdConverter Singleton = new IdConverter();
    }

    internal class ValueConverter : JsonConverter
    {
        public override bool CanConvert(Type t) => t == typeof(Value) || t == typeof(Value?);

        public override object ReadJson(JsonReader reader, Type t, object existingValue, JsonSerializer serializer)
        {
            if (reader.TokenType == JsonToken.Null) return null;
            var value = serializer.Deserialize<string>(reader);
            switch (value)
            {
                case "China":
                    return Value.China;
                case "GDP (current US$)":
                    return Value.GdpCurrentUs;
                case "United States":
                    return Value.UnitedStates;
            }
            throw new Exception("Cannot unmarshal type Value");
        }

        public override void WriteJson(JsonWriter writer, object untypedValue, JsonSerializer serializer)
        {
            if (untypedValue == null)
            {
                serializer.Serialize(writer, null);
                return;
            }
            var value = (Value)untypedValue;
            switch (value)
            {
                case Value.China:
                    serializer.Serialize(writer, "China");
                    return;
                case Value.GdpCurrentUs:
                    serializer.Serialize(writer, "GDP (current US$)");
                    return;
                case Value.UnitedStates:
                    serializer.Serialize(writer, "United States");
                    return;
            }
            throw new Exception("Cannot marshal type Value");
        }

        public static readonly ValueConverter Singleton = new ValueConverter();
    }

    internal class ParseStringConverter : JsonConverter
    {
        public override bool CanConvert(Type t) => t == typeof(long) || t == typeof(long?);

        public override object ReadJson(JsonReader reader, Type t, object existingValue, JsonSerializer serializer)
        {
            if (reader.TokenType == JsonToken.Null) return null;
            var value = serializer.Deserialize<string>(reader);
            long l;
            if (Int64.TryParse(value, out l))
            {
                return l;
            }
            throw new Exception("Cannot unmarshal type long");
        }

        public override void WriteJson(JsonWriter writer, object untypedValue, JsonSerializer serializer)
        {
            if (untypedValue == null)
            {
                serializer.Serialize(writer, null);
                return;
            }
            var value = (long)untypedValue;
            serializer.Serialize(writer, value.ToString());
            return;
        }

        public static readonly ParseStringConverter Singleton = new ParseStringConverter();
    }
}
