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
      tickets: []
    }
  },
  created () {
    this.fetchTickets()
  },
  methods: {
    newTicket (ticket) {
      this.tickets.unshift(ticket)
    },
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
