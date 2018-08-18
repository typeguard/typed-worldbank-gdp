// To parse the JSON, install Klaxon and do:
//
//   val gdp = Gdp.fromJson(jsonString)

package quicktype

import com.beust.klaxon.*

private fun <T> Klaxon.convert(k: kotlin.reflect.KClass<*>, fromJson: (JsonValue) -> T, toJson: (T) -> String, isUnion: Boolean = false) =
    this.converter(object: Converter {
        @Suppress("UNCHECKED_CAST")
        override fun toJson(value: Any)        = toJson(value as T)
        override fun fromJson(jv: JsonValue)   = fromJson(jv) as Any
        override fun canConvert(cls: Class<*>) = cls == k.java || (isUnion && cls.superclass == k.java)
    })

private val klaxon = Klaxon()
    .convert(ID::class,       { ID.fromValue(it.string!!) },    { "\"${it.value}\"" })
    .convert(Value::class,    { Value.fromValue(it.string!!) }, { "\"${it.value}\"" })
    .convert(GDPUnion::class, { GDPUnion.fromJson(it) },        { it.toJson() }, true)

class Gdp(elements: Collection<GDPUnion>) : ArrayList<GDPUnion>(elements) {
    public fun toJson() = klaxon.toJsonString(this)

    companion object {
        public fun fromJson(json: String) = Gdp(klaxon.parseArray<GDPUnion>(json)!!)
    }
}

sealed class GDPUnion {
    class FluffyGDPValue(val value: FluffyGDP)            : GDPUnion()
    class PurpleGDPArrayValue(val value: List<PurpleGDP>) : GDPUnion()

    public fun toJson(): String = klaxon.toJsonString(when (this) {
        is FluffyGDPValue      -> this.value
        is PurpleGDPArrayValue -> this.value
    })

    companion object {
        public fun fromJson(jv: JsonValue): GDPUnion = when (jv.inside) {
            is JsonObject   -> FluffyGDPValue(jv.obj?.let { klaxon.parseFromJsonObject<FluffyGDP>(it) }!!)
            is JsonArray<*> -> PurpleGDPArrayValue(jv.array?.let { klaxon.parseFromJsonArray<PurpleGDP>(it) }!!)
            else            -> throw IllegalArgumentException()
        }
    }
}

data class PurpleGDP (
    val indicator: Country,
    val country: Country,
    val value: String,
    val decimal: String,
    val date: String
)

data class Country (
    val id: ID,
    val value: Value
)

enum class ID(val value: String) {
    CN("CN"),
    NyGdpMktpCD("NY.GDP.MKTP.CD"),
    Us("US");

    companion object {
        public fun fromValue(value: String): ID = when (value) {
            "CN"             -> CN
            "NY.GDP.MKTP.CD" -> NyGdpMktpCD
            "US"             -> Us
            else             -> throw IllegalArgumentException()
        }
    }
}

enum class Value(val value: String) {
    China("China"),
    GDPCurrentUS("GDP (current US\$)"),
    UnitedStates("United States");

    companion object {
        public fun fromValue(value: String): Value = when (value) {
            "China"              -> China
            "GDP (current US\$)" -> GDPCurrentUS
            "United States"      -> UnitedStates
            else                 -> throw IllegalArgumentException()
        }
    }
}

data class FluffyGDP (
    val page: Long,
    val pages: Long,

    @Json(name = "per_page")
    val perPage: String,

    val total: Long
)
