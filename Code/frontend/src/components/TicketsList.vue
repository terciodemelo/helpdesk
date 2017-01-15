<template>
  <div class="tickets-list">
    <new-ticket @new-ticket="newTicket"></new-ticket>

    <ticket-resume v-for="ticket in tickets" :ticket="ticket">
    </ticket-resume>
  </div>
</template>

<script>
import NewTicket from './tickets-list-elements/NewTicket'
import TicketResume from './tickets-list-elements/TicketResume'
import AuthHelper from '../helpers/auth_helper'

export default {
  name: 'tickets-list',
  data () {
    return {
      tickets: []
    }
  },
  created () {
    this.fetchTickets()
  },
  methods: {
    fetchTickets () {
      let headers = {
        'Content-Type': 'application/json',
        'Authorization': AuthHelper.authorizationHeader()
      }

      this.$http.get('/api/tickets', {headers})
                .then(response => {
                  response.body.reverse()
                  this.tickets = response.body
                }, response => {
                  console.log(response.body)
                })
    },
    newTicket (payload) {
      let headers = {
        'Content-Type': 'application/json',
        'Authorization': AuthHelper.authorizationHeader()
      }

      this.$http.post('/api/tickets', payload, {headers})
                .then(response => { // success
                  this.tickets.unshift(response.body)
                  console.log(this.tickets)
                }, response => { // failure
                  console.log(response.body)
                })
    }
  },
  components: {
    NewTicket,
    TicketResume
  }
}
</script>

<style scoped>
.tickets-list {
  padding-top: 50px;
}

.ticket-resume, .new-ticket {
  margin-bottom: 10px;
}
</style>
