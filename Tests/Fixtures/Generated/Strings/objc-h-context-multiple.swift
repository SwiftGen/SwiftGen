// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface Localizable : NSObject
+ (NSString*)alertMessage; // alert_message --> "Some alert body there"
+ (NSString*)alertTitle; // alert_title --> "Title of the alert"
+ (NSString*)objectOwnership:(NSInteger)p1 and:(NSString*)p2 and:(NSString*)p3;  // These are %3$@'s %1$d %2$@.
+ (NSString*)private:(NSString*)p1 and:(NSInteger)p2;  // Hello, my name is %@ and I'm %d
+ (NSString*)applesCount:(NSInteger)p1;  // You have %d apples
+ (NSString*)bananasOwner:(NSInteger)p1 and:(NSString*)p2;  // Those %d bananas belong to %@.
+ (NSString*)settingsNavigationBarSelf; // settings.navigation-bar.self --> "Some Reserved Keyword there"
+ (NSString*)settingsNavigationBarTitleDeeperThanWeCanHandleNoReallyThisIsDeep; // settings.navigation-bar.title.deeper.than.we.can.handle.no.really.this.is.deep --> "DeepSettings"
+ (NSString*)settingsNavigationBarTitleEvenDeeper; // settings.navigation-bar.title.even.deeper --> "Settings"
+ (NSString*)seTTingsUSerProFileSectioNFooterText; // seTTings.uSer-proFile-sectioN.footer_text --> "Here you can change some user profile settings."
+ (NSString*)settingsUserProfileSectionHeaderTitle; // SETTINGS.USER_PROFILE_SECTION.HEADER_TITLE --> "User Profile Settings"
@end

@interface LocMultiline : NSObject
+ (NSString*)multiline; // MULTILINE --> "multi\nline"
+ (NSString*)multiLineNKey; // multiLine\nKey --> "test"
+ (NSString*)multiline2; // MULTILINE2 --> "another\nmulti\n    line"
+ (NSString*)singleline; // SINGLELINE --> "single line"
+ (NSString*)singleline2; // SINGLELINE2 --> "another single line"
@end


NS_ASSUME_NONNULL_END
