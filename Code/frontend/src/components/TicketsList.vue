<template>
  <div class="tickets-list">

    <new-ticket @new-ticket="newTicket">
      <tickets-selection :selection="selection" 
                         :open="open" :closed="closed"
                         @toggle-open="toggleOpen"
                         @toggle-closed="toggleClosed"
                         @selection-update="selectionUpdate">
      </tickets-selection>

      <button v-if="!isCustomer()" id="export" class="button" 
              @click.prevent="exportPDF">
        Export
      </button>
    </new-ticket>

    <div id="tickets">
      <ticket-resume v-for="ticket in tickets" 
                     v-if="visible(ticket)"
                     :ticket="ticket"
                     @ticket-update="ticketUpdate">
      </ticket-resume>
    </div>
  </div>
</template>

<script>
import NewTicket from './tickets-list-elements/NewTicket'
import TicketResume from './tickets-list-elements/TicketResume'
import TicketsSelection from './tickets-list-elements/TicketsSelection'
import AuthHelper from '../helpers/auth_helper'

import PDF from 'jspdf'

export default {
  name: 'tickets-list',
  data () {
    return {
      tickets: [],
      selection: 'all',
      open: true,
      closed: true
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
                  response.body.sort((t1, t2) => {
                    [t1.created_at, -t1.id] > [t2.created_at, -t2.id]
                  })
                  this.tickets = response.body
                }, response => {
                  console.log(response.body)
                })
    },
    newTicket (payload) {
      let headers = AuthHelper.jsonHeaders()

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
    },
    selectionUpdate (selection) {
      this.selection = selection
    },
    toggleOpen () {
      this.open = !this.open
      this.fixQueryString()
    },
    toggleClosed () {
      this.closed = !this.closed
      this.fixQueryString()
    },
    visible (ticket) {
      return (ticket.status === 'CLOSED' && this.closed) ||
             (ticket.status === 'OPEN' && this.open)
    },
    fixQueryString () {
      if (this.open && this.closed) {
        this.$router.replace({query: {}})
      } else if (this.closed) {
        this.$router.replace({query: {status: 'CLOSED'}})
      } else if (this.open) {
        this.$router.replace({query: {status: 'OPEN'}})
      } else {
        this.$router.replace({query: {}})
      }
    }
  },
  components: {
    NewTicket,
    TicketResume,
    TicketsSelection
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

.tabs {
  margin-bottom: 0px !important;
}
</style>
