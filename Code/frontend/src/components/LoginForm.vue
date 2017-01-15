<template>
  <div class="login-form">
    <form class="box" action="/api/login">
      <input class="input" id="email" type="text" name="email" placeholder="email@address.here">
      <input class="input" id="password" type="password" name="password" placeholder="password">

      <div id="form-footer">
        <a class="button">Login</a>
        <div id="form-footer-links">
          <a href="">Register new account</a>
          <a href="">Forgot my password</a>
        </div>
      </div>
    </form>
  </div>
</template>

<script>
export default {
  name: 'login-form'
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
