<template>
  <div class="tickets-list">

    <new-ticket @new-ticket="newTicket">
      <button v-if="!isCustomer()" id="export" class="button" 
              @click.prevent="exportPDF">
        Export
      </button>
    </new-ticket>

    <div id="tickets">
      <ticket-resume v-for="ticket in tickets" 
                     :ticket="ticket"
                     @ticket-update="ticketUpdate">
      </ticket-resume>
    </div>
  </div>
</template>

<script>
import NewTicket from './tickets-list-elements/NewTicket'
import TicketResume from './tickets-list-elements/TicketResume'
import AuthHelper from '../helpers/auth_helper'

import PDF from 'jspdf'

export default {
  name: 'tickets-list',
  watch: {
    '$route': 'fetchTickets'
  },
  data () {
    return {
      tickets: []
    }
  },
  created () {
    this.fetchTickets()
  },
  methods: {
    isCustomer () {
      return AuthHelper.isCustomer()
    },
    exportPDF () {
      let report = PDF('p', 'pt', 'letter')
      report.fromHTML(document.getElementById('tickets'), 15, 15, {
        width: 500
      })
      report.save('tickets-report.pdf')
    },
    fetchTickets () {
      let headers = AuthHelper.jsonHeaders()

      let url = '/api/tickets'
      let params = {
        status: this.$route.query.status
      }

      this.$http.get(url, {headers, params})
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
    },
    ticketUpdate (newTicket) {
      this.tickets.forEach((element, index, array) => {
        if (element.id === newTicket.id) {
          array[index].status = newTicket.status
        }
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
