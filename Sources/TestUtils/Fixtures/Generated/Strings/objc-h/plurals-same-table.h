// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Localizable : NSObject
/// Some /*alert body there
+ (NSString*)alertMessage;
/// Title for an alert 1️⃣
+ (NSString*)alertTitle;
/// value1	value
+ (NSString*)key1;
/// These are %3$@'s %1$d %2$@.
+ (NSString*)objectOwnershipWithValues:(NSInteger)p1 :(id)p2 :(id)p3;
/// This is a %% character.
+ (NSString*)percent;
/// Hello, my name is "%@" and I'm %d
+ (NSString*)privateWithValues:(id)p1 :(NSInteger)p2;
/// Object: '%@', Character: '%c', Integer: '%d', Float: '%f', CString: '%s', Pointer: '%p'
+ (NSString*)typesWithValues:(id)p1 :(char)p2 :(NSInteger)p3 :(float)p4 :(char*)p5 :(void*)p6;
/// Plural format key: "%#@apples@"
+ (NSString*)applesCountWithValue:(NSInteger)p1;
/// A comment with no space above it
+ (NSString*)bananasOwnerWithValues:(NSInteger)p1 :(id)p2;
/// Plural format key: "%#@Matches@"
+ (NSString*)competitionEventNumberOfMatchesWithValue:(NSInteger)p1;
/// Plural format key: "%#@Subscriptions@"
+ (NSString*)feedSubscriptionCountWithValue:(NSInteger)p1;
/// Same as "key1" = "value1"; but in the context of user not logged in
+ (NSString*)key1Anonymous;
/// %@ %d %f %5$d %04$f %6$d %007$@ %8$3.2f %11$1.2f %9$@ %10$d
+ (NSString*)manyPlaceholdersBaseWithValues:(id)p1 :(NSInteger)p2 :(float)p3 :(float)p4 :(NSInteger)p5 :(NSInteger)p6 :(id)p7 :(float)p8 :(id)p9 :(NSInteger)p10 :(float)p11;
/// %@ %d %0$@ %f %5$d %04$f %6$d %007$@ %8$3.2f %11$1.2f %9$@ %10$d
+ (NSString*)manyPlaceholdersZeroWithValues:(id)p1 :(NSInteger)p2 :(float)p3 :(float)p4 :(NSInteger)p5 :(NSInteger)p6 :(id)p7 :(float)p8 :(id)p9 :(NSInteger)p10 :(float)p11;
/// Some Reserved Keyword there👍🏽
+ (NSString*)settingsNavigationBarSelf_️;
/// DeepSettings
+ (NSString*)settingsNavigationBarTitleDeeperThanWeCanHandleNoReallyThisIsDeep;
/// Settings
+ (NSString*)settingsNavigationBarTitleEvenDeeper;
/// Here you can change some user profile settings.
+ (NSString*)settingsUserProfileSectionFooterText;
/// User Profile Settings
+ (NSString*)settingsUserProfileSectionHEADERTITLE;
/// some comment 👨‍👩‍👧‍👦
+ (NSString*)whatHappensHere;
@end


NS_ASSUME_NONNULL_END
