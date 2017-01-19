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
      /**
       * This attribute defines which component should be visible acording
       * to their creation date, for the following possible values:
       *
       * 'all' -> all tickets
       * 'last_month' -> tickets created in the past 30 days
       * 'last_week' -> tickets created in the past 7 days
       * 'today' -> tickets created in the past 24 hours
       */
      selection: 'all',

      /**
       * This attribute defines which component should be visible acording
       * to their status, for the following possible values:
       *
       * true -> open tickets are visible
       * false -> open tickets are not visible
       */
      open: true,

      /**
       * This attribute defines which component should be visible acording
       * to their status, for the following possible values:
       *
       * true -> closed tickets are visible
       * false -> closed tickets are not visible
       */
      closed: true
    }
  },
  /*
   * Once the component is created, this hook checks the page query string
   * for the 'status' and 'since' fields. The 'selection' attribute is
   * updated according to the 'since' field, and the 'open' and 'closed'
   * attributes are updated according to the 'status' field.
   */
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
    /*
     * Makes use of AuthHelper to return a CSS class value to be used
     * in elements that must not be seen to users. In this case, the
     * class is 'hidden' and the element that uses this function to
     * bind to it's class field is button#export
     */
    exportVisibility () {
      return AuthHelper.isCustomer() ? 'hidden' : ''
    },

    /*
     * This function exports the contents of #tickets element to PDF,
     * making use of the 'jsPDF' library importent here as 'PDF'. The
     * element button#export binds it's 'onclick' event to this function
     */
    exportPDF () {
      let report = PDF('p', 'pt', 'letter')
      report.fromHTML(document.getElementById('tickets'), 15, 15, {
        width: 500
      })
      report.save('tickets-report.pdf')
    },

    /*
     * This function handles a new ticket submission by taking as parameter
     * an object to be used as json payload in a POST HTTP request to
     * /api/tickets by Ajax. If this request is successful the component
     * will emit upwards the event 'new-ticket' alongwith the received
     * response body
     *
     * @param [Object] payload
     */
    newTicket (payload) {
      let headers = AuthHelper.jsonHeaders()

      this.$http.post('/api/tickets', payload, {headers})
                .then(response => { // success
                  this.$emit('new-ticket', response.body)
                }, response => { // failure
                  console.log(response.body)
                })
    },

    /*
     * This function updates one of it's ticket's status, by receiving
     * a ticket is parameter and matching it by ID. This is not the best
     * way possible to do this kind of operation, but our data model
     * has imposed this constraint on us. A future refactoring may be
     * a good idea. This function handles the event 'ticket-update'
     * emitted by a TicketResume component
     */
    ticketUpdate (newTicket) {
      this.tickets.forEach((element, index, array) => {
        if (element.id === newTicket.id) {
          array[index].status = newTicket.status
        }
      })
    },

    /*
     * This function updates the value of 'selection' attribute, which
     * is used to filter the tickets that must be shown to the user.
     * It handles the 'selection-update' event emitted by TicketsSelection
     * component. It also calls 'fixQueryString()' to update the query
     * string
     *
     * @see fixQueryString
     */
    selectionUpdate (selection) {
      this.selection = selection
      this.fixQueryString()
    },

    /*
     * This function toggles the boolean value of 'open' attribute, which
     * is used to filter the tickets that must be shown to the user.
     * It handles the 'toggle-open' event emitted by TicketsSelection
     * component. It also calls 'fixQueryString()' to update the query
     * string
     *
     * @see fixQueryString
     */
    toggleOpen () {
      this.open = !this.open
      this.fixQueryString()
    },

    /*
     * This function toggles the boolean value of 'closed' attribute, which
     * is used to filter the tickets that must be shown to the user.
     * It handles the 'toggle-closed' event emitted by TicketsSelection
     * component. It also calls 'fixQueryString()' to update the query
     * string
     *
     * @see fixQueryString
     */
    toggleClosed () {
      this.closed = !this.closed
      this.fixQueryString()
    },

    /*
     * This function takes a ticket object as parameter, and decides if
     * the ticket should be visible by comparing it's attributes with the
     * 'selection', 'open', and 'closed' component attributes.
     *
     * @see open [boolean]
     * @see closed [boolean]
     * @see selection [String]
     */
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

    /*
     * This function updates the current query string to match
     * the values of 'open', 'closed', and 'selection' attributes
     * in this component
     *
     * @see open [boolean]
     * @see closed [boolean]
     * @see selection [String]
     */
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
.ticket-resume, .new-ticket {
  margin-bottom: 10px;
}

.tabs {
  margin-bottom: 0px !important;
}
</style>
