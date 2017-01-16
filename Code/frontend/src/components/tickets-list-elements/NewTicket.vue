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

        <div id="cancel-or-create">
          <button class="button" @click.prevent="toggleForm">
            Cancel
          </button>
          <button class="button">Create Ticket</button>
        </div>
      </form>

      <div v-else id="menu">
        <button class="button" 
                :class="visibility()"
                @click.prevent="toggleForm">
          New Ticket
        </button>
        <slot></slot>
      </div>
    </transition>

  </div>
</template>

<script>
import AuthHelper from '../../helpers/auth_helper'

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
    },
    visibility () {
      return AuthHelper.isCustomer() ? '' : 'hidden'
    }
  }
}
</script>

<style scoped>
#menu {
  display: flex;
  justify-content: space-between;
  width: 100%;
}

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
