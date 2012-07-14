//
//  HotPotViewController.m
//  HotPot
//
//  Created by Yun on 12/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HotPotViewController.h"

typedef enum {
	kServer,
	kClient
}gameNetwork;

typedef enum {
	kStartgame,
	kStateCointoss,
	kStategame
}gameStates;

#define kMaxPacketSize 1024

@implementation HotPotViewController

@synthesize currentsession;
@synthesize pass;
@synthesize players;
@synthesize game;
@synthesize disconnect;
@synthesize gameState, peerStatus, timer, gamePeerId;

GKPeerPickerController *picker;

-(IBAction) btnPlayers : (id) sender {
	picker = [[GKPeerPickerController alloc] init];
	picker.delegate =self;
	picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
	[players setHidden:YES];
	[game setHidden:NO];
	[disconnect setHidden:NO];
	[pass setHidden:YES];
	[picker show];
	self.gameState = kStategame;
	[NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(gameLoop) userInfo:nil repeats:NO];
}
-(void)peerPickerController : (GKPeerPickerController *) picker didConnectPeer: (NSString *) peerID toSession :(GKSession *) session {
	
	self.gamePeerId = peerID;
	
	self.currentsession = session;
	self.currentsession.delegate = self;
	[self.currentsession setDataReceiveHandler:self withContext:NULL];
	[picker dismiss];	
	picker.delegate = nil;
	[picker autorelease];
	self.gameState = kStateCointoss;
	[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(gameLoop) userInfo:nil repeats:NO];
	int time = 25 + random()%9; 
	[NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(endgame) userInfo:nil repeats:NO];
}


		
-(void)peerPickerControllerDidCancel:(GKPeerPickerController *) picker
{
	picker.delegate = nil;
	[picker autorelease];
	[players setHidden:NO];
	[disconnect setHidden:YES];
	[game setHidden:YES];
	[pass setHidden:YES];

}

-(void) session: (GKSession *) session
		   peer: (NSString *) peerID
 didChangeState: (GKPeerConnectionState)state {
	switch (state)
	{
		case GKPeerStateConnected:
			NSLog(@"Connected");
			break;
		case GKPeerStateDisconnected:
			NSLog(@"Disconnected");
			[self.currentsession release];
			currentsession =nil;
			
			[players setHidden:NO];
			[disconnect setHidden:YES];
			[game setHidden:YES];
			[pass setHidden:YES];
			break;
	}
}
-(IBAction) btnDisconnect :(id) sender
{
	[self.currentsession disconnectFromAllPeers];
	[self.currentsession release];
	currentsession =nil;
	
	[players setHidden:NO];
	[disconnect setHidden:YES];
	[game setHidden:YES];
	[pass setHidden:YES];
}

