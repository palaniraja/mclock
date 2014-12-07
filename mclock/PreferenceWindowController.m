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
   
    timezoneNames = [[NSTimeZone knownTimeZoneNames] mutableCopy];
    [timezoneNames insertObject:kDisplayZoneNone atIndex:0];
    
//    NSLog(@"timezones: %@", timezoneNames);
//    timezonePicker.dataSource = self;
    timezonePicker.delegate = self;
    
    [timezonePicker reloadData];
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
    
    NSString *selectedTimeZoneName = [timezoneNames objectAtIndex:[timezonePicker indexOfSelectedItem]];
    
    [ud setObject:selectedTimeZoneName forKey:kDisplayZoneByNameOptionSelected];
    [ud synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kPreferencesUpdated object:self];
    
    [self close];
    
}

- (IBAction) revertPrefences:(id) sender{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [timeZone setStringValue:[ud objectForKey:kZoneString]];
    [formatString setStringValue:[ud objectForKey:kDisplayFormatString]];
    [displayPrefix setState:[ud boolForKey:kDisplayZonePrefix]];
    
    NSString *selectedTimeZoneName = [ud objectForKey:kDisplayZoneByNameOptionSelected];
    [timezonePicker selectItemAtIndex:[timezoneNames indexOfObject:selectedTimeZoneName]];
    
    if (![selectedTimeZoneName isEqualToString:kDisplayZoneNone]) {
        [self toggleZoneIfNameEnabled:YES];
    }
    else{
        [self toggleZoneIfNameEnabled:NO];
    }
    
    [previewString setStringValue:@""];

    [self close];
}

- (IBAction) preview:(id) sender{
    
    
//    NSInteger idx = [timezoneNames indexOfObject:@"Africa/Algiers"];
//    [timezonePicker selectItemAtIndex:idx];
//    
    
    
    NSString *zone = [NSString stringWithFormat: @"%@", [timeZone stringValue]];

    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:[formatString stringValue]];
    
    NSString *selectedTimeZoneName = [timezoneNames objectAtIndex:[timezonePicker indexOfSelectedItem]];
    
    if (![selectedTimeZoneName isEqualToString:kDisplayZoneNone]) {
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:selectedTimeZoneName]];
        [self toggleZoneIfNameEnabled:YES];
    }
    else{
        [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:zone]];
        [self toggleZoneIfNameEnabled:NO];
    }
    
    
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


#pragma mark -Combo box

- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox{
    return [timezoneNames count];
}
- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index{
    return [NSString stringWithFormat:@"%@", [timezoneNames objectAtIndex:index]];
//    return @"";
}

//- (NSUInteger)comboBox:(NSComboBox *)aComboBox indexOfItemWithStringValue:(NSString *)string
//{
//    return [timezoneNames indexOfObject:string];
//}




- (void)comboBoxWillDismiss:(NSNotification *)notification{

    NSString *selectedValue = [timezoneNames objectAtIndex:[timezonePicker indexOfSelectedItem]];
//    NSLog(@"Selected value: %@", selectedValue);
    if (![selectedValue isEqualToString:kDisplayZoneNone]) {
        [self toggleZoneIfNameEnabled:YES];
        
    }
    else{
        [self toggleZoneIfNameEnabled:NO];
    }
    
}

- (void) toggleZoneIfNameEnabled:(BOOL)nameEnabled{
    if (nameEnabled) {
        timeZone.enabled = false;
        displayPrefix.state = 0;
        displayPrefix.enabled = false;
    }
    else{
        timeZone.enabled = true;
        displayPrefix.enabled = true;
    }
}
@end
