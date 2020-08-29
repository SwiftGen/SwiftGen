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

@implementation LocPluralAdvanced : NSObject
+ (NSString*)manyPlaceholdersPluralsBaseWithValues:(id)p1 :(NSInteger)p2 :(float)p3 :(float)p4 :(NSInteger)p5 :(NSInteger)p6 :(id)p7 :(id)p8 :(NSInteger)p9 :(float)p10
{
    return tr(@"LocPluralAdvanced", @"many.placeholders.plurals.base", p1, p2, p3, p4, p5, p6, p7, p8, p9, p10);
}
+ (NSString*)manyPlaceholdersPluralsZeroWithValues:(id)p1 :(NSInteger)p2 :(float)p3 :(float)p4 :(NSInteger)p5 :(NSInteger)p6 :(id)p7 :(id)p8 :(NSInteger)p9 :(float)p10
{
    return tr(@"LocPluralAdvanced", @"many.placeholders.plurals.zero", p1, p2, p3, p4, p5, p6, p7, p8, p9, p10);
}
+ (NSString*)mixedPlaceholdersAndVariablesPositionalstringPositional3intWithValues:(id)p1 :(NSInteger)p2
{
    return tr(@"LocPluralAdvanced", @"mixed.placeholders-and-variables.positionalstring-positional3int", p1, p2);
}
+ (NSString*)mixedPlaceholdersAndVariablesStringIntWithValues:(id)p1 :(NSInteger)p2
{
    return tr(@"LocPluralAdvanced", @"mixed.placeholders-and-variables.string-int", p1, p2);
}
+ (NSString*)mixedPlaceholdersAndVariablesStringPositional2intWithValues:(id)p1 :(NSInteger)p2
{
    return tr(@"LocPluralAdvanced", @"mixed.placeholders-and-variables.string-positional2int", p1, p2);
}
+ (NSString*)mixedPlaceholdersAndVariablesStringPositional3intWithValues:(id)p1 :(NSInteger)p2
{
    return tr(@"LocPluralAdvanced", @"mixed.placeholders-and-variables.string-positional3int", p1, p2);
}
+ (NSString*)multiplePlaceholdersAndVariablesIntStringStringWithValues:(NSInteger)p1 :(id)p2 :(id)p3
{
    return tr(@"LocPluralAdvanced", @"multiple.placeholders-and-variables.int-string-string", p1, p2, p3);
}
+ (NSString*)multipleVariablesThreeVariablesInFormatkeyWithValues:(NSInteger)p1 :(NSInteger)p2 :(NSInteger)p3
{
    return tr(@"LocPluralAdvanced", @"multiple.variables.three-variables-in-formatkey", p1, p2, p3);
}
@end

