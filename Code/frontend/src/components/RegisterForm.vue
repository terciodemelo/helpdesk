<template>
  <div class="register-form">
    <form class="box" action="/api/users" @submit.prevent="submit">
      <input class="input" type="text" name="name" 
             v-model="name" placeholder="Your full name">
      <input class="input" type="email" name="email" 
             v-model="email" placeholder="email@address.here">
      <input class="input" type="password" name="password" 
             v-model="password" placeholder="Password">

      <form-footer :button="'Register'" 
                   @button-click="submit"
                   :link="'I already have an account'"
                   @follow-link="followLink">
      </form-footer>
    </form>
  </div>
</template>

<script>
import FormFooter from './FormFooter'

export default {
  name: 'register-form',
  data () {
    return {
      name: '',
      email: '',
      password: ''
    }
  },
  methods: {
    submit () {
      let payload = {
        name: this.name,
        email: this.email,
        password: this.password,
        type: 'Customer'
      }

      let headers = {
        'Content-Type': 'application/json'
      }

      this.$http.post('/api/users', payload, headers)
                .then(response => { // success
                  this.$emit('follow-link')
                }, response => {
                  console.log(response.body)
                })
    },
    followLink () {
      this.$emit('follow-link')
    }
  },
  components: {
    FormFooter
  }
}
</script>

<style scoped>
.register-form {
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
