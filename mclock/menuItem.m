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
    NSLog(@"init");
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
    NSLog(@"updateLabel called");
    
    NSString *time2display = [NSString stringWithFormat:@"%@%@", prefix, [formatter stringFromDate:[NSDate date]]];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:time2display attributes:attribDict];
    [statusItem setAttributedTitle:attrString];
//    [statusItem setTitle:time2display];
}

- (void)awakeFromNib{
    
    NSLog(@"awakefromNib");
    
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
    NSLog(@"updateTimeAsPerSystemTime called with %@", notify);
    [self updateLabel:nil];
}

@end
