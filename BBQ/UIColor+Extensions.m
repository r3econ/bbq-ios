//
// Copyright (c) 2014 Rafał Sroka
//
// Licensed under the GNU General Public License, Version 3.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at:
//
//   https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
