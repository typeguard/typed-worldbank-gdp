package io.quicktype;

import java.util.Map;
import java.io.IOException;
import com.fasterxml.jackson.annotation.*;

public enum Decimal {
    THE_0;

    @JsonValue
    public String toValue() {
        switch (this) {
        case THE_0: return "0";
        }
        return null;
    }

    @JsonCreator
    public static Decimal forValue(String value) throws IOException {
        if (value.equals("0")) return THE_0;
        throw new IOException("Cannot deserialize Decimal");
    }
}
