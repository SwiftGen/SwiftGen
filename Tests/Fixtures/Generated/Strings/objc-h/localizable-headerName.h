// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Localizable : NSObject
// alert__message --> "Some alert body there"
+ (NSString*)alertMessage;
// alert__title --> "Title of the alert"
+ (NSString*)alertTitle;
// ObjectOwnership --> "These are %3$@'s %1$d %2$@."
+ (NSString*)objectOwnership:(NSInteger)p1 and:(id)p2 and:(id)p3;
// percent --> "This is a %% character."
+ (NSString*)percent;
// private --> "Hello, my name is %@ and I'm %d"
+ (NSString*)private:(id)p1 and:(NSInteger)p2;
// types --> "Object: '%@', Character: '%c', Integer: '%d', Float: '%f', CString: '%s', Pointer: '%p'"
+ (NSString*)types:(id)p1 and:(char)p2 and:(NSInteger)p3 and:(float)p4 and:(char*)p5 and:(void*)p6;
// apples.count --> "You have %d apples"
+ (NSString*)applesCount:(NSInteger)p1;
// bananas.owner --> "Those %d bananas belong to %@."
+ (NSString*)bananasOwner:(NSInteger)p1 and:(id)p2;
// settings.navigation-bar.self --> "Some Reserved Keyword there"
+ (NSString*)settingsNavigationBarSelf;
// settings.navigation-bar.title.deeper.than.we.can.handle.no.really.this.is.deep --> "DeepSettings"
+ (NSString*)settingsNavigationBarTitleDeeperThanWeCanHandleNoReallyThisIsDeep;
// settings.navigation-bar.title.even.deeper --> "Settings"
+ (NSString*)settingsNavigationBarTitleEvenDeeper;
// settings.user__profile_section.footer_text --> "Here you can change some user profile settings."
+ (NSString*)settingsUserProfileSectionFooterText;
// settings.user__profile_section.HEADER_TITLE --> "User Profile Settings"
+ (NSString*)settingsUserProfileSectionHEADERTITLE;
@end


NS_ASSUME_NONNULL_END
