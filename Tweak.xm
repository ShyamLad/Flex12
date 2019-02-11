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

static NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kSettingsPath];

static void respring(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
  [[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];
}

static void addDarwinObserver(CFNotificationCallback callBack, CFStringRef name) {
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, callBack, name,
                                  NULL, 0);
}

static bool GetPrefBool(NSString *key)
{
  //Return NO for FLXLocked by default
  BOOL defaultBool = [key isEqualToString:@"FLXLocked"] ? NO : YES;
  NSLog(@"The bool value for %@ is %@", key, [[prefs valueForKey:key] boolValue]);
 return [prefs valueForKey:key]? [[prefs valueForKey:key] boolValue] : defaultBool;

}

static double GetScaleFor(NSString *key) {
  // Return 2 by default
  NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kSettingsPath];
  return [prefs valueForKey:key] ? [[prefs valueForKey:key] doubleValue] : 2;
}

%hook UIWindow
- (BOOL)_shouldCreateContextAsSecure {
  if (GetPrefBool(@"FLXLocked")) {
    return [self isKindOfClass:%c(FLEXWindow)] ? YES : %orig;
  }
  return %orig;
}
%end


%hook _UIStatusBarForegroundView

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  // NSLog(@"FLEXing12: We are touching");
  if (GetPrefBool(@"FLXEnabled")) {
    UITouch *currentTouch = [touches anyObject];
    CGFloat currentForce = currentTouch.force;
    // NSLog(@"forceForward: The Current Force is: %@", @(currentForce));

    float toggleForce = GetScaleFor(@"FLXForce");
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
  addDarwinObserver(&respring, CFSTR("respring"));
}
