<template>
  <div class="user-details">
    <div class="content">
      <h1 v-if="user">{{ user.name }}'s Tickets</h1>
      <span v-if="user"> {{ user.email }} </span>
    </div>
    <tickets-list :tickets="tickets"></tickets-list>
  </div>
</template>

<script>
import AuthHelper from '../helpers/auth_helper'
import TicketsList from './TicketsList'

export default {
  name: 'user-details',
  data () {
    return {
      /*
       * Stores a user object, which contains data to render this view's
       * contents
       */
      user: null,

      /*
       * Stores an array of tickets that belong to the user detailed
       * in the current view
       *
       * @see user
       */
      tickets: []
    }
  },
  /*
   * This creation hook simply calls the functions 'fetchUser' and
   * 'fetchTickets' to retrieve the data to be stored in the attributes
   * 'user' and 'tickets' respectively
   *
   * @see fetchUser
   * @see fetchTickets
   */
  created () {
    this.fetchUser()
    this.fetchTickets()
  },
  methods: {
    /*
     * Makes an HTTP Ajax call to /api/users/:id to retreive a json object
     * representing the user, and upon successfully retrieving the data
     * it is stored in the 'user' attribute
     */
    fetchUser () {
      let headers = AuthHelper.jsonHeaders()

      this.$http.get(`/api/users/${this.$route.params.id}`, {headers})
                .then(response => {
                  this.user = response.body
                }, response => {
                  console.log(response.body)
                })
    },

    /*
     * Makes an HTTP Ajax call to /api/users/:id/tickets to retreive a json
     * object containingc the users tickets, and upon successfully
     * retrieving the data, it is stored in the 'tickets' attributes, and
     * then forwarded to a TicketsList component
     */
    fetchTickets () {
      let headers = AuthHelper.jsonHeaders()
      let url = `/api/users/${this.$route.params.id}/tickets`

      this.$http.get(url, {headers})
                .then(response => {
                  this.tickets = response.body
                }, response => {
                  console.log(response.body)
                })
    }
  },
  components: {
    TicketsList
  }
}
</script>

<style scoped>
.user-details {
  padding-top: 20px;
}
</style>
