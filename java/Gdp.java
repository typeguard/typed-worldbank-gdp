package io.quicktype;

import java.util.Map;
import java.io.IOException;
import com.fasterxml.jackson.core.*;
import com.fasterxml.jackson.databind.*;
import com.fasterxml.jackson.databind.annotation.*;

@JsonDeserialize(using = Gdp.Deserializer.class)
@JsonSerialize(using = Gdp.Serializer.class)
public class Gdp {
    public FluffyGDP fluffyGDPValue;
    public PurpleGDP[] purpleGDPArrayValue;

    static class Deserializer extends JsonDeserializer<Gdp> {
        @Override
        public Gdp deserialize(JsonParser jsonParser, DeserializationContext deserializationContext) throws IOException, JsonProcessingException {
            Gdp value = new Gdp();
            switch (jsonParser.getCurrentToken()) {
            case START_ARRAY:
                value.purpleGDPArrayValue = jsonParser.readValueAs(PurpleGDP[].class);
                break;
            case START_OBJECT:
                value.fluffyGDPValue = jsonParser.readValueAs(FluffyGDP.class);
                break;
            default: throw new IOException("Cannot deserialize Gdp");
            }
            return value;
        }
    }

    static class Serializer extends JsonSerializer<Gdp> {
        @Override
        public void serialize(Gdp obj, JsonGenerator jsonGenerator, SerializerProvider serializerProvider) throws IOException {
            if (obj.fluffyGDPValue != null) {
                jsonGenerator.writeObject(obj.fluffyGDPValue);
                return;
            }
            if (obj.purpleGDPArrayValue != null) {
                jsonGenerator.writeObject(obj.purpleGDPArrayValue);
                return;
            }
            throw new IOException("Gdp must not be null");
        }
    }
}
