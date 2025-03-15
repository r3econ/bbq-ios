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

#import "RAFTracking.h"
#import "Placemark.h"

static NSString *const kCategoryErrors = @"Errors";
static NSString *const kCategoryUIEvents = @"UI Events";

@implementation RAFTracking

+ (id)sharedInstance {
    static dispatch_once_t once;
    static RAFTracking *sharedInstance;
    
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance configureTracker];
    });
    
    return sharedInstance;
}

- (void)configureTracker {
    // Here configure the tracker if any
}

- (void)trackPageView:(NSString *)pageName {
    // Add page tracking here
}


- (void)trackError:(NSError *)error {
    // Add error tracking here
}

@end
