// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#import "Localizable.h"

@interface BundleToken : NSObject
@end

@implementation BundleToken
@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wformat-security"

static NSString* tr(NSString *tableName, NSString *key, NSString *value, ...) {
    NSBundle *bundle = [NSBundle bundleForClass:BundleToken.class];
    NSString *format = [bundle localizedStringForKey:key value:value table:tableName];
    NSLocale *locale = [NSLocale currentLocale];

    va_list args;
    va_start(args, value);
    NSString *result = [[NSString alloc] initWithFormat:format locale:locale arguments:args];
    va_end(args);

    return result;
};
#pragma clang diagnostic pop

@implementation LocPluralAdvanced : NSObject
+ (NSString*)manyPlaceholdersPluralsBaseWithValues:(id)p1 :(NSInteger)p2 :(float)p3 :(float)p4 :(NSInteger)p5 :(NSInteger)p6 :(id)p7 :(id)p8 :(NSInteger)p9 :(float)p10
{
    return tr(@"LocPluralAdvanced", @"many.placeholders.plurals.base", @"%d twos", p1, p2, p3, p4, p5, p6, p7, p8, p9, p10);
}
+ (NSString*)manyPlaceholdersPluralsZeroWithValues:(id)p1 :(NSInteger)p2 :(float)p3 :(float)p4 :(NSInteger)p5 :(NSInteger)p6 :(id)p7 :(id)p8 :(NSInteger)p9 :(float)p10
{
    return tr(@"LocPluralAdvanced", @"many.placeholders.plurals.zero", @"%d twos", p1, p2, p3, p4, p5, p6, p7, p8, p9, p10);
}
+ (NSString*)mixedPlaceholdersAndVariablesPositionalstringPositional3intWithValues:(id)p1 :(NSInteger)p2
{
    return tr(@"LocPluralAdvanced", @"mixed.placeholders-and-variables.positionalstring-positional3int", @"has %d ratings", p1, p2);
}
+ (NSString*)mixedPlaceholdersAndVariablesStringIntWithValues:(id)p1 :(NSInteger)p2
{
    return tr(@"LocPluralAdvanced", @"mixed.placeholders-and-variables.string-int", @"has %d ratings", p1, p2);
}
+ (NSString*)mixedPlaceholdersAndVariablesStringPositional2intWithValues:(id)p1 :(NSInteger)p2
{
    return tr(@"LocPluralAdvanced", @"mixed.placeholders-and-variables.string-positional2int", @"has %d ratings", p1, p2);
}
+ (NSString*)mixedPlaceholdersAndVariablesStringPositional3intWithValues:(id)p1 :(NSInteger)p2
{
    return tr(@"LocPluralAdvanced", @"mixed.placeholders-and-variables.string-positional3int", @"has %d ratings", p1, p2);
}
+ (NSString*)multiplePlaceholdersAndVariablesIntStringStringWithValues:(NSInteger)p1 :(id)p2 :(id)p3
{
    return tr(@"LocPluralAdvanced", @"multiple.placeholders-and-variables.int-string-string", @"%1$d items. You should buy them", p1, p2, p3);
}
+ (NSString*)multipleVariablesThreeVariablesInFormatkeyWithValues:(NSInteger)p1 :(NSInteger)p2 :(NSInteger)p3
{
    return tr(@"LocPluralAdvanced", @"multiple.variables.three-variables-in-formatkey", @"%d files remaining", p1, p2, p3);
}
@end

