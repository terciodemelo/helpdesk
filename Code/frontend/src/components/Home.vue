<template>
  <div class="home">
    <div id="welcome-message">
      Wellcome message
    </div>

    <login-form></login-form>
  </div>
</template>

<script>
import LoginForm from './LoginForm'

export default {
  name: 'home',
  data () {
    return {
      msg: 'Welcome to Your Vue.js App'
    }
  },
  components: {
    LoginForm
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
