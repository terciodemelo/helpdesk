<template>
  <div class="login-form">
    <form class="box" action="/api/login">
      <input class="input" id="email" type="text"
             v-model="email" placeholder="email@address.here">
      <input class="input" id="password" type="password"
             v-model="password" placeholder="Password">

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
      email: '',
      password: ''
    }
  },
  methods: {
    followLink () {
      this.$emit('follow-link')
    },
    submit () {
      let payload = { password: this.password, email: this.email }
      let headers = { 'Content-Type': 'application/json' }

      this.$http.post('/api/login', payload, headers)
                .then(response => { // success
                  this.$emit('login-successful',
                    response.body.auth_token,
                    response.body.user.type
                  )
                }, response => {
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
