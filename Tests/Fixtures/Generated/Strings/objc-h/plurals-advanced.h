// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocPluralAdvanced : NSObject
// mixed.placeholders-and-variables.positionalstring-positional3int --> "Plural format key: "%1$@ %3$#@has_rating@""
+ (NSString*)mixedPlaceholdersAndVariablesPositionalstringPositional3intWithValues:(id)p1 :(NSInteger)p2;
// mixed.placeholders-and-variables.string-int --> "Plural format key: "%@ %#@has_rating@""
+ (NSString*)mixedPlaceholdersAndVariablesStringIntWithValues:(id)p1 :(NSInteger)p2;
// mixed.placeholders-and-variables.string-positional2int --> "Plural format key: "%@ %2$#@has_rating@""
+ (NSString*)mixedPlaceholdersAndVariablesStringPositional2intWithValues:(id)p1 :(NSInteger)p2;
// mixed.placeholders-and-variables.string-positional3int --> "Plural format key: "%@ %3$#@has_rating@""
+ (NSString*)mixedPlaceholdersAndVariablesStringPositional3intWithValues:(id)p1 :(NSInteger)p2;
// multiple.placeholders-and-variables.int-string-string --> "Plural format key: "Your %3$@ list contains %1$#@first@ %2$@.""
+ (NSString*)multiplePlaceholdersAndVariablesIntStringStringWithValues:(NSInteger)p1 :(id)p2 :(id)p3;
// multiple.variables.three-variables-in-formatkey --> "Plural format key: "%#@files@ (%#@bytes@, %#@minutes@)""
+ (NSString*)multipleVariablesThreeVariablesInFormatkeyWithValues:(NSInteger)p1 :(NSInteger)p2 :(NSInteger)p3;
@end


NS_ASSUME_NONNULL_END
