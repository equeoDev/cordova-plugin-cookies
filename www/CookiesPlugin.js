var exec = require('cordova/exec')

function CookiesPlugin () {
  console.log('CookiesPlugin.js: is created')
}

CookiesPlugin.prototype.getAllCookies = function () {
  return new Promise(function (resolve, reject) {
    exec(resolve, reject, 'CookiesPlugin', 'getAllCookies', [])
  })
}

CookiesPlugin.prototype.getCookiesForHost = function (host) {
  return new Promise(function (resolve, reject) {
    exec(resolve, reject, 'CookiesPlugin', 'getCookiesForHost', [host])
  })
}

CookiesPlugin.prototype.deleteAllCookies = function () {
  return new Promise(function (resolve, reject) {
    exec(resolve, reject, 'CookiesPlugin', 'deleteAllCookies', [])
  })
}

CookiesPlugin.prototype.deleteCookiesForHost = function (host) {
  return new Promise(function (resolve, reject) {
    exec(resolve, reject, 'CookiesPlugin', 'deleteCookiesForHost', [host])
  })
}

// FIRE READY //
exec(function (result) { console.log('Cookies Ready OK') }, function (result) { console.log('CookiesPlugin Ready ERROR') }, 'CookiesPlugin', 'ready', [])

var cookiesPlugin = new CookiesPlugin()
module.exports = cookiesPlugin
