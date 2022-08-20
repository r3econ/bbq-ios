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


#import "RAFUtilities.h"

NSString* GetDocumentsDirectory(void) {
	return [NSHomeDirectory() stringByAppendingPathComponent: @"Documents"];
}

#ifdef DEBUG
UIImage* LoadImageNamed(NSString* name) {
    UIImage* result = [UIImage imageNamed: name];
    
    if (result == nil) {
        [NSException raise: @"CantFindImage"
                    format: @"Can't find image: %@", name];
    }
    
    return result;
}
#endif

/**
 In DEBUG mode this method throws an exception when the cast is invalid.
 */
id Cast(id source, Class cl) {
	if (source != nil) {
		if (![source isKindOfClass: cl]) {
            NSLog(@"%@", [NSString stringWithFormat: @"The cast is invalid (%@ to %@)", [source class], cl]);
            
			@throw [NSException exceptionWithName:@"CastException"
                                           reason: [NSString stringWithFormat: @"The cast is invalid (%@ to %@)",
                                                    [source class],
                                                    cl]
                                         userInfo:nil];
		}
	}
	
	return source;
}

/**
 This method returns nil when the cast is invalid.
 */
id TryCast(id source, Class cl) {
	if (source != nil) {
		if ([source isKindOfClass: cl]) {
			return source;
		}
	}
	
	return nil;
}
