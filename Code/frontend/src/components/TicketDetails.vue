<template>
  <div class="ticket-details">
    <div v-if="ticket" id="resume">
      <ticket-resume :ticket="ticket" @ticket-update="ticketUpdate">
      </ticket-resume>

      <ticket-response v-for="response in ticket_responses"
                       :class="responseAlignment(response)"
                       :response="response">
      </ticket-response>
    </div>

    <div v-else>
      <a class="button is-loading"></a>
      <br> Loading...
    </div>


    <new-ticket-response @new-response="newResponse">
    </new-ticket-response>
  </div>
</template>

<script>
import TicketResume from './tickets-list-elements/TicketResume'
import NewTicketResponse from './tickets-list-elements/NewTicketResponse'
import TicketResponse from './tickets-list-elements/TicketResponse'
import AuthHelper from '../helpers/auth_helper'

export default {
  name: 'ticket-details',
  data () {
    return {
      /*
       * Stores an object for this view's ticket, which is forwarded
       * to a TicketResume component
       */
      ticket: null,

      /*
       * Stores all the responses for this view's ticket, which each one
       * will be forwarded to a TicketResponse component
       */
      ticket_responses: []
    }
  },
  /*
   * This creation hook simply calls the function 'fetchTicket' which
   * will update the 'ticket' and 'ticket_responses' attributes
   *
   * @see fetchTicket
   */
  created () {
    this.fetchTicket()
  },
  methods: {
    /*
     * Fetch the ticket to be detailed in the current view, upon
     * successfully retrieving the ticket, it stores the received
     * ticket in 'ticket' attribute and then calls 'fetchTicketResponses'
     *
     * @see ticket
     * @see fetchTicketResponses
     */
    fetchTicket () {
      let headers = AuthHelper.jsonHeaders()

      this.$http.get(`/api/tickets/${this.$route.params.id}`, {headers})
                .then(response => {
                  this.ticket = response.body
                  this.fetchTicketResponses()
                }, response => {
                  console.log(response.body)
                })
    },

    /*
     * Fetch the ticket responses to be listed in the current view, upon
     * successfully retrieving them, they are stored in 'ticket_responses'
     * attribute
     *
     * @see ticket
     * @see fetchTicketResponses
     */
    fetchTicketResponses () {
      let headers = AuthHelper.jsonHeaders()
      let url = `/api/tickets/${this.$route.params.id}/ticket_responses`

      this.$http.get(url, {headers})
                .then(response => {
                  this.ticket_responses = response.body
                }, response => {
                  console.log(response.body)
                })
    },

    /*
     * Submits the creating of a ne ticket response to the API server
     * through a POST request to /api/tickets/:ticket_id/ticket_responses
     * and upond a sucessful response, it updates the 'ticket' and
     * 'ticket_responses' attributes accordingly
     *
     * @param [Object] response
     * @see ticket
     * @see ticket_responses
     */
    newResponse (response) {
      let headers = {
        'Content-Type': 'application/json',
        'Authorization': AuthHelper.authorizationHeader()
      }
      let url = `/api/tickets/${this.ticket.id}/ticket_responses`

      this.$http.post(url, {body: response}, {headers})
                .then(response => {
                  this.ticket_responses.push(response.body)
                  this.ticket.responses_count += 1
                }, response => {
                  console.log(response.body)
                })
    },

    /*
     * Updates the 'ticket' attribute with the ticket passed as parameter
     *
     * @param [Object] newTicket
     * @see ticket
     */
    ticketUpdate (newTicket) {
      this.ticket.status = newTicket.status
    },

    /*
     * Returns the CSS class name for a given response, according with
     * the authory of the given response is of the currently logged in
     * user or not. If it is, then the return will be 'response-right'
     * and 'response-left' otherwise
     *
     * @param [Object] response
     * @return String 'response-right' if the current user is the response
     *                author and 'response-left' otherwise
     */
    responseAlignment (response) {
      return response.author_id === +AuthHelper.user().id
             ? 'response-right' : 'response-left'
    }
  },
  components: {
    TicketResume,
    NewTicketResponse,
    TicketResponse
  }
}
</script>

<style scoped>
.ticket-details {
  display: flex;
  flex-direction: column;
  margin-top: 60px;
}

#resume {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  width: 100%;
}

.ticket-resume {
  margin-bottom: 10px;
  width: 100%
}

.ticket-response {
  width: 85%;
  margin-bottom: 10px;
  text-align: left;
}

.response-right {
  align-self: flex-end;
}

.response-left {
  align-self: flex-start;
}

.new-ticket-response {
  align-self: center;
}

.is-loading {
  border: none;
}
</style>
