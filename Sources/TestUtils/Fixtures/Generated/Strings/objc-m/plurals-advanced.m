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
    return tr(@"LocPluralAdvanced", @"many.placeholders.plurals.base", @"Plural format key: \"%@ - %#@d2@ - %#@f3@ - %5$#@d5@ - %04$#@f4@ - %6$#@d6@ - %007$@ - %8$3.2#@f8@ - %11$#@f11@ - %9$@ - %10$#@d10@\"", p1, p2, p3, p4, p5, p6, p7, p8, p9, p10);
}
+ (NSString*)manyPlaceholdersPluralsZeroWithValues:(id)p1 :(NSInteger)p2 :(float)p3 :(float)p4 :(NSInteger)p5 :(NSInteger)p6 :(id)p7 :(id)p8 :(NSInteger)p9 :(float)p10
{
    return tr(@"LocPluralAdvanced", @"many.placeholders.plurals.zero", @"Plural format key: \"%@ - %#@d2@ - %0$#@zero@ - %#@f3@ - %5$#@d5@ - %04$#@f4@ - %6$#@d6@ - %007$@ - %8$3.2#@f8@ - %11$#@f11@ - %9$@ - %10$#@d10@\"", p1, p2, p3, p4, p5, p6, p7, p8, p9, p10);
}
+ (NSString*)mixedPlaceholdersAndVariablesPositionalstringPositional3intWithValues:(id)p1 :(NSInteger)p2
{
    return tr(@"LocPluralAdvanced", @"mixed.placeholders-and-variables.positionalstring-positional3int", @"Plural format key: \"%1$@ %3$#@has_rating@\"", p1, p2);
}
+ (NSString*)mixedPlaceholdersAndVariablesStringIntWithValues:(id)p1 :(NSInteger)p2
{
    return tr(@"LocPluralAdvanced", @"mixed.placeholders-and-variables.string-int", @"Plural format key: \"%@ %#@has_rating@\"", p1, p2);
}
+ (NSString*)mixedPlaceholdersAndVariablesStringPositional2intWithValues:(id)p1 :(NSInteger)p2
{
    return tr(@"LocPluralAdvanced", @"mixed.placeholders-and-variables.string-positional2int", @"Plural format key: \"%@ %2$#@has_rating@\"", p1, p2);
}
+ (NSString*)mixedPlaceholdersAndVariablesStringPositional3intWithValues:(id)p1 :(NSInteger)p2
{
    return tr(@"LocPluralAdvanced", @"mixed.placeholders-and-variables.string-positional3int", @"Plural format key: \"%@ %3$#@has_rating@\"", p1, p2);
}
+ (NSString*)multiplePlaceholdersAndVariablesIntStringStringWithValues:(NSInteger)p1 :(id)p2 :(id)p3
{
    return tr(@"LocPluralAdvanced", @"multiple.placeholders-and-variables.int-string-string", @"Plural format key: \"Your %3$@ list contains %1$#@first@ %2$@.\"", p1, p2, p3);
}
+ (NSString*)multipleVariablesThreeVariablesInFormatkeyWithValues:(NSInteger)p1 :(NSInteger)p2 :(NSInteger)p3
{
    return tr(@"LocPluralAdvanced", @"multiple.variables.three-variables-in-formatkey", @"Plural format key: \"%#@files@ (%#@bytes@, %#@minutes@)\"", p1, p2, p3);
}
@end

