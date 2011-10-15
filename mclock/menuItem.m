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
    }
    
    return self;
}

- (void)dealloc
{
    [updateTimer invalidate];
    [formatter release];
    [updateTimer release];
    [zone release];
    [formatString release];
    [statusItem release];
    [prefix release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

#pragma mark -
-(void) updateLabel:(id)sender{
    
//    NSLog(@"Zone: %@ formatString: %@", zone, formatString);
    
    [statusItem setTitle:[NSString stringWithFormat:@"%@%@", prefix, [formatter stringFromDate:[NSDate date]]]];
}

- (void)awakeFromNib{
    
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
    [statusItem setHighlightMode:YES];
    [statusItem setEnabled:YES];
    [statusItem setToolTip:@"Menu Clock"];
    [statusItem setAction:@selector(updateLabel:)];
    [statusItem setTarget:self];
    [statusItem setMenu:statusMenu];
    
    zone = [[NSString stringWithFormat:@"CST"] retain]; //CST
    formatString = [[NSString stringWithFormat:@"h.mm a"] retain];  //HH:MM
    prefix = [[NSString stringWithFormat:@"%@ ", zone] retain];
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatString];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:zone]]; 
    
    [self reload:nil];
    
    
    updateTimer =[[NSTimer scheduledTimerWithTimeInterval:60.0
                                     target:self
                                   selector:@selector(updateLabel:)
                                   userInfo:nil
                                    repeats:YES] retain];
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
        
    
    [prefWindow showWindow:self];

//    [prefWindow release];
//    [prefWindow becomeFirstResponder];
//    [[NSApplication sharedApplication] orderFrontStandardAboutPanel:self];
    
}


- (void) reload: (id)notification{
    
    
    if (zone) {
        [zone release];
    }
    if (formatString) {
        [formatString release];
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    zone = [[ud objectForKey:kZoneString] retain];
    formatString = [[ud objectForKey:kDisplayFormatString] retain]; 

    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:zone]]; 
    [formatter setDateFormat:formatString];
    
    
    if ([ud boolForKey:kDisplayZonePrefix]) {
        prefix = [NSString stringWithFormat:@"%@ ", zone];
    }else{
        prefix = [NSString stringWithFormat:@""];
    }
    
    
    [self updateLabel:nil];
    
}

@end
