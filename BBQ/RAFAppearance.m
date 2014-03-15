#import "RAFAppearance.h"

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
    return [UIColor colorWithHexString:@"5E5A59"];
}


+ (UIColor *)defaultViewColor
{
    return [UIColor colorWithHexString:@"F2CA80"];
}


+ (UIColor *)secondaryViewColor
{
    return [UIColor colorWithHexString:@"5E5A59"];
}


+ (UIColor *)defaultTextColor
{
    return [UIColor colorWithHexString:@"0D0D0D"];
}


+ (UIColor *)secondaryTextColor
{
    return [UIColor colorWithHexString:@"5E5A59"];
}


+ (UIColor *)accessoryTextColor;
{
    return [UIColor colorWithHexString:@"FFFFFF"];
}

+ (UIFont *)defaultFontOfSize:(CGFloat)pointSize
{
    return [UIFont fontWithName:@"Avenir-Light" size:pointSize];
}


+ (UIFont *)boldFontOfSize:(CGFloat)pointSize
{
    return [UIFont fontWithName:@"Avenir-Black" size:pointSize];
}


+ (UIColor *)cellBackgroundColor
{
    return [UIColor colorWithHexString:@"F4E6CA"];
}

@end