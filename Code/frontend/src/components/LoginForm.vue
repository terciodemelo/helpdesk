<template>
  <div class="login-form">
    <form class="box" action="/api/login">
      <p class="control has-icon">
        <input class="input" id="email" type="email"
               :class="not_found ? 'is-danger' : ''"
               v-model="email" placeholder="Email">
        <span class="icon is-small">
          <i class="fa fa-envelope"></i>
        </span>
        <span class="help is-danger"
              :class="not_found ? '' : 'absent'">
          This email address is not registered
        </span>
      </p>

      <p class="control has-icon">
        <input class="input" id="password" type="password"
               :class="wrong_password ? 'is-danger' : ''"
               v-model="password" placeholder="Password">
        <span class="icon is-small">
          <i class="fa fa-lock"></i>
        </span>
        <span class="help is-danger"
              :class="wrong_password ? '' : 'absent'">
          Wrong password
        </span>
      </p>

      <form-footer :button="'Login'" 
                   @button-click="submit"
                   :link="'Register new account'"
                   @follow-link="followLink">
      </form-footer>
    </form>
  </div>
</template>

<script>
import FormFooter from './FormFooter'

export default {
  name: 'login-form',
  data () {
    return {
      /*
       * Stores the user's email
       */
      email: '',

      /*
       * Stores the user's password
       */
      password: '',

      /*
       * true if the user is not found upon form submission, false otherwise
       */
      not_found: false,

      /*
       * true if the password is wrong upon form submission, false otherwise
       */
      wrong_password: false
    }
  },
  methods: {
    /*
     * Emits upward the event 'follow-link' which shall be treated by the
     * enclosing component
     */
    followLink () {
      this.$emit('follow-link')
    },

    /*
     * Handles the form submission and if successfull emits the
     * 'login-successful' event, which should be handled by a enclosing
     * component, or indicates the submission problem otherwise
     */
    submit () {
      let payload = { password: this.password, email: this.email }
      let headers = { 'Content-Type': 'application/json' }

      this.$http.post('/api/login', payload, headers)
                .then(response => { // success
                  let payload = {
                    auth_token: response.body.auth_token,
                    user_type: response.body.user.type,
                    user_name: response.body.user.name,
                    user_id: response.body.user.id
                  }

                  this.$emit('login-successful', payload)
                }, response => { // failure
                  this.not_found = response.status === 404
                  this.wrong_password = response.status === 401
                  console.log(response.body)
                })
    }
  },
  components: {
    FormFooter
  }
}
</script>

<style scoped>
.login-form {
  display: flex;
  flex-direction: column;
  justify-content: center;
}

form {
  display: flex;
  flex-direction: column;
  width: 300px;
}

form > input {
  margin-bottom: 15px;
}

#form-footer {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
}

#form-footer-links > a {
  color: $orange;
}

#form-footer-links {
  display: flex;
  flex-direction: column;
  font-size: small;
}
</style>
