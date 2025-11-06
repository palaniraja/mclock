//
//  menuItem.m
//  mclock
//
//  Created by Palaniraja on 12/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "menuItem.h"

#import <ApplicationServices/ApplicationServices.h>
#include <IOKit/pwr_mgt/IOPMLib.h>

extern OSErr UpdateSystemActivity(UInt8 activity) __attribute__((weak_import));



@implementation menuItem

IOPMAssertionID _userActivityAssertion;

- (id)init
{
    self = [super init];
//    NSLog(@"init");
    if (self) {
        // Initialization code here.
        [[NSUserDefaults standardUserDefaults] registerDefaults:    
         [NSDictionary dictionaryWithObjectsAndKeys:     
          @"IST", kZoneString,     
          @"h:mm a", kDisplayFormatString,
          [NSNumber numberWithBool:1], kDisplayZonePrefix,
          kDisplayZoneNone, kDisplayZoneByNameOptionSelected,
          nil]];
        
//        NSLog(@"Timezone abbreviation: %@", [NSTimeZone abbreviationDictionary]);
    }
    
    return self;
}

- (void)dealloc
{
    [updateTimer invalidate];
//    [statusTitle release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark -
-(void) updateLabel:(id)sender{
//    NSLog(@"updateLabel called");
    
    NSString *time2display = [NSString stringWithFormat:@"%@%@", prefix, [formatter stringFromDate:[NSDate date]]];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:time2display attributes:attribDict];
    [statusItem setAttributedTitle:attrString];
//    [statusItem setTitle:time2display];
    [self performMouseJiggleIfIdle];
}

- (void)awakeFromNib{
    
//    NSLog(@"awakefromNib");
    
    caffeinateActive = false;
    idleTimerActive = false;
    
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setHighlightMode:YES];
    [statusItem setEnabled:YES];
    [statusItem setToolTip:@"MClock"];
    [statusItem setAction:@selector(updateLabel:)];
    [statusItem setTarget:self];
    [statusItem setMenu:statusMenu];
//    statusTitle = [[NSString alloc] init];
    
//    zone = [NSString stringWithFormat:@"IST"]; //CST
//    formatString = [NSString stringWithFormat:@"h.mm a"];  //HH:MM
//    prefix = [NSString stringWithFormat:@"%@ ", zone];
    
    NSFont *font = [NSFont systemFontOfSize:[NSFont systemFontSize]];
    attribDict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    

    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatString];
    
//    NSString *timeZoneName =
    
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:zone]]; 
    
    [self reload:nil];
    
    /*
     Find difference between next min
     Set a timer to fire reload (which should invalidate the timer and call correctly)
     */
    
    NSDate *now = [NSDate date];
    NSDateFormatter *nextMinFormat = [[NSDateFormatter alloc] init];
    [nextMinFormat setDateFormat:@"s"];
    NSString *secVal = [nextMinFormat stringFromDate:now];
    
    double interval = 60.0 - [secVal doubleValue];
    
//    NSLog(@"timer to fire after %f", interval);
    
    updateTimer =[NSTimer scheduledTimerWithTimeInterval:interval
                                                  target:self
                                                selector:@selector(reload:)
                                                userInfo:nil
                                                 repeats:NO];
//    [updateTimer fire];

    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reload:) 
                                                 name:kPreferencesUpdated
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTimeAsPerSystemTime:)
                                                 name:NSSystemClockDidChangeNotification
                                               object:nil];
    
    
}

-(IBAction) showPreferences:(id)sender{
    

    if(!prefWindow){
        prefWindow = [[PreferenceWindowController alloc] init];  
    }
    
    [NSApp activateIgnoringOtherApps:YES];
    
    [prefWindow showWindow:self];

    
}


- (void) reload: (id)notification{
    
    
//    NSLog(@"reload called");
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    zone = [ud objectForKey:kZoneString];
    formatString = [ud objectForKey:kDisplayFormatString];
    
    zoneName = [ud objectForKey:kDisplayZoneByNameOptionSelected];

    if (![zoneName isEqualToString:kDisplayZoneNone]) {
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:zoneName]];
    }
    else{
        [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:zone]];
    }
    
    [formatter setDateFormat:formatString];
    
    
    if ([ud boolForKey:kDisplayZonePrefix]) {
        prefix = [NSString stringWithFormat:@"%@ ", zone];
    }else{
        prefix = [NSString stringWithFormat:@""];
    }
    
    if ([updateTimer isValid]) {
        [updateTimer invalidate];
    }
    
    
    if([ud boolForKey:kCaffeinate]) {
        [self toggleCaffeinate:true];
    }
    
    if([ud boolForKey:kAssertPreventIdleActivity]) {
        [self declareUserActivity];
    }
    NSLog(@"reload: caff: %d idle: %d", [ud boolForKey:kCaffeinate], [ud boolForKey:kAssertPreventIdleActivity]);
    
    double interval = 60.0;
    
    if ([formatString rangeOfString:@"s"].location != NSNotFound) {
        interval = 1.0;
    }
    
    updateTimer =[NSTimer scheduledTimerWithTimeInterval:interval
                                                  target:self
                                                selector:@selector(updateLabel:)
                                                userInfo:nil
                                                 repeats:YES];
    [updateTimer fire];
    
    
    [self updateLabel:nil];
    
}

- (void) updateTimeAsPerSystemTime: (NSNotification *) notify{
//    NSLog(@"updateTimeAsPerSystemTime called with %@", notify);
    [self updateLabel:nil];
    [self performMouseJiggleIfIdle];
}

