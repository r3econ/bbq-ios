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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/objc.h>


/**
 Please always use IMAGE_NAMED so we are sure that the image we try to load really
 exists.
 */
#ifdef DEBUG
#define IMAGE_NAMED(n) LoadImageNamed(n)
UIImage* LoadImageNamed(NSString* name);
#else
#define IMAGE_NAMED(n) [UIImage imageNamed: n]
#endif


/**
 Please always use CAST and TRY_CAST instead of standard Obj-C casting to avoid
 annoying mistakes and spot them quickly while developing.
 */
#ifdef DEBUG
id Cast(id source, Class cl);
#define SAFE_CAST(p, t) ((t*)Cast((id)p, (Class)[t class]))
#else
#define SAFE_CAST(p, t) ((t*)p)
#endif


#define TRY_CAST(p, t) ((t*)TryCast((id)p, [t class]))
id TryCast(id source, Class cl);


#define APP_DELEGATE ([UIApplication sharedApplication].delegate)
