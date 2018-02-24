package io.quicktype;

import java.util.Map;
import java.io.IOException;
import com.fasterxml.jackson.core.*;
import com.fasterxml.jackson.databind.*;
import com.fasterxml.jackson.databind.annotation.*;

@JsonDeserialize(using = Gdp.Deserializer.class)
@JsonSerialize(using = Gdp.Serializer.class)
public class Gdp {
    public PurpleGDP purpleGDPValue;
    public GDPElement[] gdpElementArrayValue;

    static class Deserializer extends JsonDeserializer<Gdp> {
        @Override
        public Gdp deserialize(JsonParser jsonParser, DeserializationContext deserializationContext) throws IOException, JsonProcessingException {
            Gdp value = new Gdp();
            switch (jsonParser.getCurrentToken()) {
            case START_ARRAY:
                value.gdpElementArrayValue = jsonParser.readValueAs(GDPElement[].class);
                break;
            case START_OBJECT:
                value.purpleGDPValue = jsonParser.readValueAs(PurpleGDP.class);
                break;
            default: throw new IOException("Cannot deserialize Gdp");
            }
            return value;
        }
    }

    static class Serializer extends JsonSerializer<Gdp> {
        @Override
        public void serialize(Gdp obj, JsonGenerator jsonGenerator, SerializerProvider serializerProvider) throws IOException {
            if (obj.purpleGDPValue != null) {
                jsonGenerator.writeObject(obj.purpleGDPValue);
                return;
            }
            if (obj.gdpElementArrayValue != null) {
                jsonGenerator.writeObject(obj.gdpElementArrayValue);
                return;
            }
            throw new IOException("Gdp must not be null");
        }
    }
}
