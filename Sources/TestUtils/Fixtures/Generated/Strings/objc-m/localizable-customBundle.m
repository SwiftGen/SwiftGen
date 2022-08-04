// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#import "Localizable.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wformat-security"

static NSString* tr(NSString *tableName, NSString *key, NSString *value, ...) {
    NSBundle *bundle = [ResourcesBundle bundle];
    NSString *format = [bundle localizedStringForKey:key value:value table:tableName];
    NSLocale *locale = [NSLocale currentLocale];

    va_list args;
    va_start(args, value);
    NSString *result = [[NSString alloc] initWithFormat:format locale:locale arguments:args];
    va_end(args);

    return result;
};
#pragma clang diagnostic pop

@implementation Localizable : NSObject
+ (NSString*)alertMessage {
    return tr(@"Localizable", @"alert__message", @"Some /*alert body there");
}
+ (NSString*)alertTitle {
    return tr(@"Localizable", @"alert__title", @"Title of the alert");
}
+ (NSString*)key1 {
    return tr(@"Localizable", @"key1", @"value1\tvalue");
}
+ (NSString*)objectOwnershipWithValues:(NSInteger)p1 :(id)p2 :(id)p3
{
    return tr(@"Localizable", @"ObjectOwnership", @"These are %3$@'s %1$d %2$@.", p1, p2, p3);
}
+ (NSString*)percent {
    return tr(@"Localizable", @"percent", @"This is a %% character.");
}
+ (NSString*)privateWithValues:(id)p1 :(NSInteger)p2
{
    return tr(@"Localizable", @"private", @"Hello, my name is \"%@\" and I'm %d", p1, p2);
}
+ (NSString*)typesWithValues:(id)p1 :(char)p2 :(NSInteger)p3 :(float)p4 :(char*)p5 :(void*)p6
{
    return tr(@"Localizable", @"types", @"Object: '%@', Character: '%c', Integer: '%d', Float: '%f', CString: '%s', Pointer: '%p'", p1, p2, p3, p4, p5, p6);
}
+ (NSString*)applesCountWithValue:(NSInteger)p1
{
    return tr(@"Localizable", @"apples.count", @"You have %d apples", p1);
}
+ (NSString*)bananasOwnerWithValues:(NSInteger)p1 :(id)p2
{
    return tr(@"Localizable", @"bananas.owner", @"Those %d bananas belong to %@.", p1, p2);
}
+ (NSString*)key1Anonymous {
    return tr(@"Localizable", @"key1.anonymous", @"value2");
}
+ (NSString*)manyPlaceholdersBaseWithValues:(id)p1 :(NSInteger)p2 :(float)p3 :(float)p4 :(NSInteger)p5 :(NSInteger)p6 :(id)p7 :(float)p8 :(id)p9 :(NSInteger)p10 :(float)p11
{
    return tr(@"Localizable", @"many.placeholders.base", @"%@ %d %f %5$d %04$f %6$d %007$@ %8$3.2f %11$1.2f %9$@ %10$d", p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11);
}
+ (NSString*)manyPlaceholdersZeroWithValues:(id)p1 :(NSInteger)p2 :(float)p3 :(float)p4 :(NSInteger)p5 :(NSInteger)p6 :(id)p7 :(float)p8 :(id)p9 :(NSInteger)p10 :(float)p11
{
    return tr(@"Localizable", @"many.placeholders.zero", @"%@ %d %0$@ %f %5$d %04$f %6$d %007$@ %8$3.2f %11$1.2f %9$@ %10$d", p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11);
}
+ (NSString*)settingsNavigationBarSelf_️ {
    return tr(@"Localizable", @"settings.navigation-bar.self♦️", @"Some Reserved Keyword there👍🏽");
}
+ (NSString*)settingsNavigationBarTitleDeeperThanWeCanHandleNoReallyThisIsDeep {
    return tr(@"Localizable", @"settings.navigation-bar.title.deeper.than.we.can.handle.no.really.this.is.deep", @"DeepSettings");
}
+ (NSString*)settingsNavigationBarTitleEvenDeeper {
    return tr(@"Localizable", @"settings.navigation-bar.title.even.deeper", @"Settings");
}
+ (NSString*)settingsUserProfileSectionFooterText {
    return tr(@"Localizable", @"settings.user__profile_section.footer_text", @"Here you can change some user profile settings.");
}
+ (NSString*)settingsUserProfileSectionHEADERTITLE {
    return tr(@"Localizable", @"settings.user__profile_section.HEADER_TITLE", @"User Profile Settings");
}
+ (NSString*)whatHappensHere {
    return tr(@"Localizable", @"what./*happens*/.here", @"hello world! /* still in string */");
}
@end

