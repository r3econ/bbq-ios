#import "RAFAppearance.h"

/**
 Colors
 */
#define kDefaultViewColor @"59023B"
#define kDefaultTextColor @"E7F2DF"

#define kSecondaryViewColor @"161726"
#define kSecondaryTextColor @"E7F2DF"

#define kAccessoryViewColor @"231E2D"
#define kAccessoryTextColor @"E7F2DF"

#define kCellBackgroundColor @"E7F2DF"
#define kCellTextColor @"161726"

#define kDefaultTintColor @"E7F2DF"


/**
 Fonts
 */
#define kDefaultFont @"Avenir-Light"
#define kBoldFont @"Avenir-Medium"

@implementation RAFAppearance

+ (void)configureAppearance {
    [UIView appearance].tintColor = [UIColor colorWithHexString:kDefaultTintColor];
    
    /**
     UINavigationBar appearance
     */
    [UINavigationBar appearance].barTintColor = [RAFAppearance defaultViewColor];
    [UINavigationBar appearance].barStyle = UIBarStyleBlack;
    
    [UINavigationBar appearance].titleTextAttributes = @{
                                                         NSForegroundColorAttributeName:[RAFAppearance defaultTextColor],
                                                         NSFontAttributeName: [RAFAppearance boldFontOfSize:16.0f]
                                                         };
    
    /**
     UITabBar appearance
     */
    [UITabBar appearance].barTintColor = [RAFAppearance secondaryViewColor];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSForegroundColorAttributeName:[RAFAppearance defaultTextColor],
                                                        NSFontAttributeName: [RAFAppearance boldFontOfSize:12.0f]
                                                        }
                                             forState:UIControlStateSelected];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                                        NSFontAttributeName: [RAFAppearance boldFontOfSize:12.0f]
                                                        }
                                             forState:UIControlStateNormal];
    
    [UITableViewCell appearance].backgroundColor = [RAFAppearance cellBackgroundColor];
    [UITableView appearance].separatorColor = [RAFAppearance accessoryViewColor];
    
    [UITableView appearance].backgroundColor = [RAFAppearance cellBackgroundColor];
}

+ (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

+ (UIColor *)accessoryViewColor {
    return [UIColor colorWithHexString:kAccessoryViewColor];
}

+ (UIColor *)defaultViewColor {
    return [UIColor colorWithHexString:kDefaultViewColor];
}

+ (UIColor *)secondaryViewColor {
    return [UIColor colorWithHexString:kSecondaryViewColor];
}

+ (UIColor *)defaultTextColor {
    return [UIColor colorWithHexString:kDefaultTextColor];
}

+ (UIColor *)secondaryTextColor {
    return [UIColor colorWithHexString:kSecondaryTextColor];
}

+ (UIColor *)accessoryTextColor {
    return [UIColor colorWithHexString:kAccessoryTextColor];
}

+ (UIFont *)defaultFontOfSize:(CGFloat)pointSize {
    return [UIFont fontWithName:kDefaultFont size:pointSize];
}

+ (UIFont *)boldFontOfSize:(CGFloat)pointSize {
    return [UIFont fontWithName:kBoldFont size:pointSize];
}

+ (UIColor *)cellBackgroundColor {
    return [UIColor colorWithHexString:kCellBackgroundColor];
}

+ (UIColor *)cellTextColor {
    return [UIColor colorWithHexString:kCellTextColor];
}

@end

