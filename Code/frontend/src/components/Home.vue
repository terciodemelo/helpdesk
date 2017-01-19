<template>
  <div class="home">
    <div id="welcome-message" class="content">
      <h1>Wellcome to Customer Support</h1>
      <p>
        Here you will be able to create support tickets
        and talk to our support agents in order to solve
        any kind of problem you have
      </p>
      <p>First of all, login or create a new account below</p>
    </div>

    <login-form v-if="!loggedIn() && form === 'login'"
                @login-successful="loginSuccessful"
                @follow-link="swapForm">
    </login-form>

    <register-form v-else-if="!loggedIn() && form === 'register'"
                   @follow-link="swapForm">
    </register-form>
  </div>
</template>

<script>
import LoginForm from './LoginForm'
import RegisterForm from './RegisterForm'

import AuthHelper from '../helpers/auth_helper'

export default {
  name: 'home',
  data () {
    return {
      /*
       * Indicates the form which will be rendered in this view.
       * if it's value is 'login', then a LoginForm component will
       * be rendered, and a RegisterForm will be rendered otherwise
       */
      form: 'login'
    }
  },
  methods: {

    /*
     * Simple encapsulates a call to AuthHelper#isLoggedIn
     *
     * @return [boolean] true if is logged in, and false otherwise
     */
    loggedIn () {
      return AuthHelper.isLoggedIn()
    },

    /*
     * Callback of a successful login, trigered by a 'login-successful'
     * event
     */
    loginSuccessful (payload) {
      AuthHelper.login(payload)
      this.$router.push('/tickets')
    },

    /*
     * Swaps the currently rendered form by toggling the 'form' attribute
     * between 'login' and 'register'
     */
    swapForm () {
      this.form = this.form === 'login' ? 'register' : 'login'
    }
  },
  components: {
    LoginForm,
    RegisterForm
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.home {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding-top: 100px;
}

.content {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.content > p {
  max-width: 60%;
}

h1, h2 {
  font-weight: normal;
}

ul {
  list-style-type: none;
  padding: 0;
}

li {
  display: inline-block;
  margin: 0 10px;
}
</style>
