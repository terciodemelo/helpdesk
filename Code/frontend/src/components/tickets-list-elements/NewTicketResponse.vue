<template>
  <div class="new-ticket-response">
    <form @submit.prevent="newResponse">
      <textarea v-model="response" class="textarea"></textarea>
      <button class="button">Respond</button>
    </form>
  </div>
</template>

<script>
export default {
  name: 'new-ticket-response',
  data () {
    return {
      response: ''
    }
  },
  methods: {
    newResponse () {
      this.$emit('new-response', this.response)
      this.response = ''
    }
  }
}
</script>

<style scoped>
.new-ticket-response {
  width: 85%;
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
