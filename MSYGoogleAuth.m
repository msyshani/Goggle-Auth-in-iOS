//
//  MSYGoogleAuth.m
//  
//
//  Created by Mahendra Yadav on 1/4/16.
//
//


/* call it like following
 
 
 MSYGoogleAuth.sharedInstance().loginWithGooglewithCompletion { (success, userData) -> Void in
 
 if(success){
 print(userData);
 }else{
 print("error in retriving data")
 }
 }

 
 */


/*
 Include the following frameworks in your Xcode project:
 
 AddressBook.framework
 AssetsLibrary.framework
 Foundation.framework
 CoreLocation.framework
 CoreMotion.framework
 CoreGraphics.framework
 CoreText.framework
 MediaPlayer.framework
 Security.framework
 SystemConfiguration.framework
 UIKit.framework
 
 
 GooglePlus.framework
 GooglePlus.bundle 
 GoogleOpenSource.framework
 
 */


/*
1. Other Linker Flags: -ObjC
 
2. In your app's Info tab, add a URL type and enter your bundle ID as the identifier and scheme:
 
 3.In app delegate
 
 - (BOOL)application: (UIApplication *)application
 openURL: (NSURL *)url
 sourceApplication: (NSString *)sourceApplication
 annotation: (id)annotation {
 return [GPPURLHandler handleURL:url
 sourceApplication:sourceApplication
 annotation:annotation];
 
 */


#import "MSYGoogleAuth.h"


@implementation MSYGoogleAuth{
    msyGoogleAuth _completionHandler;
}



static id _sharedInstance = nil;

+(instancetype)sharedInstance
{
    static dispatch_once_t p;
    dispatch_once(&p, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}


-(void)loginWithGooglewithCompletion:(msyGoogleAuth)completionBlock{
    
   _completionHandler=[completionBlock copy];
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
    
    // You previously set kClientId in the "Initialize the Google+ client" step
    signIn.clientID = kClientId;
    
    // Uncomment one of these two statements for the scope you chose in the previous step
    //signIn.scopes = @[ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
    signIn.scopes = @[ @"profile" ];            // "profile" scope
    
    // Optional: declare signIn.actions, see "app activities"
    signIn.delegate = (id<GPPSignInDelegate>)self;
    
    [signIn authenticate];
  
    //return [[NSDictionary alloc] init];
}


- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
   // NSLog(@"Received error %@ and auth object %@",error, auth);
    
    
    if (error) {
        _completionHandler(false,nil);
    } else {
      
        
        GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
        
       // NSLog(@"email %@ ", [NSString stringWithFormat:@"Email: %@",[GPPSignIn sharedInstance].authentication.userEmail]);
        NSLog(@"Received error %@ and auth object %@",error, auth);
        
        // 1. Create a |GTLServicePlus| instance to send a request to Google+.
        GTLServicePlus* plusService = [[GTLServicePlus alloc] init] ;
        plusService.retryEnabled = YES;
        
        // 2. Set a valid |GTMOAuth2Authentication| object as the authorizer.
        [plusService setAuthorizer:[GPPSignIn sharedInstance].authentication];
        
        // 3. Use the "v1" version of the Google+ API.*
        plusService.apiVersion = @"v1";
        [plusService executeQuery:query
                completionHandler:^(GTLServiceTicket *ticket,
                                    GTLPlusPerson *person,
                                    NSError *error) {
                    if (error) {
                        _completionHandler(false,nil);
                    } else {
                       /* NSLog(@"Email= %@", [GPPSignIn sharedInstance].authentication.userEmail);
                        NSLog(@"GoogleID=%@", person.identifier);
                        NSLog(@"User Name=%@", [person.name.givenName stringByAppendingFormat:@" %@", person.name.familyName]);
                        NSLog(@"Gender=%@", person.gender);
                        */
                        
                        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
                        
                        if([GPPSignIn sharedInstance].authentication.userEmail)
                            [dic setValue:[GPPSignIn sharedInstance].authentication.userEmail forKey:@"email"];
                        
                        if(person.identifier)
                            [dic setValue:person.identifier forKey:@"GoogleID"];
                        
                        if(person.gender)
                            [dic setValue:person.gender forKey:@"gender"];
                        
                        
                        NSString *name=@"";
                        
                        if(person.name.givenName)
                            name=person.name.givenName;
                        
                        if(person.name.familyName)
                            name=[name stringByAppendingString:[NSString stringWithFormat:@" %@",person.name.familyName]];
                        
                        
                        [dic setValue:name forKey:@"name"];
                        
                        
                        _completionHandler(YES,dic);
                        
                    }
                }];
    }
}

@end
