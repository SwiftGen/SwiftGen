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
    NSString *format = [bundle localizedStringForKey:key value:@"" table:tableName];

    va_list args;
    va_start(args, key);
    NSString *result = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);

    return result;
};
#pragma clang diagnostic pop

@implementation LocPluralUnsupported : NSObject
+ (NSString*)unsupportedUsePlaceholdersInVariableRuleStringIntWithValue:(NSInteger)p1
{
    return tr(@"LocPluralUnsupported", @"unsupported-use.placeholders-in-variable-rule.string-int", p1);
}
@end

