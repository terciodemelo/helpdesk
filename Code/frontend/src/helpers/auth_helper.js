export default {

  jsonHeaders () {
    return {
      'Content-Type': 'application/json',
      'Authorization': this.authorizationHeader()
    }
  },

  authorizationHeader () {
    return `Bearer ${localStorage.getItem('auth_token')}`
  },

  isLoggedIn () {
    return !!localStorage.getItem('auth_token')
  },

  isAdmin () {
    return this.isLoggedIn() && localStorage.getItem('user_type') === 'Admin'
  },

  isSupportAgent () {
    return this.isLoggedIn() && localStorage.getItem('user_type') === 'SupportAgent'
  },

  isCustomer () {
    return this.isLoggedIn() && !this.isAdmin() && !this.isSupportAgent()
  },

  login (payload) {
    localStorage.setItem('auth_token', payload.auth_token)
    localStorage.setItem('user_type', payload.user_type)
    localStorage.setItem('user_name', payload.user_name)
    localStorage.setItem('user_id', payload.user_id)
  },

  logout () {
    localStorage.removeItem('auth_token')
    localStorage.removeItem('user_type')
    this.loggedIn = false
  },

  user () {
    return {
      name: localStorage.getItem('user_name'),
      id: localStorage.getItem('user_id'),
      type: localStorage.getItem('user_type')
    }
  }
}
