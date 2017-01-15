<template>
  <div id="app">
    <nav class="nav has-shadow">
      <div class="nav-left">
        <a class="nav-item is-tab" href="/">Home</a>
        <a class="nav-item is-tab" href="/tickets">Tickets</a>
      </div>
      <div class="nav-right">
        <a class="nav-item is-tab">Logout</a>
      </div>
    </nav>
    <div id="content">
      <router-view></router-view>
    </div>
  </div>
</template>

<script>
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
}
</style>
