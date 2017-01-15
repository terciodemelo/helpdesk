<template>
  <div class="new-ticket">
    <transition mode="out-in">
      <form v-if="formVisible" class="new-ticket-form" action="" 
            @submit.prevent="submit">

        <input class="input" type="text" 
               v-model="title" placeholder="Ticket title">

        <textarea class="textarea" name="" rows="7"
                  v-model="body" placeholder="Ticket content">
        </textarea>

        <button class="button">Create Ticket</button>
      </form>

      <button v-else class="button" @click.prevent="toggleForm">
        New Ticket
      </button>
    </transition>

  </div>
</template>

<script>
export default {
  name: 'new-ticket',
  data () {
    return {
      title: '',
      body: '',
      formVisible: false
    }
  },
  methods: {
    submit () {
      let payload = {
        title: this.title,
        body: this.body,
        status: 'OPEN'
      }

      this.$emit('new-ticket', payload)
      this.title = ''
      this.body = ''
      this.formVisible = false
    },

    toggleForm () {
      this.formVisible = !this.formVisible
    }
  }
}
</script>

<style scoped>
.new-ticket {
  display: flex;
}

.new-ticket > button {
  margin-right: 10px;
}

.new-ticket-form {
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: flex-end;
}

.new-ticket-form > button {
  flex-basis: content;
}

.new-ticket-form > input, .new-ticket-form > textarea {
  width: 100%;
  margin-bottom: 10px;
}

</style>
