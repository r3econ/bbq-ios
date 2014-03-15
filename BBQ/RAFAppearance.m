#import "RAFAppearance.h"

/**
 Colors
 */
#define kAccessoryViewColor @"5E5A59"
#define kDefaultViewColor @"F2CA80"
#define kSecondaryViewColor @"5E5A59"
#define kDefaultTextColor @"0D0D0D"
#define kSecondaryTextColor @"5E5A59"
#define kAccessoryTextColor @"FFFFFF"
#define kCellBackgroundColor @"FFFFFF"


/**
 Fonts
 */
#define kDefaultFont @"Avenir-Light"
#define kBoldFont @"Avenir-Black"


@implementation RAFAppearance


+ (void)configureAppearance
{    
    [UIView appearance].tintColor = [UIColor blackColor];
    
    /**
     UINavigationBar appearance
     */
    [UINavigationBar appearance].barTintColor = [RAFAppearance defaultViewColor];
    
    [UINavigationBar appearance].titleTextAttributes = @
    {
    NSForegroundColorAttributeName:[RAFAppearance defaultTextColor],
    NSFontAttributeName: [RAFAppearance boldFontOfSize:16.0f]
    };
    
    /**
     UITabBar appearance
     */
    [UITabBar appearance].barTintColor = [RAFAppearance defaultViewColor];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@
     {
     NSForegroundColorAttributeName:[RAFAppearance defaultTextColor],
     NSFontAttributeName: [RAFAppearance boldFontOfSize:12.0f]
     }
     
                                             forState:UIControlStateSelected];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@
     {
     NSForegroundColorAttributeName:[RAFAppearance secondaryTextColor],
     NSFontAttributeName: [RAFAppearance boldFontOfSize:12.0f]
     }
     
                                             forState:UIControlStateNormal];
    
    [UITableViewCell appearance].backgroundColor = [RAFAppearance cellBackgroundColor];
    [UITableView appearance].separatorColor = [RAFAppearance accessoryViewColor];
    [UITableView appearance].backgroundColor = [RAFAppearance cellBackgroundColor];
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

@end