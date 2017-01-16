<template>
  <div id="app">
    <nav class="nav has-shadow">
      <div class="nav-left">
        <router-link class="nav-item is-tab" to="/">
          Home
        </router-link>
        <router-link class="nav-item is-tab" to="/tickets">
          Tickets
        </router-link>
        <router-link class="nav-item is-tab" to="/tickets?status=CLOSED">
          Closed Tickets
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
    userName () {
      return localStorage.getItem('user_name')
    }
  }
}
</script>

<style>
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
