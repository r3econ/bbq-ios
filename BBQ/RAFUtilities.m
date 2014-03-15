#import "RAFUtilities.h"


NSString* GetDocumentsDirectory(void)
{
	return [NSHomeDirectory() stringByAppendingPathComponent: @"Documents"];
}


#ifdef DEBUG
UIImage* LoadImageNamed(NSString* name)
{
    UIImage* result = [UIImage imageNamed: name];
    
    if (result == nil)
    {
        [NSException raise: @"CantFindImage" format: @"Can't find image: %@", name];
    }
    
    return result;
}
#endif


/**
 In DEBUG mode this method throws an exception when the cast is invalid.
 */
id Cast(id source, Class cl)
{
	if (source != nil)
	{
		if (![source isKindOfClass: cl])
		{
            NSLog(@"%@", [NSString stringWithFormat: @"The cast is invalid (%@ to %@)", [source class], cl]);
            
			@throw [NSException exceptionWithName:@"CastException"
                                           reason: [NSString stringWithFormat: @"The cast is invalid (%@ to %@)", [source class], cl]
                                         userInfo:nil];
		}
	}
	
	return source;
}


/**
 This method returns nil when the cast is invalid.
 */
id TryCast(id source, Class cl)
{
	if (source != nil)
	{
		if ([source isKindOfClass: cl])
		{
			return source;
		}
	}
	
	return nil;
}


//id <UIApplicationDelegate> GetAppDelegate(void)
//{
////    return SAFE_CAST([UIApplication sharedApplication].delegate, EDAppDelegate);
//    return ([UIApplication sharedApplication].delegate);
//}
