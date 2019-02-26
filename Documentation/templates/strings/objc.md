## Template Information

| Name      | Description       |
| --------- | ----------------- |
| File names | strings/objc-string-h.stencil & strings/objc-string-m.stencil |
| Configuration example | <pre>strings:<br />  inputs: path/to/Localizable.strings<br />  outputs:<br />    templateName: objc-string-h<br />    output: Localizable.h</pre><br />    templateName: objc-string-m<br />    output: Localizable.m</pre> |
| Language | ObjectiveC |
| Author | Eric Slosser |

## When to use it

- When you need to generate *ObjectiveC* code.

## Customization

You can customize some elements of this template by overriding the following parameters when invoking `swiftgen`. See the [dedicated documentation](../../ConfigFile.md).

| Parameter Name | Default Value | Description |
| -------------- | ------------- | ----------- |
| `noComments`   | N/A           | Setting this parameter will disable the comments describing the translation of a key. |


## Generated Code

**Extract:**

```swift
@interface Localizable : NSObject
// alert__message --> "Some alert body there"
+ (NSString*)alertMessage;
// alert__title --> "Title of the alert"
+ (NSString*)alertTitle;
// ObjectOwnership --> "These are %3$@'s %1$d %2$@."
+ (NSString*)objectOwnership:(NSInteger)p1 and:(NSString*)p2 and:(NSString*)p3;
// percent --> "This is a %% character."
+ (NSString*)percent;
...
@end
```

[Full generated code](../../../Tests/Fixtures/Generated/Strings/objc-m/localizable.m)

## Usage example

```objc
// simple strings
NSString* message = Localizable.alertMessage
NSString* title = Localizable.alertTitle

// with parameters, note that each argument needs to be of the correct type
NSString*  apples = [Localizable.applesCount:3];
NSString*  bananas = [Localizable.bananasOwner:5 and:@"Olivier"];
```
