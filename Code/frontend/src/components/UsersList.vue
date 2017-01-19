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
  /*
   * This creation hook simply calls the functions 'fetchUsers'
   * to retrieve the data to be stored in the attribute
   * 'users'
   *
   * @see users
   */
  created () {
    this.fetchUsers()
  },
  methods: {
    /*
     * This function handles the deletion of a user by making a HTTP
     * DELETE request to /api/users/:id after a SweetAlert2 confirmation
     * and upon a successful response, updates the 'users' component
     * attribute accordingly
     */
    remove (userId) {
      let headers = AuthHelper.jsonHeaders()
      let url = `/api/users/${userId}`

      this.$swal({
        title: 'Are you sure?',
        text: 'You cannot recover a removed user',
        type: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#ff3860',
        confirmButtonText: 'Yes, delete!'
      }).then(result => {
        this.$http.delete(url, {headers})
                  .then(response => {
                    this.$swal({
                      title: 'Deleted!',
                      text: `User ${userId} has been deleted.`,
                      type: 'success',
                      confirmButtonColor: '#00d1b2'
                    })
                    this.users = this.users.filter(u => u.id !== userId)
                  }, response => {
                    console.log(response.body)
                  })
      }, () => {})
    },

    /*
     * This function fetches all users through an HTTP Ajax request to
     * /api/users, and upon a successful response it updates the 'users'
     * attribute
     */
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

    /*
     * This methods returns the sum of the two provided numeric values.
     * If one of them is null them null is returned. It is used to
     * fill the "Total Tickets" column in the users table
     */
    total (openTickets, closedTickets) {
      return openTickets === null
             ? null : openTickets + closedTickets
    },

    /*
     * Returns the URL path to a user given its id
     */
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

td, abbr {
  text-align: center;
}
</style>
