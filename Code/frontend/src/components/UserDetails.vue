<template>
  <div class="user-details">
    <div class="content">
      <h1 v-if="user">{{ user.name }}'s Tickets</h1>
      <span v-if="user"> {{ user.email }} </span>
    </div>
    <tickets-list :tickets="tickets"></tickets-list>
  </div>
</template>

<script>
import AuthHelper from '../helpers/auth_helper'
import TicketsList from './TicketsList'

export default {
  name: 'user-details',
  data () {
    return {
      user: null,
      tickets: []
    }
  },
  created () {
    this.fetchUser()
    this.fetchTickets()
  },
  methods: {
    fetchUser () {
      let headers = AuthHelper.jsonHeaders()

      this.$http.get(`/api/users/${this.$route.params.id}`, {headers})
                .then(response => {
                  this.user = response.body
                }, response => {
                  console.log(response.body)
                })
    },
    fetchTickets () {
      let headers = AuthHelper.jsonHeaders()
      let url = `/api/users/${this.$route.params.id}/tickets`

      this.$http.get(url, {headers})
                .then(response => {
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
.user-details {
  padding-top: 20px;
}
</style>
