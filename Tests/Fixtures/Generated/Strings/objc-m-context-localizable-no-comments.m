// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen


#import "Localizable.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wformat-security"

NSString* tr(NSString* key, ...) {
    va_list args;
    va_start(args, key);

    NSString *format = [NSBundle.mainBundle localizedStringForKey:key value:@"" table:nil];
    NSString *result = [[NSString alloc] initWithFormat:format arguments:args];
    return result;
};


@implementation Localized : NSObject
+ (NSString*)alertMessage {  
    return tr(@"alert_message"); 
}
+ (NSString*)alertTitle {  
    return tr(@"alert_title"); 
}
+ (NSString*)objectOwnership:(NSInteger)p1 and:(NSString*)p2 and:(NSString*)p3
{  
    return tr(@"ObjectOwnership", p1, p2, p3); 
}
+ (NSString*)private:(NSString*)p1 and:(NSInteger)p2
{  
    return tr(@"private", p1, p2); 
}
+ (NSString*)applesCount:(NSInteger)p1
{  
    return tr(@"apples.count", p1); 
}
+ (NSString*)bananasOwner:(NSInteger)p1 and:(NSString*)p2
{  
    return tr(@"bananas.owner", p1, p2); 
}
+ (NSString*)settingsNavigationBarSelf {  
    return tr(@"settings.navigation-bar.self"); 
}
+ (NSString*)settingsNavigationBarTitleDeeperThanWeCanHandleNoReallyThisIsDeep {  
    return tr(@"settings.navigation-bar.title.deeper.than.we.can.handle.no.really.this.is.deep"); 
}
+ (NSString*)settingsNavigationBarTitleEvenDeeper {  
    return tr(@"settings.navigation-bar.title.even.deeper"); 
}
+ (NSString*)settingsUserProfileSectionFooterText {  
    return tr(@"settings.user_profile_section.footer_text"); 
}
+ (NSString*)settingsUserProfileSectionHEADERTITLE {  
    return tr(@"settings.user_profile_section.HEADER_TITLE"); 
}
@end
