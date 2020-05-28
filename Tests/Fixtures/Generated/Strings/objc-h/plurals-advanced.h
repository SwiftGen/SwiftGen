// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocPluralAdvanced : NSObject
// multiple.placeholders.string-int --> "Plural case 'other': %@ has %d ratings"
+ (NSString*)multiplePlaceholdersStringIntWithValue:(NSInteger)p1;
// multiple.placeholders-and-variables.int-string-string --> "Plural case 'other': Your %3$@ list contains %1$d items. You should buy them %2$@."
+ (NSString*)multiplePlaceholdersAndVariablesIntStringStringWithValues:(NSInteger)p1 :(id)p2 :(id)p3;
// multiple.placeholders-and-variables.string-int --> "Plural case 'other': %@ has %d ratings"
+ (NSString*)multiplePlaceholdersAndVariablesStringIntWithValues:(id)p1 :(NSInteger)p2;
// multiple.variables.three-variables-in-formatkey --> "Plural case 'other': %d files remaining (%d bytes, %d minutes)"
+ (NSString*)multipleVariablesThreeVariablesInFormatkeyWithValues:(NSInteger)p1 :(NSInteger)p2 :(NSInteger)p3;
@end


NS_ASSUME_NONNULL_END
