export default {
  isLoggedIn () {
    return !!localStorage.getItem('auth_token')
  },

  isAdmin () {
    return this.isLoggedIn() && localStorage.getItem('user_type') === 'AdminUser'
  },

  isSupportAgent () {
    return this.isLoggedIn() && localStorage.getItem('user_type') === 'SupportUser'
  },

  isCustomer () {
    return this.isLoggedIn() && !this.isAdmin() && !this.isSupportAgent()
  },

  login (authToken, userType) {
    localStorage.setItem('auth_token', authToken)
    localStorage.setItem('user_type', userType)
  },

  logout () {
    localStorage.removeItem('auth_token')
    localStorage.removeItem('user_type')
    this.loggedIn = false
  }
}
