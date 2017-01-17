<template>
  <div class="users-list">
    <table class="table">
      <thead>
        <tr>
          <th><abbr title="ID">ID</abbr></th>
          <th><abbr title="Name">Name</abbr></th>
          <th><abbr title="@">Email</abbr></th>
          <th><abbr title="OT">Open Tickets</abbr></th>
          <th><abbr title="CT">Closed Tickets</abbr></th>
          <th><abbr title="TT">Total Tickets</abbr></th>
          <th></th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="user in users">
          <th> {{ user.id }} </th>
          <td> {{ user.name }} </td>
          <td> {{ user.email }} </td>
          <td> {{ user.open_tickets }} </td>
          <td> {{ user.closed_tickets }} </td>
          <td> {{ total(user.open_tickets, user.closed_tickets) }} </td>
          <td>
            <button class="button is-danger is-small">
              <span class="icon is-small">
                <i class="fa fa-times"></i>
              </span>
            </button>
          </td>
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
                    return (+t1.id) - (+t2.id)
                  })

                  this.users = response.body
                }, response => {
                  console.log(response.body)
                })
    },
    total (openTickets, closedTickets) {
      return openTickets === null
             ? null : openTickets + closedTickets
    }
  }
}
</script>

<style scoped>
.users-list {
  padding-top: 100px;
}

td {
  text-align: center;
}
</style>
