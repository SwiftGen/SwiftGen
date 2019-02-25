// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen
// Template 'objc-string-h' by Eric Slosser

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface Localizable : NSObject
+ (NSString*)alertMessage; // alert__message --> "Some alert body there"
+ (NSString*)alertTitle; // alert__title --> "Title of the alert"
+ (NSString*)objectOwnership:(NSInteger)p1 and:(NSString*)p2 and:(NSString*)p3;  // ObjectOwnership --> "These are %3$@'s %1$d %2$@."
+ (NSString*)percent; // percent --> "This is a %% character."
+ (NSString*)private:(NSString*)p1 and:(NSInteger)p2;  // private --> "Hello, my name is %@ and I'm %d"
+ (NSString*)types:(NSString*)p1 and:(char)p2 and:(NSInteger)p3 and:(float)p4 and:(char*)p5 and:(void*)p6;  // types --> "Object: '%@', Character: '%c', Integer: '%d', Float: '%f', CString: '%s', Pointer: '%p'"
+ (NSString*)applesCount:(NSInteger)p1;  // apples.count --> "You have %d apples"
+ (NSString*)bananasOwner:(NSInteger)p1 and:(NSString*)p2;  // bananas.owner --> "Those %d bananas belong to %@."
+ (NSString*)settingsNavigationBarSelf; // settings.navigation-bar.self --> "Some Reserved Keyword there"
+ (NSString*)settingsNavigationBarTitleDeeperThanWeCanHandleNoReallyThisIsDeep; // settings.navigation-bar.title.deeper.than.we.can.handle.no.really.this.is.deep --> "DeepSettings"
+ (NSString*)settingsNavigationBarTitleEvenDeeper; // settings.navigation-bar.title.even.deeper --> "Settings"
+ (NSString*)settingsUserProfileSectionFooterText; // settings.user__profile_section.footer_text --> "Here you can change some user profile settings."
+ (NSString*)settingsUserProfileSectionHEADERTITLE; // settings.user__profile_section.HEADER_TITLE --> "User Profile Settings"
@end

@interface LocMultiline : NSObject
+ (NSString*)multiline; // MULTILINE --> "multi\nline"
+ (NSString*)multiLineNKey; // multiLine\nKey --> "test"
+ (NSString*)multiline2; // MULTILINE2 --> "another\nmulti\n    line"
+ (NSString*)singleline; // SINGLELINE --> "single line"
+ (NSString*)singleline2; // SINGLELINE2 --> "another single line"
+ (NSString*)endingWith; // ending.with. --> "Ceci n'est pas une pipe."
+ (NSString*)someDotsAndEmptyComponents; // ..some..dots.and..empty..components.. --> "Veni, vidi, vici"
@end


NS_ASSUME_NONNULL_END
