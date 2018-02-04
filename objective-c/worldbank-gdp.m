#import "worldbank-gdp.h"

#define λ(decl, expr) (^(decl) { return (expr); })

static id NSNullify(id _Nullable x) {
    return (x == nil || x == NSNull.null) ? NSNull.null : x;
}

NS_ASSUME_NONNULL_BEGIN

@interface GDPurpleGDP (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

@interface GDCountry (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

@interface GDFluffyGDP (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

@implementation GDID
+ (NSDictionary<NSString *, GDID *> *)values
{
    static NSDictionary<NSString *, GDID *> *values;
    return values = values ? values : @{
        @"CN": [[GDID alloc] initWithValue:@"CN"],
        @"NY.GDP.MKTP.CD": [[GDID alloc] initWithValue:@"NY.GDP.MKTP.CD"],
        @"US": [[GDID alloc] initWithValue:@"US"],
    };
}

+ (GDID *)cn { return GDID.values[@"CN"]; }
+ (GDID *)nyGdpMktpCD { return GDID.values[@"NY.GDP.MKTP.CD"]; }
+ (GDID *)us { return GDID.values[@"US"]; }

+ (instancetype _Nullable)withValue:(NSString *)value
{
    return GDID.values[value];
}

- (instancetype)initWithValue:(NSString *)value
{
    if (self = [super init]) _value = value;
    return self;
}

- (NSUInteger)hash { return _value.hash; }
@end

@implementation GDValue
+ (NSDictionary<NSString *, GDValue *> *)values
{
    static NSDictionary<NSString *, GDValue *> *values;
    return values = values ? values : @{
        @"China": [[GDValue alloc] initWithValue:@"China"],
        @"GDP (current US$)": [[GDValue alloc] initWithValue:@"GDP (current US$)"],
        @"United States": [[GDValue alloc] initWithValue:@"United States"],
    };
}

+ (GDValue *)china { return GDValue.values[@"China"]; }
+ (GDValue *)gdpCurrentUS { return GDValue.values[@"GDP (current US$)"]; }
+ (GDValue *)unitedStates { return GDValue.values[@"United States"]; }

+ (instancetype _Nullable)withValue:(NSString *)value
{
    return GDValue.values[value];
}

- (instancetype)initWithValue:(NSString *)value
{
    if (self = [super init]) _value = value;
    return self;
}

- (NSUInteger)hash { return _value.hash; }
@end

@implementation GDDecimal
+ (NSDictionary<NSString *, GDDecimal *> *)values
{
    static NSDictionary<NSString *, GDDecimal *> *values;
    return values = values ? values : @{
        @"0": [[GDDecimal alloc] initWithValue:@"0"],
    };
}

+ (GDDecimal *)the0 { return GDDecimal.values[@"0"]; }

+ (instancetype _Nullable)withValue:(NSString *)value
{
    return GDDecimal.values[value];
}

- (instancetype)initWithValue:(NSString *)value
{
    if (self = [super init]) _value = value;
    return self;
}

- (NSUInteger)hash { return _value.hash; }
@end

static id map(id collection, id (^f)(id value)) {
    id result = nil;
    if ([collection isKindOfClass:NSArray.class]) {
        result = [NSMutableArray arrayWithCapacity:[collection count]];
        for (id x in collection) [result addObject:f(x)];
    } else if ([collection isKindOfClass:NSDictionary.class]) {
        result = [NSMutableDictionary dictionaryWithCapacity:[collection count]];
        for (id key in collection) [result setObject:f([collection objectForKey:key]) forKey:key];
    }
    return result;
}

#pragma mark - JSON serialization

GDGdp *_Nullable GDGdpFromData(NSData *data, NSError **error)
{
    @try {
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:error];
        return *error ? nil : map(json, λ(id x, x));
    } @catch (NSException *exception) {
        *error = [NSError errorWithDomain:@"JSONSerialization" code:-1 userInfo:@{ @"exception": exception }];
        return nil;
    }
}

GDGdp *_Nullable GDGdpFromJSON(NSString *json, NSStringEncoding encoding, NSError **error)
{
    return GDGdpFromData([json dataUsingEncoding:encoding], error);
}

NSData *_Nullable GDGdpToData(GDGdp *gdp, NSError **error)
{
    @try {
        id json = gdp;
        NSData *data = [NSJSONSerialization dataWithJSONObject:json options:kNilOptions error:error];
        return *error ? nil : data;
    } @catch (NSException *exception) {
        *error = [NSError errorWithDomain:@"JSONSerialization" code:-1 userInfo:@{ @"exception": exception }];
        return nil;
    }
}

NSString *_Nullable GDGdpToJSON(GDGdp *gdp, NSStringEncoding encoding, NSError **error)
{
    NSData *data = GDGdpToData(gdp, error);
    return data ? [[NSString alloc] initWithData:data encoding:encoding] : nil;
}

@implementation GDPurpleGDP
+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"indicator": @"indicator",
        @"country": @"country",
        @"value": @"value",
        @"decimal": @"decimal",
        @"date": @"date",
    };
}

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
{
    return dict ? [[GDPurpleGDP alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        _indicator = [GDCountry fromJSONDictionary:(id)_indicator];
        _country = [GDCountry fromJSONDictionary:(id)_country];
        _decimal = [GDDecimal withValue:(id)_decimal];
    }
    return self;
}

- (NSDictionary *)JSONDictionary
{
    id dict = [[self dictionaryWithValuesForKeys:GDPurpleGDP.properties.allValues] mutableCopy];

    [dict addEntriesFromDictionary:@{
        @"indicator": [_indicator JSONDictionary],
        @"country": [_country JSONDictionary],
        @"decimal": [_decimal value],
    }];

    return dict;
}
@end

@implementation GDCountry
+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"id": @"identifier",
        @"value": @"value",
    };
}

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
{
    return dict ? [[GDCountry alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        _identifier = [GDID withValue:(id)_identifier];
        _value = [GDValue withValue:(id)_value];
    }
    return self;
}

- (void)setValue:(nullable id)value forKey:(NSString *)key
{
    [super setValue:value forKey:GDCountry.properties[key]];
}

- (NSDictionary *)JSONDictionary
{
    id dict = [[self dictionaryWithValuesForKeys:GDCountry.properties.allValues] mutableCopy];

    for (id jsonName in GDCountry.properties) {
        id propertyName = GDCountry.properties[jsonName];
        if (![jsonName isEqualToString:propertyName]) {
            dict[jsonName] = dict[propertyName];
            [dict removeObjectForKey:propertyName];
        }
    }

    [dict addEntriesFromDictionary:@{
        @"id": [_identifier value],
        @"value": [_value value],
    }];

    return dict;
}
@end

@implementation GDFluffyGDP
+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"page": @"page",
        @"pages": @"pages",
        @"per_page": @"perPage",
        @"total": @"total",
    };
}

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
{
    return dict ? [[GDFluffyGDP alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(nullable id)value forKey:(NSString *)key
{
    [super setValue:value forKey:GDFluffyGDP.properties[key]];
}

- (NSDictionary *)JSONDictionary
{
    id dict = [[self dictionaryWithValuesForKeys:GDFluffyGDP.properties.allValues] mutableCopy];

    for (id jsonName in GDFluffyGDP.properties) {
        id propertyName = GDFluffyGDP.properties[jsonName];
        if (![jsonName isEqualToString:propertyName]) {
            dict[jsonName] = dict[propertyName];
            [dict removeObjectForKey:propertyName];
        }
    }

    return dict;
}
@end

NS_ASSUME_NONNULL_END
