<template>
  <div class="register-form">
    <form class="box" action="/api/users">
      <input class="input" id="name" type="text" name="name" 
             placeholder="Your full name">
      <input class="input" id="email" type="email" name="email" 
             placeholder="email@address.here">
      <input class="input" id="password" type="password" name="password" 
             placeholder="Password">

      <form-footer :button="'Register'" 
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
  methods: {
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
