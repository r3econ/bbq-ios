@interface UIColor (Extensions)


/**
 Creates a UIColor from a hex string.
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;

+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;


@end