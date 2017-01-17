<template>
  <div class="ticket-response">
    <div class="box" :class="getStyle()">
      <small>
        <strong id="name"> {{ response.author_name }} </strong>
        in
        <strong> 
          {{ response.created_at | moment("MMMM Do YYYY, hh:mm:ss") }}
        </strong>
      </small>
      <pre>{{ response.body }}</pre>
    </div>
  </div>
</template>

<script>
import AuthHelper from '../../helpers/auth_helper'

export default {
  name: 'ticket-response',
  props: ['response'],
  methods: {
    getStyle () {
      return this.response.author_id === +AuthHelper.user().id
             ? 'user-response' : ''
    }
  }
}
</script>

<style scoped>
.box {
  padding-top: 3px;
}

.user-response #name {
  color: dodgerblue;
}

#name {
  color: cornflowerblue;
}

pre {
  background-color: transparent;
}
</style>
