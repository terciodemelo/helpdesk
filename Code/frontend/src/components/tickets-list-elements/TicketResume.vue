<template>
  <div class="ticket-resume">
    <div class="box">
      <article class="media">
        <div class="media-content">
          <p>
            <strong>
              <router-link :to="ticket_url"> {{ ticket.title }} </router-link>
            </strong>
            <a v-if="ticket.status === 'OPEN'" 
               @click.prevent="toggleStatus"
               class="tag is-primary"> OPEN </a>
            <a v-else class="tag is-danger"
               @click.prevent="toggleStatus"> CLOSED </a>
            <br>
            <small>
              Created by <strong>{{ ticket.author_name }}</strong>
              in <strong>{{ creation_date }}</strong>
            </small>
            <pre>{{ ticket.body }}</pre>
          </p>
        </div>
      </article>
    </div>
  </div>
</template>

<script>
import AuthHelper from '../../helpers/auth_helper'

export default {
  name: 'ticket-resume',
  props: ['ticket'],
  computed: {
    ticket_url: function () {
      return `/tickets/${this.ticket.id}`
    },
    creation_date: function () {
      return new Date(this.ticket.created_at).toDateString()
    }
  },
  methods: {
    toggleStatus () {
      let status = this.ticket.status === 'OPEN' ? 'CLOSED' : 'OPEN'
      let url = `/api/tickets/${this.ticket.id}`
      let payload = {ticket: {status}}
      let headers = AuthHelper.jsonHeaders()

      this.$http.patch(url, payload, {headers})
                .then(response => {
                  this.$emit('ticket-update', response.body)
                }, response => {
                  console.log(response.body)
                })
    }
  }
}
</script>

<style scoped>
pre {
  background-color: transparent;
  white-space: pre-wrap;       /* Since CSS 2.1 */
  white-space: -moz-pre-wrap;  /* Mozilla, since 1999 */
  white-space: -pre-wrap;      /* Opera 4-6 */
  white-space: -o-pre-wrap;    /* Opera 7 */
  word-wrap: break-word;       /* Internet Explorer 5.5+ */
}

.tag {
  float: right;
}
</style>
