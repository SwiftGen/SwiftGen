* // Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface Localizable : NSObject
+ (NSString*)alertMessage; // alert__message --> "Some alert body there"
+ (NSString*)alertTitle; // alert__title --> "Title of the alert"
// ObjectOwnership --> "These are %3$@'s %1$d %2$@."
+ (NSString*)objectOwnership:(NSInteger)p1 and:(NSString*)p2 and:(NSString*)p3;
+ (NSString*)percent; // percent --> "This is a %% character."
// private --> "Hello, my name is %@ and I'm %d"
+ (NSString*)private:(NSString*)p1 and:(NSInteger)p2;
// types --> "Object: '%@', Character: '%c', Integer: '%d', Float: '%f', CString: '%s', Pointer: '%p'"
+ (NSString*)types:(NSString*)p1 and:(char)p2 and:(NSInteger)p3 and:(float)p4 and:(char*)p5 and:(void*)p6;
// apples.count --> "You have %d apples"
+ (NSString*)applesCount:(NSInteger)p1;
// bananas.owner --> "Those %d bananas belong to %@."
+ (NSString*)bananasOwner:(NSInteger)p1 and:(NSString*)p2;
+ (NSString*)settingsNavigationBarSelf; // settings.navigation-bar.self --> "Some Reserved Keyword there"
+ (NSString*)settingsNavigationBarTitleDeeperThanWeCanHandleNoReallyThisIsDeep; // settings.navigation-bar.title.deeper.than.we.can.handle.no.really.this.is.deep --> "DeepSettings"
+ (NSString*)settingsNavigationBarTitleEvenDeeper; // settings.navigation-bar.title.even.deeper --> "Settings"
+ (NSString*)settingsUserProfileSectionFooterText; // settings.user__profile_section.footer_text --> "Here you can change some user profile settings."
+ (NSString*)settingsUserProfileSectionHEADERTITLE; // settings.user__profile_section.HEADER_TITLE --> "User Profile Settings"
@end


NS_ASSUME_NONNULL_END
