// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocPluralAdvanced : NSObject
// multiple.placeholders-and-variables.int-string-string --> "Plural format key: "Your %3$#@third@ list contains %1$#@first@ %2$#@second@.""
+ (NSString*)multiplePlaceholdersAndVariablesIntStringStringWithValues:(NSInteger)p1 :(id)p2 :(id)p3;
// multiple.placeholders-and-variables.string-int --> "Plural format key: "%#@element@ %#@has_rating@""
+ (NSString*)multiplePlaceholdersAndVariablesStringIntWithValues:(id)p1 :(NSInteger)p2;
// multiple.variables.three-variables-in-formatkey --> "Plural format key: "%#@files@ (%#@bytes@, %#@minutes@)""
+ (NSString*)multipleVariablesThreeVariablesInFormatkeyWithValues:(NSInteger)p1 :(NSInteger)p2 :(NSInteger)p3;
@end


NS_ASSUME_NONNULL_END
