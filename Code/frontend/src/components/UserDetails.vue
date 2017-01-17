<template>
  <div class="user-details">
  </div>
</template>

<script>
import AuthHelper from '../helpers/auth_helper'

export default {
  name: 'user-details',
  data () {
    return {
      user: null
    }
  },
  created () {
    this.fetchUser()
  },
  methods: {
    fetchUser () {
      let headers = AuthHelper.jsonHeaders()

      this.$http.get(`/api/users/${this.$route.params.id}`, {headers})
                .then(response => {
                  this.user = response.body
                }, response => {
                  console.log(response.body)
                })
    }
  }
}
</script>

<style scoped>
</style>
