// For authoring Nightwatch tests, see
// http://nightwatchjs.org/guide#usage

module.exports = {

  'home page initial state': function (browser) {
    browser
      .url('localhost:5000')
      .waitForElementVisible('#app', 5000)
      .assert.elementPresent('.home')
      .assert.containsText('h1', 'Wellcome to Customer Support')
      .assert.elementCount('.login-form', 1)
      .assert.elementCount('.register-form', 0)
      .end()
  },

  'login and register form transitions': function (browser) {
    browser
      .url('localhost:5000')
      .waitForElementVisible('#app', 5000)
      .assert.elementCount('.login-form', 1)
      .assert.elementCount('.register-form', 0)
      .click('#form-footer-links > a')
      .pause(100)
      .assert.elementCount('.login-form', 0)
      .assert.elementCount('.register-form', 1)
      .click('#form-footer-links > a')
      .pause(100)
      .assert.elementCount('.login-form', 1)
      .assert.elementCount('.register-form', 0)
      .end()
  },

  'login form content': function (browser) {
    browser
      .url('localhost:5000')
      .waitForElementVisible('#app', 5000)
      .assert.containsText('.form-footer > button', 'Login')
      .assert.containsText('#form-footer-links > a', 'Register new account')
      .assert.elementCount('input#email[type=email]', 1)
      .assert.elementCount('input#password[type=password]', 1)
      .end()
  },

  'register form content': function (browser) {
    browser
      .url('localhost:5000')
      .waitForElementVisible('#app', 5000)
      .click('#form-footer-links > a')
      .assert.containsText('.form-footer > button', 'Register')
      .assert.containsText('#form-footer-links > a', 'I already have an account')
      .assert.elementCount('input[type=text][name=name]', 1)
      .assert.elementCount('input[type=email][name=email]', 1)
      .assert.elementCount('input[type=password][name=password]', 1)
      .end()
  },
}
