<template>
  <div class="ticket-resume">
    <div class="box">
      <article class="media">
        <div class="media-content">
          <p>
            <strong>
              <a :href="ticket_url"> {{ ticket.title }} </a>
            </strong>
            <span v-if="ticket.status === 'OPEN'" class="tag is-success"> OPEN </span>
            <span v-else class="tag is-danger"> CLOSED </span>
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
  }
}
</script>

<style scoped>
pre {
  background-color: transparent;
}

.tag {
  float: right;
}
</style>
