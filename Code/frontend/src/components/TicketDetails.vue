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
      ticket: null,
      ticket_responses: []
    }
  },
  methods: {
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
    ticketUpdate (newTicket) {
      this.ticket.status = newTicket.status
    },
    responseAlignment (response) {
      return response.author_id === +AuthHelper.user().id
             ? 'response-right' : 'response-left'
    }
  },
  created () {
    this.fetchTicket()
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
