package io.quicktype;

import java.util.Map;
import java.io.IOException;
import com.fasterxml.jackson.annotation.*;

public enum Value {
    CHINA, GDP_CURRENT_US, UNITED_STATES;

    @JsonValue
    public String toValue() {
        switch (this) {
        case CHINA: return "China";
        case GDP_CURRENT_US: return "GDP (current US$)";
        case UNITED_STATES: return "United States";
        }
        return null;
    }

    @JsonCreator
    public static Value forValue(String value) throws IOException {
        if (value.equals("China")) return CHINA;
        if (value.equals("GDP (current US$)")) return GDP_CURRENT_US;
        if (value.equals("United States")) return UNITED_STATES;
        throw new IOException("Cannot deserialize Value");
    }
}
