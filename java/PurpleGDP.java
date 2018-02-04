package io.quicktype;

import java.util.Map;
import com.fasterxml.jackson.annotation.*;

public class PurpleGDP {
    private Country indicator;
    private Country country;
    private String value;
    private Decimal decimal;
    private String date;

    @JsonProperty("indicator")
    public Country getIndicator() { return indicator; }
    @JsonProperty("indicator")
    public void setIndicator(Country value) { this.indicator = value; }

    @JsonProperty("country")
    public Country getCountry() { return country; }
    @JsonProperty("country")
    public void setCountry(Country value) { this.country = value; }

    @JsonProperty("value")
    public String getValue() { return value; }
    @JsonProperty("value")
    public void setValue(String value) { this.value = value; }

    @JsonProperty("decimal")
    public Decimal getDecimal() { return decimal; }
    @JsonProperty("decimal")
    public void setDecimal(Decimal value) { this.decimal = value; }

    @JsonProperty("date")
    public String getDate() { return date; }
    @JsonProperty("date")
    public void setDate(String value) { this.date = value; }
}
