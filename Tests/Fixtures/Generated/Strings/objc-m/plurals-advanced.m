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

@implementation LocPluralAdvanced : NSObject
+ (NSString*)multiplePlaceholdersAndVariablesIntStringStringWithValues:(void*)p1 :(id)p2 :(id)p3 :(NSInteger)p4
{
    return tr(@"LocPluralAdvanced", @"multiple.placeholders-and-variables.int-string-string", p1, p2, p3, p4);
}
+ (NSString*)multiplePlaceholdersAndVariablesStringIntWithValues:(id)p1 :(NSInteger)p2
{
    return tr(@"LocPluralAdvanced", @"multiple.placeholders-and-variables.string-int", p1, p2);
}
+ (NSString*)multipleVariablesThreeVariablesInFormatkeyWithValues:(NSInteger)p1 :(NSInteger)p2 :(NSInteger)p3
{
    return tr(@"LocPluralAdvanced", @"multiple.variables.three-variables-in-formatkey", p1, p2, p3);
}
@end

