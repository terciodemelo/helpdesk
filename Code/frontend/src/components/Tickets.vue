<template>
  <div class="tickets">
    <tickets-list :tickets="tickets" @new-ticket="newTicket">
    </tickets-list>
  </div>
</template>

<script>
import AuthHelper from '../helpers/auth_helper'
import TicketsList from './TicketsList'

export default {
  name: 'tickets',
  data () {
    return {
      /*
       * This attribute keeps all tickets that might be visible in the
       * current view. It is actualy forwarded to the TicketsList component
       * which will use it's own criterea to display or hide them
       *
       * @see TicketsList
       */
      tickets: []
    }
  },

  /*
   * This creation hook simply calls the function 'fetchTickets' which
   * will update the 'tickets'
   *
   * @see fetchTickets
   */
  created () {
    this.fetchTickets()
  },

  methods: {
    /*
     * This function takes a ticket as parameters and puts it in the
     * beginning of the 'tickets' array. It is used to respond the
     * 'new-ticket' event emitted by TicketsList component
     *
     * @see TicketsList
     */
    newTicket (ticket) {
      this.tickets.unshift(ticket)
    },

    /*
     * This function makes an HTTP Ajax request to /api/tickets
     * to retrieve all tickets the current user has access to.
     * Upon receiving the data, it sets the 'tickets' attribute
     * with it.
     */
    fetchTickets () {
      let headers = AuthHelper.jsonHeaders()

      let url = '/api/tickets'

      this.$http.get(url, {headers})
                .then(response => {
                  response.body.sort((t1, t2) => {
                    return new Date(t2.created_at) - new Date(t1.created_at)
                  })
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
.tickets {
  padding-top: 50px;
}
</style>
