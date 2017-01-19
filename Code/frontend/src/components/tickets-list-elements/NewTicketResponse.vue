<template>
  <div class="new-ticket-response">
    <form @submit.prevent="newResponse">
      <textarea v-model="response" class="textarea"></textarea>
      <button class="button is-primary">Respond</button>
    </form>
  </div>
</template>

<script>
export default {
  name: 'new-ticket-response',
  data () {
    return {
      /*
       * Stores the response content
       */
      response: ''
    }
  },
  methods: {
    /*
     * Triggered when the evente the Respond button is clicked, then
     * it emits upward the event 'new-response' which shall be handled
     * by the enclosing component. It also resets the 'response' attribute
     * value to an empty string
     */
    newResponse () {
      this.$emit('new-response', this.response)
      this.response = ''
    }
  }
}
</script>

<style scoped>
.new-ticket-response {
  width: 100%;
}

.new-ticket-response > form {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
}

form > textarea {
  margin-bottom: 10px;
}
</style>
