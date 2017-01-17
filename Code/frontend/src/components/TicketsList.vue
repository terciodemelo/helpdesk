<template>
  <div class="tickets-list">

    <new-ticket @new-ticket="newTicket">
      <tickets-selection :selection="selection" 
                         :open="open" :closed="closed"
                         @toggle-open="toggleOpen"
                         @toggle-closed="toggleClosed"
                         @selection-update="selectionUpdate">
      </tickets-selection>

      <button :class="exportVisibility()" id="export" class="button" 
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
  props: ['tickets'],
  data () {
    return {
      selection: 'all',
      open: true,
      closed: true
    }
  },
  created () {
    let status = this.$route.query.status
    this.selection === this.$route.query.since || 'all'

    if (status && status === 'OPEN') {
      this.closed = false
    } else if (status && status === 'CLOSED') {
      this.open = false
    }
  },
  methods: {
    exportVisibility () {
      return AuthHelper.isCustomer() ? 'hidden' : ''
    },
    exportPDF () {
      let report = PDF('p', 'pt', 'letter')
      report.fromHTML(document.getElementById('tickets'), 15, 15, {
        width: 500
      })
      report.save('tickets-report.pdf')
    },
    newTicket (payload) {
      let headers = AuthHelper.jsonHeaders()

      this.$http.post('/api/tickets', payload, {headers})
                .then(response => { // success
                  this.$emit('new-ticket', response.body)
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
      this.fixQueryString()
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
      let since = this.selection === 'all' ? -1
                  : this.selection === 'last_month' ? 31
                  : this.selection === 'last_week' ? 7 : 1

      let creation = new Date(ticket.created_at)
      let beginning = new Date()
      beginning.setDate(beginning.getDate() - since)

      return ((ticket.status === 'CLOSED' && this.closed) ||
             (ticket.status === 'OPEN' && this.open)) &&
             (since === -1 || creation >= beginning)
    },
    fixQueryString () {
      let query = this.selection === 'all'
                  ? {} : {since: this.selection}

      if (this.closed && !this.open) {
        query.status = 'CLOSED'
      } else if (this.open && !this.closed) {
        query.status = 'OPEN'
      }

      this.$router.replace({query})
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
