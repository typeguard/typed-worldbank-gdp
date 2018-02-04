package io.quicktype;

import java.util.Map;
import com.fasterxml.jackson.annotation.*;

public class Country {
    private ID id;
    private Value value;

    @JsonProperty("id")
    public ID getId() { return id; }
    @JsonProperty("id")
    public void setId(ID value) { this.id = value; }

    @JsonProperty("value")
    public Value getValue() { return value; }
    @JsonProperty("value")
    public void setValue(Value value) { this.value = value; }
}
