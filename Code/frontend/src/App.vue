<template>
  <div id="app">
    <nav class="nav has-shadow">
      <div class="nav-left">
        <router-link class="nav-item is-tab" to="/tickets"
                     :class="isLoggedIn() ? '' : 'hidden'">
          Tickets
        </router-link>
        <router-link class="nav-item is-tab" to="/users"
                     :class="isAdmin() ? '' : 'hidden'">
          Users
        </router-link>
      </div>

      <div v-if="isLoggedIn()" class="nav-right">
        <a class="nav-item"> Hello, {{ userName() }} </a>
        <a class="nav-item is-tab" @click="logout">Logout</a>
      </div>
    </nav>

    <div id="content">
      <router-view></router-view>
    </div>
  </div>
</template>

<script>
import AuthHelper from './helpers/auth_helper'

export default {
  methods: {
    logout () {
      AuthHelper.logout()
      this.$router.push('/')
    },
    isLoggedIn () {
      return AuthHelper.isLoggedIn()
    },
    isAdmin () {
      return AuthHelper.isAdmin()
    },
    userName () {
      return localStorage.getItem('user_name')
    }
  }
}
</script>

<style>
.hidden {
  visibility: hidden;
}

.absent {
	display: none !important;
}

nav {
  width: 100%;
}

#app {
  display: flex;
  flex-direction: column;
  align-items: center;
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}

#content {
  max-width: 50em;
  width: 100%;
}
</style>
