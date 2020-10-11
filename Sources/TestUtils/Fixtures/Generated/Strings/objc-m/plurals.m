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
+ (NSString*)applesCountWithValue:(NSInteger)p1
{
    return tr(@"Localizable", @"apples.count", p1);
}
+ (NSString*)competitionEventNumberOfMatchesWithValue:(NSInteger)p1
{
    return tr(@"Localizable", @"competition.event.number-of-matches", p1);
}
+ (NSString*)feedSubscriptionCountWithValue:(NSInteger)p1
{
    return tr(@"Localizable", @"feed.subscription.count", p1);
}
@end

