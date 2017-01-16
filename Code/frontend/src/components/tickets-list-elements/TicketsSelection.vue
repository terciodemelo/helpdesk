<template>
  <div class="tickets-selection">
    <div class="tabs is-toggle">
      <ul>
        <li :class="selection === 'all' ? 'is-active' : ''">
          <a id='all' @click.prevent="selectionUpdate($event)"> 
            All
          </a>
        </li>
        <li :class="selection === 'last_month' ? 'is-active' : ''">
          <a id='last_month' @click.prevent="selectionUpdate($event)">
            Last Month
          </a>
        </li>
        <li :class="selection === 'last_week' ? 'is-active' : ''">
          <a id='last_week' @click.prevent="selectionUpdate($event)">
            Last Week
          </a>
        </li>
        <li :class="selection === 'today' ? 'is-active' : ''">
          <a id='today' @click.prevent="selectionUpdate($event)">
            Today
          </a>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
export default {
  name: 'tickets-selection',
  props: ['selection'],
  methods: {
    selectionUpdate (event) {
      this.$emit('selection-update', event.target.id)
    }
  }
}
</script>

<style scoped>
</style>
