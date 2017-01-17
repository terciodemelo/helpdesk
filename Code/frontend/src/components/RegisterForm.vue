<template>
  <div class="register-form">
    <form class="box" action="/api/users" @submit.prevent="submit">
      <p class="control has-icon">
      <input class="input" type="text" name="name" 
             v-model="name" placeholder="Your full name">
      <span class="icon is-small">
        <i class="fa fa-user-o"></i>
      </span>
      </p>

      <p class="control has-icon">
      <input class="input" type="email" name="email" 
             :class="conflict ? 'is-danger' : ''"
             v-model="email" placeholder="Email">
      <span class="icon is-small">
        <i class="fa fa-envelope"></i>
      </span>
      <span class="help is-danger"
            :class="conflict ? '' : 'absent'">
        This email is already taken
      </span>
      </p>

      <p class="control has-icon">
      <input class="input" type="password" name="password" 
             v-model="password" placeholder="Password">
      <span class="icon is-small">
        <i class="fa fa-lock"></i>
      </span>
      </p>

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
      password: '',
      conflict: false
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
                  this.conflict = response.status === 409
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
