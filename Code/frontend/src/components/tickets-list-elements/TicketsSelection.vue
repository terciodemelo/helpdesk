<template>
  <div class="tickets-selection">
    <div class="tabs is-toggle">
      <ul id="status-selector">
        <li :class="open ? 'is-active' : ''">
          <a @click.prevent="toggleOpen">OPEN</a>
        </li>
        <li :class="closed ? 'is-active' : ''">
          <a @click.prevent="toggleClosed">CLOSED</a>
        </li>
      </ul>

      <ul id="age-selector">
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
  props: ['selection', 'closed', 'open'],
  methods: {
    selectionUpdate (event) {
      this.$emit('selection-update', event.target.id)
    },
    toggleOpen () {
      this.$emit('toggle-open')
    },
    toggleClosed () {
      this.$emit('toggle-closed')
    }
  }
}
</script>

<style scoped>
.tickets-selecion {
  display: flex;
  width: 100%;
}

#status-selector {
  margin-right: 5px;
}

#age-selector {
  margin-left: 5px;
}

ul > li > a {
  padding-top: 4px;
  padding-bottom: 5px;
}

</style>
