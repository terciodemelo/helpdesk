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
          <td> 
            <strong>
              <router-link :to="userDetails(user.id)">
                {{ user.name }}
              </router-link>
            </strong>
          </td>
          <td> {{ user.email }} </td>
          <td> {{ user.open_tickets }} </td>
          <td> {{ user.closed_tickets }} </td>
          <td> {{ total(user.open_tickets, user.closed_tickets) }} </td>
          <td>
            <a class="button is-danger is-small"
                    @click.prevent="remove(user.id)">
              <span class="icon is-small">
                <i class="fa fa-times"></i>
              </span>
            </a>
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
    remove (userId) {
      let headers = AuthHelper.jsonHeaders()
      let url = `/api/users/${userId}`

      this.$swal({
        title: 'Are you sure?',
        text: 'You cannot recover a removed user',
        type: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#dd6b55',
        confirmButtonText: 'Yes, delete!'
      }).then(result => {
        this.$http.delete(url, {headers})
                  .then(response => {
                    this.$swal('Deleted!', `User ${userId} has been deleted.`, 'success')
                    this.users = this.users.filter(u => u.id !== userId)
                  }, response => {
                    console.log(response.body)
                  })
      }, () => {})
    },
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
    },
    userDetails (userId) {
      return `/users/${userId}`
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
