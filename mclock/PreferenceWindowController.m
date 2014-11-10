//
//  PreferenceWindowController.m
//  mclock
//
//  Created by Palaniraja on 15/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PreferenceWindowController.h"


@implementation PreferenceWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


- (void)windowDidLoad
{
    [super windowDidLoad];
    [self revertPrefences:nil];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

#pragma mark -
- (id) init {
    
	if ( ! (self = [super initWithWindowNibName: @"PreferenceWindow"]) ) {
		NSLog(@"init failed in PreferenceWindowController");
		return nil;
	} // end if

//	NSLog(@"init OK in PreferenceWindowController");
	
	return self;
} // end init

#pragma mark -
#pragma mark UIAction
- (IBAction) savePrefences:(id) sender{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[timeZone stringValue] forKey:kZoneString];
    [ud setObject:[formatString stringValue] forKey:kDisplayFormatString];
    [ud setBool:[displayPrefix state] forKey:kDisplayZonePrefix];
    [ud synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kPreferencesUpdated object:self];
    
    [self close];
    
}

- (IBAction) revertPrefences:(id) sender{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [timeZone setStringValue:[ud objectForKey:kZoneString]];
    [formatString setStringValue:[ud objectForKey:kDisplayFormatString]]; 
    [displayPrefix setState:[ud boolForKey:kDisplayZonePrefix]];
    
    [previewString setStringValue:@""];

    [self close];
}

- (IBAction) preview:(id) sender{
    
    NSString *zone = [NSString stringWithFormat:[timeZone stringValue]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:[formatString stringValue]];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:zone]]; 
    
    NSString *prefix;
    
    if ([displayPrefix state]) {
        prefix = [NSString stringWithFormat:@"%@ ", zone];
    }else{
        prefix = [NSString stringWithFormat:@""];
    }

    
    [previewString setStringValue:[NSString stringWithFormat:@"%@ %@", prefix, [formatter stringFromDate:[NSDate date]]]];
}

#pragma mark -

-(IBAction) openTimeFormatRef:(id)sender{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://unicode.org/reports/tr35/tr35-6.html#Date_Format_Patterns"]];

}

-(IBAction) openTimeZoneRef:(id)sender{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://pastebin.com/tPCTDAip"]];
}
@end
