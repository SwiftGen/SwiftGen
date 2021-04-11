// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#import "Localizable.h"

@interface BundleToken : NSObject
@end

@implementation BundleToken
@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wformat-security"

static NSString* tr(NSString *tableName, NSString *key, ...) {
    NSBundle *bundle = [NSBundle bundleForClass:BundleToken.class];
    NSString *format = [bundle localizedStringForKey:key value:nil table:tableName];
    NSLocale *locale = [NSLocale currentLocale];

    va_list args;
    va_start(args, key);
    NSString *result = [[NSString alloc] initWithFormat:format locale:locale arguments:args];
    va_end(args);

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
+ (NSString*)objectOwnershipWithValues:(NSInteger)p1 :(id)p2 :(id)p3
{
    return tr(@"Localizable", @"ObjectOwnership", p1, p2, p3);
}
+ (NSString*)percent {
    return tr(@"Localizable", @"percent");
}
+ (NSString*)privateWithValues:(id)p1 :(NSInteger)p2
{
    return tr(@"Localizable", @"private", p1, p2);
}
+ (NSString*)typesWithValues:(id)p1 :(char)p2 :(NSInteger)p3 :(float)p4 :(char*)p5 :(void*)p6
{
    return tr(@"Localizable", @"types", p1, p2, p3, p4, p5, p6);
}
+ (NSString*)applesCountWithValue:(NSInteger)p1
{
    return tr(@"Localizable", @"apples.count", p1);
}
+ (NSString*)bananasOwnerWithValues:(NSInteger)p1 :(id)p2
{
    return tr(@"Localizable", @"bananas.owner", p1, p2);
}
+ (NSString*)competitionEventNumberOfMatchesWithValue:(NSInteger)p1
{
    return tr(@"Localizable", @"competition.event.number-of-matches", p1);
}
+ (NSString*)feedSubscriptionCountWithValue:(NSInteger)p1
{
    return tr(@"Localizable", @"feed.subscription.count", p1);
}
+ (NSString*)manyPlaceholdersBaseWithValues:(id)p1 :(NSInteger)p2 :(float)p3 :(float)p4 :(NSInteger)p5 :(NSInteger)p6 :(id)p7 :(float)p8 :(id)p9 :(NSInteger)p10 :(float)p11
{
    return tr(@"Localizable", @"many.placeholders.base", p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11);
}
+ (NSString*)manyPlaceholdersZeroWithValues:(id)p1 :(NSInteger)p2 :(float)p3 :(float)p4 :(NSInteger)p5 :(NSInteger)p6 :(id)p7 :(float)p8 :(id)p9 :(NSInteger)p10 :(float)p11
{
    return tr(@"Localizable", @"many.placeholders.zero", p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11);
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

