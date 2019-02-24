// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen
// Template 'objc-string-h' by Eric Slosser

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface Localizable : NSObject
+ (NSString*)alertMessage; // alert_message --> "Some alert body there"
+ (NSString*)alertTitle; // alert_title --> "Title of the alert"
+ (NSString*)objectOwnership:(NSInteger)p1 and:(NSString*)p2 and:(NSString*)p3;  // ObjectOwnership --> "These are %3$@'s %1$d %2$@."
+ (NSString*)percent; // percent --> "This is a %% character."
+ (NSString*)private:(NSString*)p1 and:(NSInteger)p2;  // private --> "Hello, my name is %@ and I'm %d"
+ (NSString*)types:(NSString*)p1 and:(char)p2 and:(NSInteger)p3 and:(float)p4 and:(char*)p5 and:(void*)p6;  // types --> "Object: '%@', Character: '%c', Integer: '%d', Float: '%f', CString: '%s', Pointer: '%p'"
+ (NSString*)applesCount:(NSInteger)p1;  // apples.count --> "You have %d apples"
+ (NSString*)bananasOwner:(NSInteger)p1 and:(NSString*)p2;  // bananas.owner --> "Those %d bananas belong to %@."
+ (NSString*)settingsNavigationBarSelf; // settings.navigation-bar.self --> "Some Reserved Keyword there"
+ (NSString*)settingsNavigationBarTitleDeeperThanWeCanHandleNoReallyThisIsDeep; // settings.navigation-bar.title.deeper.than.we.can.handle.no.really.this.is.deep --> "DeepSettings"
+ (NSString*)settingsNavigationBarTitleEvenDeeper; // settings.navigation-bar.title.even.deeper --> "Settings"
+ (NSString*)settingsUserProfileSectionFooterText; // settings.user_profile_section.footer_text --> "Here you can change some user profile settings."
+ (NSString*)settingsUserProfileSectionHEADERTITLE; // settings.user_profile_section.HEADER_TITLE --> "User Profile Settings"
@end


NS_ASSUME_NONNULL_END
