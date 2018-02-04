package io.quicktype;

import java.util.Map;
import java.io.IOException;
import com.fasterxml.jackson.annotation.*;

public enum ID {
    CN, NY_GDP_MKTP_CD, US;

    @JsonValue
    public String toValue() {
        switch (this) {
        case CN: return "CN";
        case NY_GDP_MKTP_CD: return "NY.GDP.MKTP.CD";
        case US: return "US";
        }
        return null;
    }

    @JsonCreator
    public static ID forValue(String value) throws IOException {
        if (value.equals("CN")) return CN;
        if (value.equals("NY.GDP.MKTP.CD")) return NY_GDP_MKTP_CD;
        if (value.equals("US")) return US;
        throw new IOException("Cannot deserialize ID");
    }
}
