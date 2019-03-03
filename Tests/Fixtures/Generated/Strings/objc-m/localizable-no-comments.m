// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#import "Localizable.h"

@interface BundleToken : NSObject
@end

@implementation BundleToken
@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wformat-security"

static NSString* tr(NSString *tableName, NSString *key, ...) {
    va_list args;
    va_start(args, key);

    NSBundle *bundle = [NSBundle bundleForClass:BundleToken.class];
    NSString *format = [bundle localizedStringForKey:key value:@"" table:tableName];
    NSString *result = [[NSString alloc] initWithFormat:format arguments:args];
    return result;
};
#pragma clang diagnostic pop

@implementation Localizable : NSObject
+ (NSString*)alertMessage {
    return tr(@"Localizable", @"alert__message");
}
+ (NSString*)alertTitle {
    return tr(@"Localizable", @"alert__title");
}
+ (NSString*)objectOwnership:(NSInteger)p1 and:(id)p2 and:(id)p3
{
    return tr(@"Localizable", @"ObjectOwnership", p1, p2, p3);
}
+ (NSString*)percent {
    return tr(@"Localizable", @"percent");
}
+ (NSString*)private:(id)p1 and:(NSInteger)p2
{
    return tr(@"Localizable", @"private", p1, p2);
}
+ (NSString*)types:(id)p1 and:(char)p2 and:(NSInteger)p3 and:(float)p4 and:(char*)p5 and:(void*)p6
{
    return tr(@"Localizable", @"types", p1, p2, p3, p4, p5, p6);
}
+ (NSString*)applesCount:(NSInteger)p1
{
    return tr(@"Localizable", @"apples.count", p1);
}
+ (NSString*)bananasOwner:(NSInteger)p1 and:(id)p2
{
    return tr(@"Localizable", @"bananas.owner", p1, p2);
}
+ (NSString*)settingsNavigationBarSelf {
    return tr(@"Localizable", @"settings.navigation-bar.self");
}
+ (NSString*)settingsNavigationBarTitleDeeperThanWeCanHandleNoReallyThisIsDeep {
    return tr(@"Localizable", @"settings.navigation-bar.title.deeper.than.we.can.handle.no.really.this.is.deep");
}
+ (NSString*)settingsNavigationBarTitleEvenDeeper {
    return tr(@"Localizable", @"settings.navigation-bar.title.even.deeper");
}
+ (NSString*)settingsUserProfileSectionFooterText {
    return tr(@"Localizable", @"settings.user__profile_section.footer_text");
}
+ (NSString*)settingsUserProfileSectionHEADERTITLE {
    return tr(@"Localizable", @"settings.user__profile_section.HEADER_TITLE");
}
@end

