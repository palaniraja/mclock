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

- (void)dealloc
{
    [super dealloc];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

#pragma mark -
- (id) init {
    
	if ( ! (self = [super initWithWindowNibName: @"PreferenceWindow"]) ) {
		NSLog(@"init failed in PreferenceWindowController");
		return nil;
	} // end if
	NSLog(@"init OK in PreferenceWindowController");
	
	return self;
} // end init

@end
