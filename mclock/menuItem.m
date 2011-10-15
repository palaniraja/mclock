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
    [statusItem release];
    [super dealloc];
}

#pragma mark -
-(void) updateLabel:(id)sender{
    [statusItem setTitle:[NSString stringWithFormat:@"%@ %@", zone, [formatter stringFromDate:[NSDate date]]]];
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
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"h.mm a"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:zone]]; 
    
    [self updateLabel:nil];
    
    updateTimer =[[NSTimer scheduledTimerWithTimeInterval:60.0
                                     target:self
                                   selector:@selector(updateLabel:)
                                   userInfo:nil
                                    repeats:YES] retain];
    [updateTimer fire];
    
}

@end
