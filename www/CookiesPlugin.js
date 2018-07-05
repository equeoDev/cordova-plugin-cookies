var exec = require('cordova/exec')

function CookiesPlugin () {
  console.log('SafeturePlugin.js: is created')
}

SafeturePlugin.prototype.getAllCookies = function () {
  return new Promise(function (resolve, reject) {
    exec(resolve, reject, 'SafeturePlugin', 'getAllCookies', [])
  })
}

SafeturePlugin.prototype.getCookiesForHost = function (host) {
  return new Promise(function (resolve, reject) {
    exec(resolve, reject, 'SafeturePlugin', 'getCookiesForHost', [host])
  })
}

SafeturePlugin.prototype.deleteAllCookies = function () {
  return new Promise(function (resolve, reject) {
    exec(resolve, reject, 'SafeturePlugin', 'deleteAllCookies', [])
  })
}

SafeturePlugin.prototype.deleteCookiesForHost = function (host) {
  return new Promise(function (resolve, reject) {
    exec(resolve, reject, 'SafeturePlugin', 'deleteCookiesForHost', [host])
  })
}

// FIRE READY //
exec(function (result) { console.log('Cookies Ready OK') }, function (result) { console.log('CookiesPlugin Ready ERROR') }, 'CookiesPlugin', 'ready', [])

var cookiesPlugin = new CookiesPlugin()
module.exports = cookiesPlugin
