
@interface RAFAppearance : NSObject

+ (void)configureAppearance;
+ (UIFont *)defaultFontOfSize:(CGFloat)pointSize;
+ (UIFont *)boldFontOfSize:(CGFloat)pointSize;
+ (UIColor *)accessoryViewColor;
+ (UIColor *)defaultViewColor;
+ (UIColor *)secondaryViewColor;
+ (UIColor *)defaultTextColor;
+ (UIColor *)secondaryTextColor;
+ (UIColor *)accessoryTextColor;
+ (UIColor *)cellBackgroundColor;
+ (UIColor *)cellTextColor;
+ (UIStatusBarStyle)preferredStatusBarStyle;

@end
