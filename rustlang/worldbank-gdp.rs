// Example code that deserializes and serializes the model.
// extern crate serde;
// #[macro_use]
// extern crate serde_derive;
// extern crate serde_json;
// 
// use generated_module::GDP;
// 
// fn main() {
//     let json = r#"{"answer": 42}"#;
//     let model: GDP = serde_json::from_str(&json).unwrap();
// }

extern crate serde_json;

pub type Gdp = Vec<GdpUnion>;

#[derive(Serialize, Deserialize)]
pub struct PurpleGdp {
    #[serde(rename = "indicator")]
    indicator: Country,

    #[serde(rename = "country")]
    country: Country,

    #[serde(rename = "value")]
    value: Option<String>,

    #[serde(rename = "decimal")]
    decimal: Decimal,

    #[serde(rename = "date")]
    date: String,
}

#[derive(Serialize, Deserialize)]
pub struct Country {
    #[serde(rename = "id")]
    id: Id,

    #[serde(rename = "value")]
    value: Value,
}

#[derive(Serialize, Deserialize)]
pub struct FluffyGdp {
    #[serde(rename = "page")]
    page: i64,

    #[serde(rename = "pages")]
    pages: i64,

    #[serde(rename = "per_page")]
    per_page: String,

    #[serde(rename = "total")]
    total: i64,
}

#[derive(Serialize, Deserialize)]
#[serde(untagged)]
pub enum GdpUnion {
    FluffyGdp(FluffyGdp),

    PurpleGdpArray(Vec<PurpleGdp>),
}

#[derive(Serialize, Deserialize)]
pub enum Id {
    #[serde(rename = "CN")]
    Cn,

    #[serde(rename = "NY.GDP.MKTP.CD")]
    NyGdpMktpCd,

    #[serde(rename = "US")]
    Us,
}

#[derive(Serialize, Deserialize)]
pub enum Value {
    #[serde(rename = "China")]
    China,

    #[serde(rename = "GDP (current US$)")]
    GdpCurrentUs,

    #[serde(rename = "United States")]
    UnitedStates,
}

#[derive(Serialize, Deserialize)]
pub enum Decimal {
    #[serde(rename = "0")]
    The0,
}
