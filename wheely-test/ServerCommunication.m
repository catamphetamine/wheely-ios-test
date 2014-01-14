//
//  ServerCommunication.m
//  Sociopathy
//
//  Created by Admin on 09.01.14.
//  Copyright (c) 2014 kuchumovn. All rights reserved.
//

#import "ServerCommunication.h"
#import "NSError+Tools.h"
#import "NSDictionary+HttpTools.h"

typedef enum
{
    CommunicationError_HttpConnectionError = 1,
    CommunicationError_HttpResponseError = 2,
    CommunicationError_JsonError = 3,
    CommunicationError_ServerError = 4
}
CommunicationErrors;

@implementation ServerCommunication
{
    __weak id <ServerCommunicationDelegate> delegate;
    __weak id <NetworkSessionSource> sessionSource;
    NSURL* url;
}

- (id) initWithSessionSource: (id <NetworkSessionSource>) sessionSource
                    delegate: (id <ServerCommunicationDelegate>) delegate
{
    if (self = [super init])
    {
        self->sessionSource = sessionSource;
        self->delegate = delegate;
    }
    return self;
}

- (id) initWithSessionSource: (id <NetworkSessionSource>) sessionSource
                         url: (NSURL*) url
                    delegate: (id <ServerCommunicationDelegate>) delegate
{
    if (self = [self initWithSessionSource:sessionSource delegate:delegate])
    {
        self->url = url;
    }
    return self;
}

- (void) communicate
{
    return [self communicate:url method:nil parameters:nil];
}

- (void) communicate: (NSURL*) url
              method: (NSString*) method
          parameters: (NSDictionary*) parameters
{
    if (!method)
        method = @"get";
    
    if ([method isEqualToString:@"get"])
    {
        if (parameters)
        {
            NSString* urlString = url.absoluteString;
            NSString* parametersString = [parameters httpParameters];
            
            NSString* separator;
            
            if (url.query)
                separator = @"&";
            else
                separator = @"?";
            
            urlString = [urlString stringByAppendingString:separator];
            urlString = [urlString stringByAppendingString:parametersString];
            
            url = [NSURL URLWithString:urlString];
        }
    }
    
    //NSLog(@"%@", url);
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:[method uppercaseString]];
    
    void (^completionHandler)(NSData *data, NSURLResponse *response, NSError *error) = ^(NSData *data, NSURLResponse *response, NSError *error)
    {
        if (error)
        {
            return [self communicationFailed:[NSError error:error.localizedDescription code:CommunicationError_HttpConnectionError]];
        }
        
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*) response;
        if (httpResponse.statusCode != 200)
        {
            return [self communicationFailed:[NSError error:[NSString stringWithFormat:@"(%d)", httpResponse.statusCode] code:CommunicationError_HttpResponseError]];
        }
        
        NSError* jsonError;
        
        NSDictionary* json =
        [NSJSONSerialization JSONObjectWithData:data
                                        options:NSJSONReadingAllowFragments
                                          error:&jsonError];
        
        if (jsonError)
        {
            return [self communicationFailed:[NSError error:jsonError.localizedDescription code:CommunicationError_JsonError]];
        }
        
        if (![json isKindOfClass:NSArray.class])
        {
            if (json[@"error"])
            {
                return [self communicationFailed:[NSError error:json[@"error"] code:CommunicationError_ServerError]];
            }
        }
        
        [self serverResponds:json];
    };
    
    NSURLSessionTask* task;
    
    if ([method isEqualToString:@"get"])
    {
        task = [sessionSource.session
                dataTaskWithRequest:request
                completionHandler:completionHandler];
    }
    else
    {
        task = [sessionSource.session
                uploadTaskWithRequest:request
                fromData:[parameters postParameters]
                completionHandler:completionHandler];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [task resume];
}

- (void) communicationFailed: (NSError*) error
{
    NSString* errorMessage;
    
    if ([delegate respondsToSelector:@selector(communicationErrorMessage:)])
        errorMessage = [delegate communicationErrorMessage:error];
    
    if (!errorMessage)
        errorMessage = [self communicationErrorMessage:error];
    
    dispatch_async(dispatch_get_main_queue(), ^
    {
        //NSLog(@"%@", error);
       
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
       
        [delegate communicationFailed:error message:errorMessage];
    });
}

- (NSString*) communicationErrorMessage: (NSError*) error
{
    if (error.code == CommunicationError_HttpConnectionError || error.code == CommunicationError_HttpResponseError)
    {
        return NSLocalizedString(@"Remote Api. Connection to the server failed", nil);
    }
    
    if (error.code == CommunicationError_JsonError || error.code == CommunicationError_ServerError)
    {
        return NSLocalizedString(@"Remote Api. Server error", nil);
    }
    
    return NSLocalizedString(@"Remote Api. Generic error", nil);
}

- (void) serverResponds: (NSDictionary*) data
{
    if ([delegate respondsToSelector:@selector(whenServerResponds:)])
        [delegate whenServerResponds:data];
        
    dispatch_async(dispatch_get_main_queue(), ^
    {
        //NSLog(@"%@", data);
       
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
       
        [delegate serverResponds:data];
    });
}
@end
