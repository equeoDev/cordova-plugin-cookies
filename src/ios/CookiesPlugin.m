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
    cookieDescription[@"expiresDate"] = [cookie expiresDate];
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

- (NSMutableArray *)_getCookiesArrayForHost:(NSString *)host {
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [cookieStorage cookies];
    NSMutableArray *cookiesJson = [NSMutableArray array];
    for (int i = 0; i < [cookies count]; i++) {
        NSHTTPCookie *cookie = cookies[i];
        if ([[cookie domain] hasSuffix:host]) {
            [cookiesJson addObject:[self cookieDescription:cookies[i]]];
        }
    }
    return cookiesJson;
}

- (void)_deleteCookiesArrayForHost:(NSString *)host {
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [cookieStorage cookies];
    for (int i = 0; i < [cookies count]; i++) {
        NSHTTPCookie *cookie = cookies[i];
        if ([[cookie domain] hasSuffix:host]) {
            [cookieStorage deleteCookie:cookie];
        }
    }
}

- (void)deleteCookiesForHost:(CDVInvokedUrlCommand *)command {
    NSString *host = command.arguments[0];
    NSLog(@"[CookiesPlugin] deleteCookiesForHost %@", host);
    [self.commandDelegate runInBackground:^{
        [self _deleteCookiesArrayForHost:host];
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

- (void)getCookiesForHost:(CDVInvokedUrlCommand *)command {
    NSString *host = command.arguments[0];
    NSLog(@"[CookiesPlugin] getCookiesForHost %@", host);
    [self.commandDelegate runInBackground:^{
        NSArray *cookiesJson = [self _getCookiesArrayForHost: host];
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
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

