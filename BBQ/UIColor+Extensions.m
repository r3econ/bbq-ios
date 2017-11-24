#import "UIColor+Extensions.h"


@implementation UIColor (Extensions)


/**
 Creates a UIColor from a hex string.
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    
    // Remove potential "#" character.
    NSString *cleanedString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];

    // Create a scanner with string.
    NSScanner *scanner = [NSScanner scannerWithString:cleanedString];
    
    // Get hex value.
    [scanner scanHexInt:&rgbValue];
    
    // Create a UIColor.
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0
                           green:((rgbValue & 0xFF00) >> 8)/255.0
                            blue:(rgbValue & 0xFF)/255.0
                           alpha:1.0];
}


/**
 Creates a UIColor from a hex string.
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    unsigned rgbValue = 0;
    
    // Remove potential "#" character.
    NSString *cleanedString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    // Create a scanner with string.
    NSScanner *scanner = [NSScanner scannerWithString:cleanedString];
    
    // Get hex value.
    [scanner scanHexInt:&rgbValue];
    
    // Create a UIColor.
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0
                           green:((rgbValue & 0xFF00) >> 8)/255.0
                            blue:(rgbValue & 0xFF)/255.0
                           alpha:alpha];
}


@end
