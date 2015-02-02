//
//  SOToolWindowController.m
//  VLVisual
//
//  Created by Stephen OHara on 28/01/2015.
//  Copyright (c) 2015 Steph OHara. All rights reserved.
//

#import "SOArduinoWindowController.h"
#import "Matatino.h"
#import "JSONModel.h"

@interface SOArduinoWindowController () <MatatinoDelegate>
@property (weak) IBOutlet NSPopUpButton *serialSelectMenu;
@property (weak) IBOutlet NSTextField *receivedText;
@property (weak) IBOutlet NSButton *connectButton;

@property (strong)     Matatino *arduino;

@end

@implementation SOArduinoWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    _arduino = [[Matatino alloc] initWithDelegate:self];
    [self.serialSelectMenu addItemsWithTitles:[self.arduino deviceNames]];

    NSColorPanel *colorPanel = [NSColorPanel sharedColorPanel];
    
    [colorPanel setTarget:self];
    [colorPanel setAction:@selector(onColorPanelAction:)];

}


- (void) setButtonsEnabled {
    [self.serialSelectMenu setEnabled:YES];
    [self.connectButton setTitle:@"GO!"];
    
}

- (void) setButtonsDisabled {
    [self.serialSelectMenu setEnabled:NO];
    [self.connectButton setTitle:@"Stop"];
}

- (void)windowWillClose:(NSNotification *)notification{
}
#pragma Actions

-(void) onColorPanelAction:(id)sender{
    
    NSColorPanel *colorPanel = (NSColorPanel*)sender;
    DLog(@"%@",[colorPanel color]);
    
    [self sendDMXColor:[colorPanel color]];
    
}

- (IBAction)connectPressed:(id)sender {

    if(![self.arduino isConnected]) { // Pressing GO!
        
        if([self.arduino connect:[self.serialSelectMenu titleOfSelectedItem] withBaud:B9600]) {
            
            [self setButtonsDisabled];
            [self dmxOff];
            
            
        } else {
            NSAlert *alert = [[NSAlert alloc] init] ;
            [alert setMessageText:@"Connection Error"];
            [alert setInformativeText:@"Connection failed to start"];
            [alert addButtonWithTitle:@"OK"];
            [alert setAlertStyle:NSWarningAlertStyle];
            [alert beginSheetModalForWindow:[self window] modalDelegate:self didEndSelector:nil contextInfo:nil];
        }
        
    } else { // Pressing Stop
        
        DLog(@"stop");
        
        [self dmxOff];
        
        [self.arduino disconnect];
        [self setButtonsEnabled];
        
    }
}

#pragma mark - Communication
-(void)dmxOff{
    [self.arduino send:@"1c0w2c0w3c0w"];
    
}

-(void)sendDMXColor:(NSColor*)color{
    
    NSString *command = [NSString stringWithFormat:@"%dc%dw%dc%dw%dc%dw",
                         1,
                         (int)(255 * [color redComponent]),
                         2,
                         (int)(255 * [color greenComponent]),
                         3,
                         (int)(255 * [color blueComponent])
                         ];
    
    [self.arduino send:command];
    DLog(@"%@",command);
    
    
}

#pragma mark - Arduino Delegate Methods

- (void) receivedString:(NSString *)rx {
    [self.receivedText setStringValue:rx];
    
    if([rx isEqualToString:@"sensor A\r\n"]){
        [self sendDMXColor:[NSColor redColor]];
    }
    if([rx isEqualToString:@"sensor B\r\n`  "]){
        [self sendDMXColor:[NSColor greenColor]];
    }
    
    DLog(@"%@",rx);
}

- (void) portAdded:(NSArray *)ports {
    
    DLog(@"Added: %@", ports);
    
    for(NSString *portName in ports) {
        [self.serialSelectMenu addItemWithTitle:portName];
    }
}

- (void) portRemoved:(NSArray *)ports {
    
    DLog(@"Removed: %@", ports);
    
    for(NSString *portName in ports) {
        [self.serialSelectMenu removeItemWithTitle:portName];
    }
}

- (void) portClosed {
    [self setButtonsEnabled];
    [self.window makeKeyAndOrderFront:self];
    
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Disconnected"];
    [alert setInformativeText:@"Apparently the Arduino was disconnected!"];
    [alert addButtonWithTitle:@"OK"];
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert beginSheetModalForWindow:[self window] modalDelegate:self didEndSelector:nil contextInfo:nil];
}


@end
