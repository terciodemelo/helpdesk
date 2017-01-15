<template>
  <div class="home">
    <div id="welcome-message">
      Wellcome message
    </div>

    <login-form v-if="form === 'login'"></login-form>
    <register-form v-else-if="form === 'register'"></register-form>
  </div>
</template>

<script>
import LoginForm from './LoginForm'
import RegisterForm from './RegisterForm'

export default {
  name: 'home',
  data () {
    return {
      form: 'register'
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
