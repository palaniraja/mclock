//
//  menuItem.m
//  mclock
//
//  Created by Palaniraja on 12/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "menuItem.h"


@implementation menuItem

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        [[NSUserDefaults standardUserDefaults] registerDefaults:    
         [NSDictionary dictionaryWithObjectsAndKeys:     
          @"IST", kZoneString,     
          @"h:mm a", kDisplayFormatString,
          [NSNumber numberWithBool:1], kDisplayZonePrefix,
          kDisplayZoneNone, kDisplayZoneByNameOptionSelected,
          nil]];
        
//        NSLog(@"Timezone abbrevation: %@", [NSTimeZone abbreviationDictionary]);
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
    
//    NSLog(@"Zone: %@ formatString: %@", zone, formatString);
//    statusTitle = [NSString stringWithFormat:@"%@%@", prefix, [formatter stringFromDate:[NSDate date]]];
//    NSLog(@"status title: %@", [NSString stringWithFormat:@"%@%@", prefix, [formatter stringFromDate:[NSDate date]]]);
    
    [statusItem setTitle:[NSString stringWithFormat:@"%@%@", prefix, [formatter stringFromDate:[NSDate date]]]];
}

- (void)awakeFromNib{
    
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setHighlightMode:YES];
    [statusItem setEnabled:YES];
    [statusItem setToolTip:@"Menu Clock"];
    [statusItem setAction:@selector(updateLabel:)];
    [statusItem setTarget:self];
    [statusItem setMenu:statusMenu];
//    statusTitle = [[NSString alloc] init];
    
    zone = [NSString stringWithFormat:@"CST"]; //CST
    formatString = [NSString stringWithFormat:@"h.mm a"];  //HH:MM
    prefix = [NSString stringWithFormat:@"%@ ", zone];
    
    
  
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatString];
    
//    NSString *timeZoneName =
    
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:zone]]; 
    
    [self reload:nil];
    
    
    updateTimer =[NSTimer scheduledTimerWithTimeInterval:60.0
                                     target:self
                                   selector:@selector(updateLabel:)
                                   userInfo:nil
                                    repeats:YES];
    [updateTimer fire];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reload:) 
                                                 name:kPreferencesUpdated
                                               object:nil];
    
    
    
    
}

-(IBAction) showPreferences:(id)sender{
    

    if(!prefWindow){
        prefWindow = [[PreferenceWindowController alloc] init];  
    }
        
//    [prefWindow.window setLevel:NSScreenSaverWindowLevel + 1];
//    [prefWindow.window makeKeyAndOrderFront:nil];
    [NSApp activateIgnoringOtherApps:YES];
    
    [prefWindow showWindow:self];

    
}


- (void) reload: (id)notification{
    
    
    
    
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
    
//    NSLog(@"prefix: %@", prefix);
    
    
    [self updateLabel:nil];
    
}

@end
