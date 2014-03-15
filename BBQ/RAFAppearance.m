#import "RAFAppearance.h"

/**
 Colors
 */
#define kDefaultViewColor @"8A0917"
#define kDefaultTextColor @"FFFFFF"

#define kSecondaryViewColor @"595241"
#define kSecondaryTextColor @"FFFFFF"

#define kAccessoryViewColor @"595241"
#define kAccessoryTextColor @"FFFFFF"

#define kCellBackgroundColor @"FFFFFF"
#define kCellTextColor @"595241"

#define kDefaultTintColor @"FFFFFF"


/**
 Fonts
 */
#define kDefaultFont @"Avenir-Light"
#define kBoldFont @"Avenir-Medium"


@implementation RAFAppearance


+ (void)configureAppearance
{    
    [UIView appearance].tintColor = [UIColor colorWithHexString:kDefaultTintColor];
    
    /**
     UINavigationBar appearance
     */
    [UINavigationBar appearance].barTintColor = [RAFAppearance defaultViewColor];
    [UINavigationBar appearance].barStyle = UIBarStyleBlack;
    
    [UINavigationBar appearance].titleTextAttributes = @
    {
    NSForegroundColorAttributeName:[RAFAppearance defaultTextColor],
    NSFontAttributeName: [RAFAppearance boldFontOfSize:16.0f]
    };
    
    /**
     UITabBar appearance
     */
    [UITabBar appearance].barTintColor = [RAFAppearance secondaryViewColor];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@
     {
     NSForegroundColorAttributeName:[RAFAppearance defaultTextColor],
     NSFontAttributeName: [RAFAppearance boldFontOfSize:12.0f]
     }
     
                                             forState:UIControlStateSelected];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@
     {
     NSForegroundColorAttributeName:[UIColor lightGrayColor],
     NSFontAttributeName: [RAFAppearance boldFontOfSize:12.0f]
     }
     
                                             forState:UIControlStateNormal];
    
    [UITableViewCell appearance].backgroundColor = [RAFAppearance cellBackgroundColor];
    [UITableView appearance].separatorColor = [RAFAppearance accessoryViewColor];
    
    [UITableView appearance].backgroundColor = [RAFAppearance cellBackgroundColor];
}


+ (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


+ (UIColor *)accessoryViewColor
{
    return [UIColor colorWithHexString:kAccessoryViewColor];
}


+ (UIColor *)defaultViewColor
{
    return [UIColor colorWithHexString:kDefaultViewColor];
}


+ (UIColor *)secondaryViewColor
{
    return [UIColor colorWithHexString:kSecondaryViewColor];
}


+ (UIColor *)defaultTextColor
{
    return [UIColor colorWithHexString:kDefaultTextColor];
}


+ (UIColor *)secondaryTextColor
{
    return [UIColor colorWithHexString:kSecondaryTextColor];
}


+ (UIColor *)accessoryTextColor;
{
    return [UIColor colorWithHexString:kSecondaryTextColor];
}

+ (UIFont *)defaultFontOfSize:(CGFloat)pointSize
{
    return [UIFont fontWithName:kDefaultFont size:pointSize];
}


+ (UIFont *)boldFontOfSize:(CGFloat)pointSize
{
    return [UIFont fontWithName:kBoldFont size:pointSize];
}


+ (UIColor *)cellBackgroundColor
{
    return [UIColor colorWithHexString:kCellBackgroundColor];
}


+ (UIColor *)cellTextColor
{
    return [UIColor colorWithHexString:kCellTextColor];
}


@end