<template>
  <div class="tickets">
    <new-ticket @new-ticket="newTicket"></new-ticket>

    <ul>
      <li v-for="ticket in tickets">
        {{ ticket.title }}
        <br>
        {{ ticket.body }}
      </li>
    </ul>
  </div>
</template>

<script>
import NewTicket from './tickets-elements/NewTicket'
import AuthHelper from '../helpers/auth_helper'

export default {
  name: 'tickets',
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
                  this.tickets.unshift(payload)
                  console.log(this.tickets)
                }, response => { // failure
                  console.log(response.body)
                })
    }
  },
  components: {
    NewTicket
  }
}
</script>

<style scoped>
.tickets {
  padding-top: 50px;
}
</style>
