//
//  PreferenceWindowController.h
//  mclock
//
//  Created by Palaniraja on 15/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PreferenceWindowController : NSWindowController <NSComboBoxDataSource, NSComboBoxDelegate>{
@private
    IBOutlet NSTextField *timeZone;
    IBOutlet NSTextField *formatString;
    IBOutlet NSTextField *previewString;
    IBOutlet NSButton *displayPrefix;
    
    IBOutlet NSButton *caffeinate;
    IBOutlet NSButton *preventIdleActivity;
    
    __unsafe_unretained IBOutlet NSComboBox *timezonePicker;
    
    NSMutableArray *timezoneNames;
}

- (IBAction) savePreferences:(id) sender;
- (IBAction) loadPreferences:(id) sender;
- (IBAction) preview:(id) sender;

-(IBAction) openTimeFormatRef:(id)sender;
-(IBAction) openTimeZoneRef:(id)sender;

@end
