# Cordova Cookies Plugin

A plugin that can list and delete cookies saved in the WKWebview.

## Installation

`cordova plugin add git@github.com:equeoDev/cordova-plugin-cookies.git`

## Usage

Get all cookies:

`await window.CookiesPlugin.getAllCookies()`

Get cookies from specific domain (including all subdomains):

`await window.CookiesPlugin.getCookiesFromHost('example.com')`

Delete all cookies:

`await window.CookiesPlugin.deleteAllCookies()`

Delete cookies from specific domain (including all subdomains):

`await window.CookiesPlugin.deleteCookiesFromHost('example.com')`
