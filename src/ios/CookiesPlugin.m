#include <sys/types.h>
#include <sys/sysctl.h>

#import <Cordova/CDV.h>
#import "CookiesPlugin.h"

@interface CookiesPlugin () {
}
@end

@implementation CookiesPlugin

- (void)ready:(CDVInvokedUrlCommand *)command {
    NSLog(@"Cordova view ready");
    [self.commandDelegate runInBackground:^{

        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (NSDictionary *)cookieDescription:(NSHTTPCookie *)cookie {

    NSMutableDictionary *cookieDescription = [NSMutableDictionary dictionary];
    cookieDescription[@"name"] = [[cookie name] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    cookieDescription[@"value"] = [[cookie value] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    cookieDescription[@"domain"] = [cookie domain];
    cookieDescription[@"path"] = [cookie path];
    cookieDescription[@"expiresDate"] = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                                       dateStyle:NSDateFormatterShortStyle
                                                                       timeStyle:NSDateFormatterFullStyle];
    cookieDescription[@"sessionOnly"] = [cookie isSessionOnly] ? @(1) : @(0);
    cookieDescription[@"secure"] = [cookie isSecure] ? @(1) : @(0);
    cookieDescription[@"comment"] = [cookie comment];
    cookieDescription[@"commentURL"] = [cookie commentURL];
    cookieDescription[@"version"] = @((unsigned long) [cookie version]);

    //  [cookieDescription appendFormat:@"  portList        = %@\n",            [cookie portList]];
    //  [cookieDescription appendFormat:@"  properties      = %@\n",            [cookie properties]];

    return cookieDescription;
}


- (NSMutableArray *)_getCookiesArray {
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [cookieStorage cookies];
    NSMutableArray *cookiesJson = [NSMutableArray array];
    for (int i = 0; i < [cookies count]; i++) {
        [cookiesJson addObject:[self cookieDescription:cookies[i]]];
    }
    return cookiesJson;
}

- (NSMutableArray *)_getCookiesArrayfromHost:(NSString *)host {
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [cookieStorage cookies];
    NSMutableArray *cookiesJson = [NSMutableArray array];
    for (int i = 0; i < [cookies count]; i++) {
        NSHTTPCookie *cookie = cookies[i];
        if ([[cookie domain] hasSuffix:[NSString stringWithFormat:@".%@", host]]) {
            [cookiesJson addObject:[self cookieDescription:cookies[i]]];
        }
    }
    return cookiesJson;
}

- (void)_deleteCookiesArrayfromHost:(NSString *)host {
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [cookieStorage cookies];
    for (int i = 0; i < [cookies count]; i++) {
        NSHTTPCookie *cookie = cookies[i];
        if ([[cookie domain] hasSuffix:[NSString stringWithFormat:@".%@", host]]) {
            [cookieStorage deleteCookie:cookie];
        }
    }
}

- (void)deleteCookiesfromHost:(CDVInvokedUrlCommand *)command {
    NSString *host = command.arguments[0];
    NSLog(@"[CookiesPlugin] deleteCookiesfromHost %@", host);
    [self.commandDelegate runInBackground:^{
        [self _deleteCookiesArrayfromHost:host];
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)deleteAllCookies:(CDVInvokedUrlCommand *)command {
    NSLog(@"[CookiesPlugin] deleteAllCookies");
    [self.commandDelegate runInBackground:^{
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSArray *cookies = [cookieStorage cookies];
        for (int i = 0; i < [cookies count]; i++) {
            NSHTTPCookie *cookie = cookies[i];
            [cookieStorage deleteCookie:cookie];
        }

        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)getCookiesfromHost:(CDVInvokedUrlCommand *)command {
    NSString *host = command.arguments[0];
    NSLog(@"[CookiesPlugin] getCookiesfromHost %@", host);
    [self.commandDelegate runInBackground:^{
        NSArray *cookiesJson = [self _getCookiesArrayfromHost: host];
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:cookiesJson];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)getAllCookies:(CDVInvokedUrlCommand *)command {
    NSLog(@"[CookiesPlugin] getAllCookies");
    [self.commandDelegate runInBackground:^{
        NSArray *cookiesJson = [self _getCookiesArray];

        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:cookiesJson];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

@end

