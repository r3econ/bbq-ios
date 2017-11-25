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

#import "RAFAppearance.h"

/**
 Colors
 */
static NSString *const kDefaultViewColor = @"5EB1BF";
static NSString *const kDefaultTextColor = @"FBFEF9";

static NSString *const kSecondaryViewColor = @"042A2B";
static NSString *const kSecondaryTextColor = @"FBFEF9";

static NSString *const kAccessoryViewColor = @"FBF3BE";
static NSString *const kAccessoryTextColor = @"042A2B";

static NSString *const kCellBackgroundColor = @"FBFEF9";
static NSString *const kCellTextColor = @"042A2B";

static NSString *const kDefaultTintColor = @"FBFEF9";

/**
 Fonts
 */
static NSString *const kDefaultFont = @"Avenir-Light";
static NSString *const kBoldFont = @"Avenir-Medium";

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

