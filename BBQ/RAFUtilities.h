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