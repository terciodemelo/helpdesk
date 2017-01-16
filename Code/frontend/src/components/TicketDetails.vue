<template>
  <div class="ticket-details">
    <div v-if="ticket" id="resume">
      <ticket-resume :ticket="ticket" @ticket-update="ticketUpdate">
      </ticket-resume>

      <ticket-response v-for="response in ticket.ticket_responses"
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
      ticket: null
    }
  },
  methods: {
    fetchTicket () {
      let headers = AuthHelper.jsonHeaders()

      this.$http.get(`/api/tickets/${this.$route.params.id}`, {headers})
                .then(response => {
                  console.log(response.body)
                  this.ticket = response.body
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
                  this.ticket.ticket_responses.push(response.body)
                }, response => {
                  console.log(response.body)
                })
    },
    ticketUpdate (newTicket) {
      this.ticket.status = newTicket.status
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
  align-items: flex-end;
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

.is-loading {
  border: none;
}
</style>
