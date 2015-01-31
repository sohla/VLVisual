//
//  AppDelegate.m
//  VLVisual
//
//  Created by Stephen OHara on 7/11/2014.
//  Copyright (c) 2014 Steph OHara. All rights reserved.
//

#import "AppDelegate.h"
#import "SOArduinoWindowController.h"
@interface AppDelegate ()

@property (strong) SOArduinoWindowController *arduinoWindowController;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    _arduinoWindowController = [[SOArduinoWindowController alloc] initWithWindowNibName:@"SOArduinoWindowController"];
    [self.arduinoWindowController showWindow:self];
    

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
