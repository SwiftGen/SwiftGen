* // Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen


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

@implementation Localizable : NSObject
+ (NSString*)alertMessage {
    return tr(@"alert__message");
}
+ (NSString*)alertTitle {
    return tr(@"alert__title");
}
+ (NSString*)objectOwnership:(NSInteger)p1 and:(NSString*)p2 and:(NSString*)p3
{
    return tr(@"ObjectOwnership", p1, p2, p3);
}
+ (NSString*)percent {
    return tr(@"percent");
}
+ (NSString*)private:(NSString*)p1 and:(NSInteger)p2
{
    return tr(@"private", p1, p2);
}
+ (NSString*)types:(NSString*)p1 and:(char)p2 and:(NSInteger)p3 and:(float)p4 and:(char*)p5 and:(void*)p6
{
    return tr(@"types", p1, p2, p3, p4, p5, p6);
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
    return tr(@"settings.user__profile_section.footer_text");
}
+ (NSString*)settingsUserProfileSectionHEADERTITLE {
    return tr(@"settings.user__profile_section.HEADER_TITLE");
}
@end

@implementation LocMultiline : NSObject
+ (NSString*)multiline {
    return tr(@"MULTILINE");
}
+ (NSString*)multiLineNKey {
    return tr(@"multiLine\nKey");
}
+ (NSString*)multiline2 {
    return tr(@"MULTILINE2");
}
+ (NSString*)singleline {
    return tr(@"SINGLELINE");
}
+ (NSString*)singleline2 {
    return tr(@"SINGLELINE2");
}
+ (NSString*)endingWith {
    return tr(@"ending.with.");
}
+ (NSString*)someDotsAndEmptyComponents {
    return tr(@"..some..dots.and..empty..components..");
}
@end

#pragma clang diagnostic pop
