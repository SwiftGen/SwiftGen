// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocPluralAdvanced : NSObject
/// %d twos
+ (NSString*)manyPlaceholdersPluralsBaseWithValues:(id)p1 :(NSInteger)p2 :(float)p3 :(float)p4 :(NSInteger)p5 :(NSInteger)p6 :(id)p7 :(id)p8 :(NSInteger)p9 :(float)p10;
/// %d twos
+ (NSString*)manyPlaceholdersPluralsZeroWithValues:(id)p1 :(NSInteger)p2 :(float)p3 :(float)p4 :(NSInteger)p5 :(NSInteger)p6 :(id)p7 :(id)p8 :(NSInteger)p9 :(float)p10;
/// has %d ratings
+ (NSString*)mixedPlaceholdersAndVariablesPositionalstringPositional3intWithValues:(id)p1 :(NSInteger)p2;
/// has %d ratings
+ (NSString*)mixedPlaceholdersAndVariablesStringIntWithValues:(id)p1 :(NSInteger)p2;
/// has %d ratings
+ (NSString*)mixedPlaceholdersAndVariablesStringPositional2intWithValues:(id)p1 :(NSInteger)p2;
/// has %d ratings
+ (NSString*)mixedPlaceholdersAndVariablesStringPositional3intWithValues:(id)p1 :(NSInteger)p2;
/// %1$d items. You should buy them
+ (NSString*)multiplePlaceholdersAndVariablesIntStringStringWithValues:(NSInteger)p1 :(id)p2 :(id)p3;
/// %d files remaining
+ (NSString*)multipleVariablesThreeVariablesInFormatkeyWithValues:(NSInteger)p1 :(NSInteger)p2 :(NSInteger)p3;
@end


NS_ASSUME_NONNULL_END
