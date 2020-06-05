// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocPluralAdvanced : NSObject
// multiple.placeholders-and-variables.int-string-string --> "Plural format key: "Your %3$@ list contains %1$#@first@ %2$@.""
+ (NSString*)multiplePlaceholdersAndVariablesIntStringStringWithValues:(void*)p1 :(id)p2 :(id)p3 :(NSInteger)p4;
// multiple.placeholders-and-variables.string-int --> "Plural format key: "%@ %#@has_rating@""
+ (NSString*)multiplePlaceholdersAndVariablesStringIntWithValues:(id)p1 :(NSInteger)p2;
// multiple.variables.three-variables-in-formatkey --> "Plural format key: "%#@files@ (%#@bytes@, %#@minutes@)""
+ (NSString*)multipleVariablesThreeVariablesInFormatkeyWithValues:(NSInteger)p1 :(NSInteger)p2 :(NSInteger)p3;
@end


NS_ASSUME_NONNULL_END
