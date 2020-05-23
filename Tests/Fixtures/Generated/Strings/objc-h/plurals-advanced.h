// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocPluralAdvanced : NSObject
// multiple.placeholders.string-int --> "Plural case 'other': %@ has %d ratings"
+ (NSString*)multiplePlaceholdersStringIntWithValue:(NSInteger)p1;
// multiple.variables.three-variables-in-formatkey --> "Plural case 'other': %d files remaining (%d bytes, %d minutes)"
+ (NSString*)multipleVariablesThreeVariablesInFormatkeyWithValues:(NSInteger)p1 :(NSInteger)p2 :(NSInteger)p3;
// nested.formatkey-in-variable --> "Plural case 'other': %1$#@geese@"
+ (NSString*)nestedFormatkeyInVariableWithValues:(NSInteger)p1 :(NSInteger)p2 :(NSInteger)p3;
// nested.formatkey-in-variable-deep --> "Plural case 'other': %1$#@first_level@"
+ (NSString*)nestedFormatkeyInVariableDeepWithValues:(NSInteger)p1 :(NSInteger)p2 :(NSInteger)p3;
@end


NS_ASSUME_NONNULL_END