#pragma  mark -
- (void)performMouseJiggleIfIdle
{
    // Check if system idle time > 58 seconds
    double idleTime = CGEventSourceSecondsSinceLastEventType(kCGEventSourceStateCombinedSessionState, kCGAnyInputEventType);
    if (idleTime <= 58.0) return;

    idleTimerActive = true;
//    NSLog(@"idletimer active");
    // Save current mouse position
    NSPoint mouseLocation = [NSEvent mouseLocation];
    NSScreen *primaryScreen = [NSScreen mainScreen];
    NSRect screenFrame = [primaryScreen frame];
    CGPoint savedMouseLocation;
    savedMouseLocation.x = mouseLocation.x;
    savedMouseLocation.y = screenFrame.size.height - mouseLocation.y;
    
    bool userInterrupt = false;

    // Generate 25 different mouse locations (avoid current)
    NSMutableArray *locations = [NSMutableArray array];
    for (int i = 0; i < 25; ++i) {
        CGPoint newLoc;
        do {
            newLoc.x = savedMouseLocation.x + arc4random_uniform(100) - 50;
            newLoc.y = savedMouseLocation.y + arc4random_uniform(100) - 50;
        } while (fabs(newLoc.x - savedMouseLocation.x) < 2 && fabs(newLoc.y - savedMouseLocation.y) < 2);
        [locations addObject:[NSValue valueWithPoint:NSMakePoint(newLoc.x, screenFrame.size.height - newLoc.y)]];
    }

    // Move mouse to each location with delay, exit if user activity detected
    for (int i = 0; i < 25; ++i) {
        double newIdleTime = CGEventSourceSecondsSinceLastEventType(kCGEventSourceStateCombinedSessionState, kCGAnyInputEventType);
        if (newIdleTime < idleTime) {
            // User activity detected, exit loop
            userInterrupt = true;
            idleTimerActive = false;
            break;
        }
        NSPoint loc = [[locations objectAtIndex:i] pointValue];
        CGPoint cgLoc;
        cgLoc.x = loc.x;
        cgLoc.y = screenFrame.size.height - loc.y;
//        NSLog(@"new pos: %.2f %.2f", cgLoc.x, cgLoc.y);
        CGEventRef event = CGEventCreateMouseEvent(NULL, kCGEventMouseMoved, cgLoc, kCGMouseButtonLeft);
        CGEventPost(kCGHIDEventTap, event);
        CFRelease(event);
        [NSThread sleepForTimeInterval:0.3];
    }

    // Restore original mouse position
    if (!userInterrupt) {
        CGEventRef restoreEvent = CGEventCreateMouseEvent(NULL, kCGEventMouseMoved, savedMouseLocation, kCGMouseButtonLeft);
        CGEventPost(kCGHIDEventTap, restoreEvent);
        CFRelease(restoreEvent);
    }
    
}


#pragma mark - caffeinate

- (IBAction)toggleCaffeinate:(bool )enabled {
    
    if (enabled) {
//        NSLog(@"toggleCaffeinate ON");
        [self spawnCaffeinateTaskForTimeInterval:0];
    } else {
//        NSLog(@"toggleCaffeinate OFF");
        [self terminateCaffeinateTask];
    }
}

- (void)spawnCaffeinateTaskForTimeInterval:(NSTimeInterval)timeInterval
{
    
    if (caffeinateActive) {
        return;
    }
    NSMutableArray<NSString *> *arguments = [NSMutableArray new];
    [arguments addObject:@"-diu"];
    if(timeInterval > 0)
    {
        [arguments addObject:[NSString stringWithFormat:@"-t %.f", timeInterval]];
    }
    [arguments addObject:[NSString stringWithFormat:@"-w %i",
                          NSProcessInfo.processInfo.processIdentifier]];

    self.caffeinateTask = [NSTask launchedTaskWithLaunchPath:@"/usr/bin/caffeinate"
                                                   arguments:[arguments copy]];

    self.caffeinateTask.terminationHandler = ^(NSTask *task) {
        // Handle termination as needed
        self.caffeinateTask = nil;
    };
    
    NSLog(@"spawnCaffeinateTaskForTimeInterval with %f", timeInterval);
    caffeinateActive = true;
}


- (void)terminateCaffeinateTask
{
    self.caffeinateTask.terminationHandler = nil;
    [self.caffeinateTask terminate];
    self.caffeinateTask = nil;
}


#pragma mark - idle activity

- (IBAction)toggleIdleActivity:(bool )enabled {
    if (enabled) {
        [self declareUserActivity];
    } else {
        if (_userActivityAssertion == kIOPMNullAssertionID) {
            IOPMAssertionRelease(_userActivityAssertion);
        }
    }
}

- (void)declareUserActivity
{
    if (UpdateSystemActivity != NULL) {
        UpdateSystemActivity(UsrActivity);
    }
    
//    NSLog(@"declareUserActivity");
    
    static IOPMAssertionID assertionID = kIOPMNullAssertionID;
    
    IOPMAssertionDeclareUserActivity(CFSTR("mclockLocal"), kIOPMUserActiveLocal, &assertionID);
    
    // Release any previous assertion before creating a new one
    if (_userActivityAssertion != kIOPMNullAssertionID) {
        IOPMAssertionRelease(_userActivityAssertion);
        _userActivityAssertion = kIOPMNullAssertionID;
    }

    // Create a short-lived "user is active" assertion to reset system idle timer
    IOReturn result = IOPMAssertionCreateWithName(
        kIOPMAssertionTypePreventUserIdleDisplaySleep,
        kIOPMAssertionLevelOn,
        CFSTR("mclock"),
        &_userActivityAssertion
    );

    if (result != kIOReturnSuccess) {
        NSLog(@"mclock useractivity (IOReturn = 0x%x)", result);
    }
    
    
    idleTimerActive = true;
}

@end