-(void)endgame {
	
	[UIImage release];
	if (status==1)
	{
		NSString *str;
		str = [[NSString alloc] initWithData:nil encoding:NSASCIIStringEncoding];
		UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"You Lost" message:str delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		
	}
	else {
		NSString *str;
		str = [[NSString alloc] initWithData:nil encoding:NSASCIIStringEncoding];
		UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"You Won" message:str delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	[self.currentsession disconnectFromAllPeers];
	[self.currentsession release];
	currentsession =nil;
	[players setHidden:NO];
	[disconnect setHidden:YES];
	[pass setHidden:YES];
	UIView* subview;
	while ((subview = [[potato subviews] lastObject]) != nil)
		[subview removeFromSuperview];
}

-(IBAction) btnPass : (id) sender
{
	[players setHidden:YES];
	[disconnect setHidden:NO];
	[game setHidden:YES];
	[pass setHidden:YES];
	self.gameState = kStategame;
	status = 0;
	CGRect myImageRect = CGRectMake(0.0f,0.0f,320.0f,420.f);	
	potato = [[UIImageView alloc] initWithFrame:myImageRect];
	[potato setImage:[UIImage imageNamed:@"background.jpg"]];
	potato.opaque = YES;
	[self.view addSubview:potato];
	[potato release];
	[NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(gameLoop) userInfo:nil repeats:NO];	
}
-(void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context {
	NSMutableArray *myarray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	int packetID = [[myarray objectAtIndex:0] intValue];
	int coinToss = [[myarray objectAtIndex:1] intValue];
	switch( packetID ) {
		case NETWORK_COINTOSS:
		{
			if(coinToss > gameUniqueId) {
				self.peerStatus = kClient;
				[players setHidden:YES];
				[disconnect setHidden:NO];
				[game setHidden:YES];
				[pass setHidden:YES];
				self.gameState = kStategame;
				status =0;
				CGRect myImageRect = CGRectMake(0.0f,0.0f,320.0f,420.f);	
				potato = [[UIImageView alloc] initWithFrame:myImageRect];
				[potato setImage:[UIImage imageNamed:@"background.jpg"]];
				potato.opaque = YES;
				[self.view addSubview:potato];
				[potato release];
				
			}
			else {
				[players setHidden:YES];
				[disconnect setHidden:NO];
				[game setHidden:YES];
				[pass setHidden:NO];
				self.gameState = kStategame;
				status =1;
				CGRect myImageRect = CGRectMake(0.0f,0.0f,320.0f,420.f);	
				potato = [[UIImageView alloc] initWithFrame:myImageRect];
				[potato setImage:[UIImage imageNamed:@"Potato.jpg"]];
				potato.opaque = YES;
				[self.view addSubview:potato];
				[potato release];
			}
		}
			break;
		case NETWORK_EVENT:
		{
			[players setHidden:YES];
			[disconnect setHidden:NO];
			[game setHidden:YES];
			[pass setHidden:NO];
			self.gameState = kStategame;
			status =1;
			CGRect myImageRect = CGRectMake(0.0f,0.0f,320.0f,420.f);	
			potato = [[UIImageView alloc] initWithFrame:myImageRect];
			[potato setImage:[UIImage imageNamed:@"Potato.jpg"]];
			potato.opaque = YES;
			[self.view addSubview:potato];
			[potato release];
			
		}
			break;
		default:
			break;
	}
}	

- (void)mySendDataToPeers:(GKSession *)session packetID:(int)packetID gameId:(int)gameId
{	
	NSNumber *wpacketid = [NSNumber numberWithInt:packetID];
	NSNumber *wgameid = [NSNumber numberWithInt:gameId];
	NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:2];
	[array addObject: wpacketid];
	[array addObject: wgameid];
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
	if (currentsession) 
        [self.currentsession sendDataToAllPeers:data 
                                   withDataMode:GKSendDataReliable 
                                          error:nil];    
}


-(void)gameLoop {
	switch (self.gameState)
	{
		case kStateCointoss:
		{
			[self mySendDataToPeers:self.currentsession packetID:NETWORK_COINTOSS gameId:gameUniqueId];
			break;		
		}
		case kStategame:
		{
			[self mySendDataToPeers:self.currentsession packetID:NETWORK_EVENT gameId:gameUniqueId];
			break;
		}
		default:
			break;
			
	}
}

- (void)viewDidLoad {
	[players setHidden:NO];
	[disconnect setHidden:YES];
	[game setHidden:YES];
	[pass setHidden:YES];
	[super viewDidLoad];
	peerStatus = kServer;
	status = 0;
	gamePeerId = nil;
	NSString *uid = [[UIDevice currentDevice] uniqueIdentifier];
	gameUniqueId = [uid hash];
}
			

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	
}

- (void)dealloc {
	[currentsession release];
	self.currentsession = nil;
	self.gamePeerId = nil;
	UIView* subview;
	while ((subview = [[potato subviews] lastObject]) != nil)
		[subview removeFromSuperview];
    [super dealloc];
}

@end
