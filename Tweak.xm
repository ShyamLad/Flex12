//
//  FLEX12
//
//  Created by Shyam Lad
//  Copyright © 2019 Shyam Lad. All rights reserved.
//

#import "FLEXManager.h"
#import "FLEX12.h"
#import <AudioToolbox/AudioToolbox.h>
#define kSettingsPath [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.ladshyam.FLEX12.plist"]

static BOOL hasBeenForceTapped = NO;
static BOOL enabled = YES;
static BOOL enabled_Locked = NO;
static BOOL enabled_LongPress = YES;
static float FLXForce = 2;


@interface NSUserDefaults (Tweak_Category)
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
- (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end

static NSString *nsDomainString = @"com.ladshyam.FLEX12";
static NSString *nsNotificationString = @"com.ladshyam.FLEX12/preferences.changed";

static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	NSNumber *n1 = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"FLXEnabled" inDomain:nsDomainString];
	enabled = (n1)? [n1 boolValue]:YES;
  NSNumber *n2 = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"FLXLocked" inDomain:nsDomainString];
  enabled_Locked = (n2)? [n2 boolValue]:YES;
  NSNumber *n3 = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"FLXForce" inDomain:nsDomainString];
  FLXForce = (n3)? [n3 floatValue]:2;
  NSNumber *n4 = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"FLXLongPress" inDomain:nsDomainString];
	enabled_LongPress = (n4)? [n4 boolValue]:YES;
}


static void respring(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
  [[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];
}



%hook UIWindow
- (BOOL)_shouldCreateContextAsSecure {
  if (enabled_Locked) {
    return [self isKindOfClass:%c(FLEXWindow)] ? YES : %orig;
  }
  return %orig;
}
%end



%hook _UIStatusBar
-(void)layoutSubviews {
  %orig;
  if(enabled_LongPress) {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(handleLongPress:)];
          longPress.minimumPressDuration = 2.0;
          [self addGestureRecognizer:longPress];
    }
}

%new -(void)handleLongPress:(UILongPressGestureRecognizer*)recognizer{
    if([recognizer state] == UIGestureRecognizerStateBegan) {
      AudioServicesPlaySystemSound(1520);
      [[FLEXManager sharedManager] showExplorer];
    }
}

%end
%hook _UIStatusBarForegroundView

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  // NSLog(@"FLEXing12: We are touching");
  if (enabled) {
    UITouch *currentTouch = [touches anyObject];
    CGFloat currentForce = currentTouch.force;
    // NSLog(@"forceForward: The Current Force is: %@", @(currentForce));

    float toggleForce = FLXForce;
    if(currentForce < toggleForce) {
      hasBeenForceTapped = NO;
    }

    // HBLogDebug(@"hasBeenForceTapped: %d", hasBeenForceTapped);
    if (currentForce >= toggleForce && !(hasBeenForceTapped)) {
      hasBeenForceTapped = YES;
      AudioServicesPlaySystemSound(1520);
      [[FLEXManager sharedManager] showExplorer];

      }
    }
  %orig(touches,event);
}


%end
%ctor{

  NSLog(@"Loading Flex");
  notificationCallback(NULL, NULL, NULL, NULL, NULL);

  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
    NULL,
    &respring,
    CFSTR("respring"),
    NULL, 0);

	// Register for 'PostNotification' notifications
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
		NULL,
		notificationCallback,
		(CFStringRef)nsNotificationString,
		NULL,
		CFNotificationSuspensionBehaviorCoalesce);
}
