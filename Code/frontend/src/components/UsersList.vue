<template>
  <div class="users-list">
    <table class="table">
      <thead>
        <tr>
          <th><abbr title="ID">ID</abbr></th>
          <th><abbr title="Name">Name</abbr></th>
          <th><abbr title="@">Email</abbr></th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="user in users">
          <th> {{ user.id }} </th>
          <td> {{ user.name }} </td>
          <td> {{ user.email }} </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
import AuthHelper from '../helpers/auth_helper'

export default {
  name: 'users-list',
  data () {
    return {
      users: []
    }
  },
  created () {
    this.fetchUsers()
  },
  methods: {
    fetchUsers () {
      let headers = AuthHelper.jsonHeaders()

      let url = '/api/users'

      this.$http.get(url, {headers})
                .then(response => {
                  response.body.sort((t1, t2) => {
                    return [t1.created_at, -t1.id] > [t2.created_at, -t2.id]
                  })
                  this.users = response.body
                }, response => {
                  console.log(response.body)
                })
    }
  }
}
</script>

<style scoped>
.users-list {
  padding-top: 100px;
}
</style>
