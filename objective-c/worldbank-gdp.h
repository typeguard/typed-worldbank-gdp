// To parse this JSON:
// 
//   NSError *error;
//   GDGdp *gdp = GDGdpFromJSON(json, NSUTF8Encoding, &error);

#import <Foundation/Foundation.h>

@class GDPurpleGDP;
@class GDCountry;
@class GDID;
@class GDValue;
@class GDDecimal;
@class GDFluffyGDP;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Boxed enums

@interface GDID : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (GDID *)cn;
+ (GDID *)nyGdpMktpCD;
+ (GDID *)us;
@end

@interface GDValue : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (GDValue *)china;
+ (GDValue *)gdpCurrentUS;
+ (GDValue *)unitedStates;
@end

@interface GDDecimal : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (GDDecimal *)the0;
@end

typedef NSArray<id> GDGdp;

#pragma mark - Top-level marshaling functions

GDGdp *_Nullable GDGdpFromData(NSData *data, NSError **error);
GDGdp *_Nullable GDGdpFromJSON(NSString *json, NSStringEncoding encoding, NSError **error);
NSData *_Nullable GDGdpToData(GDGdp *gdp, NSError **error);
NSString *_Nullable GDGdpToJSON(GDGdp *gdp, NSStringEncoding encoding, NSError **error);

#pragma mark - Object interfaces

@interface GDPurpleGDP : NSObject
@property (nonatomic, strong)         GDCountry *indicator;
@property (nonatomic, strong)         GDCountry *country;
@property (nonatomic, nullable, copy) NSString *value;
@property (nonatomic, assign)         GDDecimal *decimal;
@property (nonatomic, copy)           NSString *date;
@end

@interface GDCountry : NSObject
@property (nonatomic, assign) GDID *identifier;
@property (nonatomic, assign) GDValue *value;
@end

@interface GDFluffyGDP : NSObject
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, copy)   NSString *perPage;
@property (nonatomic, assign) NSInteger total;
@end

NS_ASSUME_NONNULL_END
