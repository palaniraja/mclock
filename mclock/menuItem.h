//
//  menuItem.h
//  mclock
//
//  Created by Palaniraja on 12/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PreferenceWindowController.h"


@interface menuItem : NSObject {
@private
    NSStatusItem *statusItem;
    
    NSDateFormatter *formatter;
    
    NSTimer *updateTimer;
    
    NSString *zone;
    IBOutlet NSMenu *statusMenu;
    
    PreferenceWindowController *prefWindow;
    
}

-(void) updateLabel:(id)sender;

-(IBAction) showPreferences:(id)sender;

@end
